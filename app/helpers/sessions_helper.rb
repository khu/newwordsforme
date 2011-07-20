module SessionsHelper

  def sign_in(user)

    # cookies[:remember_token] = {
    #       :value => user.remember_token,
    #       :expires => 20.years.from_now.utc
    #     }
    cookies.permanent.signed[:remember_token] = [user.id, user.password]
    self.current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user=(user)
    @current_user = user
  end

  def user_from_remember_token
    User.authenticate_with_password(*remember_token) unless remember_token[0].nil?
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil,nil]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  ## Listing 10.13
  def current_user?(user)
    user == current_user
  end

  ## Listing 10.10
  def deny_access
    store_location ## Listing 10.16
    flash[:notice] = "Please sign in to access this page."
    redirect_to signin_path
  end

  ## Listing 10.16
  def store_location
    session[:return_to] = request.request_uri
  end

  ## Listing 10.16
  def redirect_back_or(default)
    redirect_to(session[:return_to].to_s || user_path(default).to_s)
    clear_return_to
  end

  ## Listing 10.16
  def clear_return_to
    session[:return_to] = nil
  end

  ## Listing 11.23 Moving the authenticate method from Users
  ## controller into the Sessions helper. By doing this, the
  ## authenticate method is now available in the Microposts
  ## controller.
  def authenticate
    deny_access unless signed_in?
  end

  ## Listing 11.23 Moving the authenticate method from Users
  ## controller into the Sessions helper. By doing this, the
  ## authenticate method is now available in the Microposts
  ## controller.
  def deny_access
    store_location
    flash[:notice] = "Please sign in to access this page."
    redirect_to(signin_path)
  end

end
