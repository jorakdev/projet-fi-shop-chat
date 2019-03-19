module SessionHelper

  def current_user
    User.find_by(id: session[:id])
  end

  def log_in(user)
   session[:user_id] = user.id
  end

end
