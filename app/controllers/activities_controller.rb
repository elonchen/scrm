class ActivitiesController < ApplicationController
  def index
    @activities =  PublicActivity::Activity.order("created_at desc").paginate(page: params[:page], :per_page => 25)
  end

  def show
  end
end
