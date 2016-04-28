#encoding: utf-8
class AlarmsController < ApplicationController
  before_action :set_alarm, only: [:close]


  def close
    @alarm.do_close!
    render :json => {
               success: true
           }
  end

  private
  def set_alarm
    @alarm = current_member.alarms.find(params[:id])
  end
end

