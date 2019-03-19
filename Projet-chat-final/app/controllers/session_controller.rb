class SessionController < ApplicationController

  def new
  end

  def create # login(create un session login)

    mail = params[:mailaka]
    login = User.find_by(email: mail)

    if login && login.authenticate(params[:pwd]) #pwd ilay mirecuperer anilay mot de passe any am html page/acceuil

       session[:id] = login.id # par defaut an rails

       # redirect_to page_index_path #ilay azo avy any aminy rails routes mila apina _path
       redirect_to root_path

      else
      redirect_to '/'
    end

  end


    def destroy
      session.delete(:id)
      redirect_to '/'
    end



end
