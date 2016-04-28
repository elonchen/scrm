class RelationshipsController < ApplicationController
  def index
    @managers_ids = Relationship.select(:manager_id).distinct
    @managers = []
    @managers_ids.each do |mids|
      @managers << Member.find(mids.manager_id)
    end
  end
  def show
    @manager = Member.find(params[:id])
    @workers = @manager.workers.paginate(page: params[:page], :per_page => 25)
    @members = Member.all.paginate(page: params[:page], :per_page => 25)
  end

  def create
    @manager = Member.find(params[:manager_id])
    @worker = Member.find(params[:worker_id])
    @workers = @manager.workers.paginate(page: params[:page], :per_page => 25)
    @members = Member.all.paginate(page: params[:page], :per_page => 25)
    @manager.manage(@worker)
    respond_to do |format|
      format.html { redirect_to @workers, @members }
      format.js
    end
  end

  def destroy
    @manager = Member.find(Relationship.select(:manager_id).where(id = params[:id]).first.manager_id)
    @worker  = Member.find(Relationship.select(:worker_id).where(id = params[:id]).first.worker_id)
    @workers = @manager.workers.paginate(page: params[:page], :per_page => 25)
    @members = Member.all.paginate(page: params[:page], :per_page => 25)
    @manager.unmanage(@worker)
    respond_to do |format|
      format.html { redirect_to @workers, @members }
      format.js
    end
  end
end
