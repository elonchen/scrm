#encoding: utf-8
class ErrorNoAuthException < StandardError; end
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include PublicActivity::StoreController
  before_filter :blocked?

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_member!



  protected

  def blocked?
    if current_member.present? && current_member.is_blocked?
      sign_out current_member
      flash[:error] = "对不起，您已经被阻止登录！"
      new_member_session_path
    end
  end

  def check_for_admin
    unless current_member.has_role? :admin
      raise ErrorNoAuthException
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
