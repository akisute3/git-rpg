# coding: utf-8
class UserStatistic < ActiveRecord::Base
  belongs_to :user

  DATE_FIRST_COMMIT_EXP = 10
  ADDED_FILE_EXP = 3
  MODIFIED_FILE_EXP = 1

  class << self
    # 引数は Push インスタンス。
    # 経験値獲得後の UserStatistic インスタンスを返す
    def add_exp(user, push)
      statistic = UserStatistic.find_by(user_id: user.id)
      statistic.exp += exp(user, push)
      statistic.level = MstLevelUpExp.where("exp <= ?", statistic.exp).maximum(:level)
      statistic.save

      statistic
    end

    # 経験値を確定して返す
    def exp(user, push)
      added_exp = 0
      push.commits.each do |commit|
        # その日最初の commit
        commit_date = commit.timestamp.to_date
        authors = user.authors.pluck("authors.id")
        today_first_commit = Commit.where(author_id: authors)
                             .where(timestamp: commit_date.beginning_of_day..commit_date.end_of_day)
                             .order(:timestamp)
                             .first
        added_exp += DATE_FIRST_COMMIT_EXP if commit.id == today_first_commit.id

        # ファイル追加、修正
        commit.commit_files.each do |file|
          added_exp += ADDED_FILE_EXP if file.mst_commit_operation.name == "ADDED"
          added_exp += MODIFIED_FILE_EXP if file.mst_commit_operation.name == "MODIFIED"
        end
      end

      added_exp
    end
  end
end
