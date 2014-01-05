class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    def not_already_signed_in
      if signed_in?
        redirect_to root_url, notice: "Already signed in as '#{current_user.display_name}'"
      end
    end
end
