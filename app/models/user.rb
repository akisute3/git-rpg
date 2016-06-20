class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :authentication_keys => [:login]

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

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


  private
    def build_default_statistic
      build_user_statistic
      true
    end

end
