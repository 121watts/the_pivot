class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_cart, :is_borrower?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # def current_cart
  #   if current_user
  #     items = session[:cart] || {}
  #     cart = Cart.find_or_initialize_by(user: current_user)
  #     cart.items ||= "{}"
  #     cart.items = items.to_json unless items.empty?
  #     cart.save
  #     @cart ||= cart
  #   else
  #     @cart = session[:cart] ||= {}
  #   end
  # end

  def is_borrower?
    current_user && current_user.role == 'borrower'
  end

  def check_user
    unless current_user
      login_with_flash
    end
  end

  def check_borrower
    unless is_borrower?
      login_with_flash
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  helper_method def cart
    @cart ||= (_session_cart || _create_cart)
  end

  helper_method def cart_count
    cart.loans ? cart.loans.count : 0
    # unless !cart.loans
    #   cart.loans.count
    # end
  end

  private

  def login_with_flash
    flash[:error] = 'You must be logged in to access that.'
    session[:last_page] = request.path
    redirect_to login_path
  end

  def _session_cart
    return unless session[:cart_id]
    @current_cart ||= Cart.find(session[:cart_id])
  end

  def _create_cart
    return if session[:cart_id]
    current_cart = Cart.create!
    session[:cart_id] = current_cart.id
    current_cart
  end
end
