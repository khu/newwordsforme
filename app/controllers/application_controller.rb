class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def current_user= user
    @current_user = user
  end  

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.url
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def require_http_auth_user
    unless current_user
      logger.info ("no current user has been defined anywhere." )
      authenticate_or_request_with_http_basic do |email, password|
          logger.info("@current_user.valid_password?(password)" + @current_user.valid_password?(password).to_s)
          if @current_user = User.find_by_email(email) 
            @current_user.valid_password?(password)
          else
            false
          end
      end
    end
    return true
  end
end
