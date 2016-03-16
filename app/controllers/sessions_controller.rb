class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Thank you for logging in"
      redirect_to root_path
    else
      flash[:alert] = "Username or password invalid"
      render :new
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to signup_path, notice: "Logged out!"
  end

end
