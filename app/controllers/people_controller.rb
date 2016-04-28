class PeopleController < ApplicationController
  before_filter :check_for_admin
  before_action :set_person, only: [:show]

  def index
    @q = Person.search(params[:q])
    @people = @q.result(distinct: true).paginate(page: params[:page], :per_page => 25)
  end

  def show
  end

end