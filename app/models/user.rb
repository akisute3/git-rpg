# coding: utf-8
class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :authentication_keys => [:login]

  validates :username, presence: true, format: { with: /\A[a-zA-Z0-9_\.]*\Z/ }
  validates :twitter_id, presence: true

  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end


  has_one :user_statistic
  before_create :build_default_statistic

  has_many :authors, dependent: :destroy


  # 初期ユーザ作成
  def self.create_default_user
    user = APP_CONFIG[:default_user]
    User.create(username: user[:username],
                password: user[:password],
                email: user[:email],
                twitter_id: user[:twitter_id],
                admin: true)
  end

  private
    def build_default_statistic
      build_user_statistic
      true
    end

end
