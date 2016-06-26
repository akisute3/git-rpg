# coding: utf-8
class GitlabController < ApplicationController

  protect_from_forgery with: :null_session

  def push
    json = JSON.parse(request.body.read, {:symbolize_names => true})

    # プッシュしたユーザの確定
    name, email = json[:user_name], json[:user_email]
    pushing_user = User.find_by(username: name, email: email) || Author.find_by(name: name, email: email)&.user
    unless pushing_user
      render text: 'User not found.'
      return
    end

    # リポジトリレコードがなければ作成
    repo = Repository.find_or_create_by(project_id: json[:project_id]) do |r|
      r.mst_git_service = MstGitService.find_by(name: "GitLab")
      r.name = json[:project][:name]
      r.homepage = json[:project][:homepage]
    end

    # プッシュレコード作成
    push = Push.create(repository_id: repo.id)

    # commit レコード作成
    json[:commits].each do |c|
      author = Author.find_by(name: c[:author][:name], email: c[:author][:email])
      next if author.user != pushing_user

      commit = Commit.create(
        author_id: author.id,
        push_id: push.id,
        commit_hash: c[:id],
        message: c[:message],
        timestamp: c[:timestamp],
        url: c[:url],
      )

      instances =
        file_instances(c[:added], "ADDED", commit.id) +
        file_instances(c[:modified], "MODIFIED", commit.id) +
        file_instances(c[:removed], "REMOVED", commit.id)
      commit.commit_files << instances
    end

    # 経験値追加
    pre_level = pushing_user.user_statistic.level
    statistic = UserStatistic.add_exp(pushing_user, push)

    # レベルアップを知らせるツイート
    Gitlabot.tweet(statistic) if statistic.level > pre_level

    render text: 'OK'
  rescue
    render text: 'NG'
  end


  private

    def file_instances(files, operation, commit_id)
      instances = []
      files.each do |f|
        instances << CommitFile.new(
          commit_id: commit_id,
          path: f,
          mst_commit_operation_id: MstCommitOperation.find_by(name: operation).id
        )
      end

      instances
    end

end
