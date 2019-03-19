class CartsController < ApplicationController
  before_action :authenticate_user, only: [:show, :edit, :update, :destroy]
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all

  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
    @in_checkout = Checkout.all

  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @@a = Checkout.all
    #debut cart
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { }#redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end

      @amount = "500" #params[:total_price].to_s
      # puts "***************#{@amount}"
      @checkout = Checkout.create(cart_id: params[:cart_id], total_price: params[:total_price], user_id: params[:user_id])
      # puts "*************#{params[:cart_id]}"
      # puts "*******************#{params[:total_price]}"
      # puts "***********************#{params[:user_id]}"
      @checkout.save
      #stripe
      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        source: params[:stripeToken],
      })

      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount,
        description: 'Rails Stripe customer',
        currency: 'usd',
      })

      @@a.each do |a|
        # puts "************#{a.cart_id}"
        # puts "************#{a.total_price}"
        # puts "************#{a.user_id}"
        if current_user.id == a.user_id
          @cart_id_last = a.cart_id
          @current_user_last = a.user_id
          @current_total_last_to_pay = a.total_price
        end
      end
      # puts "********************#{@cart_id_last}"
      # puts "************************#{@current_user_last}"
      # puts "****************************#{@current_total_last_to_pay}"
      # puts "*******************************#{customer.id}"
      # puts "**********************************#{params[:stripeEmail]}"
      # puts "************************************#{params[:stripeToken]}"

      @payer = Payer.create(cart_id: @cart_id_last, current_user_id: @current_user_last,
        total_to_pay: @current_total_last_to_pay, customer_id: customer.id, custumer_email: params[:stripeEmail],
        token: params[:stripeToken])

      @payer.save

    rescue Stripe::CardError => e
      flash[:error] = e.message
      @cart.destroy
      session.delete(:cart_id)
      redirect_to new_cart_path
    end
  end


  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    session.delete(:cart_id)

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    #only for specified current_user
    def authenticate_user
      unless current_user
        flash[:danger] = "Please log in."
        redirect_to new_session_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {})
    end
end
