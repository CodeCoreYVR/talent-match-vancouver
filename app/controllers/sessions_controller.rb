class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Thank you for logging in"
    else
      flash[:notice] = "Username or password invalid"
      render :new
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

end


