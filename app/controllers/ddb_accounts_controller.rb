class DdbAccountsController < ApplicationController
  before_action :set_ddb_account, only: [:show, :edit, :update, :destroy]

  # GET /ddb_accounts
  # GET /ddb_accounts.json
  def index
    @q = DdbAccount.search(params[:q])
    @ddb_accounts = @q.result(distinct: true).paginate(page: params[:page] || 1, per_page: params[:per_page] || 20)
  end

  # GET /ddb_accounts/1
  # GET /ddb_accounts/1.json
  def show
  end

  # GET /ddb_accounts/new
  def new
    @ddb_account = DdbAccount.new
  end

  # GET /ddb_accounts/1/edit
  def edit
  end

  # POST /ddb_accounts
  # POST /ddb_accounts.json
  def create
    @ddb_account = DdbAccount.new(ddb_account_params)

    respond_to do |format|
      if @ddb_account.save
        format.html { redirect_to @ddb_account, notice: 'Ddb account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ddb_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @ddb_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ddb_accounts/1
  # PATCH/PUT /ddb_accounts/1.json
  def update
    respond_to do |format|
      if @ddb_account.update(ddb_account_params)
        format.html { redirect_to @ddb_account, notice: 'Ddb account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ddb_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ddb_accounts/1
  # DELETE /ddb_accounts/1.json
  def destroy
    @ddb_account.destroy
    respond_to do |format|
      format.html { redirect_to ddb_accounts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ddb_account
      @ddb_account = DdbAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ddb_account_params
      params.require(:ddb_account).permit(:name, :customer_id, :email, :slug, :title, :member_id, :zone_id, :phone)
    end
end
