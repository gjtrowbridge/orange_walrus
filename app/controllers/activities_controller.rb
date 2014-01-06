class ActivitiesController < ApplicationController
  before_action :signed_in_user, except: [:show, :index]

  def show
    @activity = Activity.find(params[:id])
  end

  def index

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
    def activity_params
      params.require(:activity).permit(:name, :description)
    end
end