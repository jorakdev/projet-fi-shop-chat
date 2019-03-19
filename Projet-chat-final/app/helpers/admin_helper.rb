module AdminHelper
  def current_admin
    Admin.find_by(id: session[:admin_id])
 end

  def log_in(admin)
    session[:admin_id] = admin.id
 end
end
