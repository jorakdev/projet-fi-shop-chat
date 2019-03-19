module CurrentCart
  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id]) || Cart.create #si carte n'existe pas alor créer cart 
    session[:cart_id] ||= @cart.id
  end
end
