# coding: utf-8
class Gitlabot

  class << self
    def tweet(statistic)
      reply_users(statistic.user_id).each do |to|
        m = message(statistic)
        client.update("@#{to} #{m}")
      end
    end


    private

    def client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.secrets.twitter_consumer_key
        config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
        config.access_token        = Rails.application.secrets.twitter_access_token
        config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
      end
    end

    def reply_users(level_up_user_id)
      User.where.not(id: level_up_user_id).pluck(:twitter_id)
    end

    def message(statistic)
      url = Rails.application.routes.url_helpers.user_url(statistic.user_id)
      "#{statistic.user.username} さんがレベル #{statistic.level} に上がりました！\n#{url}"
    end
  end

end
