# coding: utf-8
class Users::RegistrationsController < Devise::RegistrationsController

  prepend_before_filter :require_no_authentication, :only => [ :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:new, :create ,:edit, :update, :destroy]

  def new
    unless current_user.try(:admin?)
      path = current_user ? current_user : root_path
      options = {flash: {warning: "新規ユーザを作成する権限がありません"}}
      return redirect_to path, options
    end

    super
  end


  private

  # ユーザ作成後にそのユーザでログインしない
  def sign_up(resource_name, resource)
  end

end
