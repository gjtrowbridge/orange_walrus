class SessionsController < ApplicationController
  before_action :not_already_signed_in, only: [:new, :create]
  def new
  end
  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      #Sign in the user and redirect to user page
      sign_in user
      redirect_back_or user
    else
      #Create error message and re-render signin form
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy
    sign_out
    redirect_to root_url
  end
end
