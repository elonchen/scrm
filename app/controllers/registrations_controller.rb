#encoding: utf-8
class RegistrationsController < Devise::RegistrationsController
  def new
    flash[:error] = '暂未开放注册'
    redirect_to root_path
  end

  def create
    flash[:error] = '暂未开放注册'
    redirect_to root_path
  end
end