module LoginHelpers

  def signin(user)
    request.session[:user_id] = user.id
  end

end
