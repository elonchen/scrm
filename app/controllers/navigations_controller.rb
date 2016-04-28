class NavigationsController < ApplicationController
  before_action :set_navigation, only: [:show, :edit, :update, :destroy]
  before_filter :check_for_admin, only:[:show, :edit, :update, :destroy]

  # GET /navigations
  # GET /navigations.json
  def index
    @navigations = Navigation.all
  end

  # GET /navigations/1
  # GET /navigations/1.json
  def show
  end

  # GET /navigations/new
  def new
    @navigation = Navigation.new
  end

  # GET /navigations/1/edit
  def edit
  end

  # POST /navigations
  # POST /navigations.json
  def create
    @navigation = Navigation.new(navigation_params)

    respond_to do |format|
      if @navigation.save
        format.html { redirect_to @navigation, notice: 'Navigation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @navigation }
      else
        format.html { render action: 'new' }
        format.json { render json: @navigation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /navigations/1
  # PATCH/PUT /navigations/1.json
  def update
    respond_to do |format|
      if @navigation.update(navigation_params)
        format.html { redirect_to @navigation, notice: 'Navigation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @navigation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /navigations/1
  # DELETE /navigations/1.json
  def destroy
    @navigation.destroy
    respond_to do |format|
      format.html { redirect_to navigations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_navigation
      @navigation = Navigation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def navigation_params
      params.require(:navigation).permit(:name, :link)
    end
end
