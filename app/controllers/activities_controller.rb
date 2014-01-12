class ActivitiesController < ApplicationController
  before_action :signed_in_user, except: [:show, :index]
  before_action :correct_user_for_activity, only: [:edit, :update, :destroy]

  def show
    @activity = Activity.find(params[:id])
    if @activity.user == current_user
      @can_edit= true
    elsif !current_user.nil?
      if current_user.admin?
        @can_edit = true
      else
        @can_edit = false
      end
    else
      @can_edit = false
    end
  end

  def index
    @activities = Activity.paginate(page: params[:page], per_page: 10)
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
    def correct_user_for_activity
      @activity = Activity.find(params[:id])
      unless current_user?(@activity_user) || current_user.admin?
        redirect_to(activity_path(@activity), notice: "You do not have permission to modify this activity.")
      end
    end
end