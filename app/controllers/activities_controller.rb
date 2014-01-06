class ActivitiesController < ApplicationController
  before_action :signed_in_user, except: [:show, :index]

  def show
    @activity = Activity.find(params[:id])
  end

  def index

  end

  def new
    @activity = current_user.activities.build if signed_in?
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      flash[:success] = "Activity created!"
      redirect_to @activity
    else
      render 'new'
    end
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