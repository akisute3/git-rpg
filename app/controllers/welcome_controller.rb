class WelcomeController < ApplicationController
  def index
    User.create_default_user unless User.exists?
  end
end
