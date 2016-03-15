class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user
      user.generate_password_reset_token!
      PasswordMailer.password_reset(user).deliver_now
      redirect_to root_path, notice: "Password reset instructions sent. Please check your email."
    else
      flash[:alert] = "Email not found."
      render action: 'new'
    end
  end

  def edit
    @user = User.friendly.find_by_password_reset_token params[:id]
    if @user
    else
      render file: 'public/404.html', status: :not_found
    end
  end

  def update
    @user = User.find_by_password_reset_token params[:id]
    if @user && @user.update_attributes(user_params)
      @user.update_attribute(:password_reset_token, nil)
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Password updated."
    else
      flash[:alert] = "Password reset token not found."
      render action: 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
