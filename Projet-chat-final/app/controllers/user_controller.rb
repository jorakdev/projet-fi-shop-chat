class UserController < ApplicationController

  def new
  end

  def create

  	puts '*' * 100

  	User.create(nom: params[:Nom] , prenom: params[:Prenom] , age: params[:Age] , email: params[:Email] , password: params[:password])
  	redirect_to '/session/new'
  end
end
