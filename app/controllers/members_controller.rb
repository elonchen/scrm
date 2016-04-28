#encoding: utf-8
class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update]
  before_filter :check_for_admin, only: [:new, :create]
  def index
    @members = Member.all
  end

  def show
  end

  def edit
  end

  def new
    @member = Member.new
    render 'new'
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to member_url(@member), :notice => "Successfully created member."
    else
      render :action => 'new'
    end
  end

  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    if current_member.has_role? :admin
      params.require(:member).permit(:name, :email, :password, :can_accept_new, :customer_share_threshold, :is_blocked, :department_id, :bank_card_type, :bank_card_number)
    elsif current_member == @member
      params.require(:member).permit(:name)
    end
  end
end
