class AdminController < ApplicationController
  def new; end

  def create
     admin_input_email = params[:email]
     admin_input_password = params[:password]

    puts admin = Admin.find_by(email: admin_input_email)

    if admin && admin.authenticate(admin_input_password)
      # puts "tafiditra"
      session[:admin_id] = admin.id
      redirect_to products_path

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    session.delete(:admin_id)
    redirect_to root_path
  end
end
