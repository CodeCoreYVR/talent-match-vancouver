class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @user ||= User.find(session[:user_id]) if user_signed_in?
  end

  def user_signed_in?
    session[:user_id].present?
  end

  def authorize
    redirect_to login_path, notice: "Not authorized" if current_user.nil?
  end

  # helper_method makes these methods available in the views
  helper_method :current_user
  helper_method :user_signed_in?
end
