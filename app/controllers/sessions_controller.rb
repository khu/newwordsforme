class SessionsController < ApplicationController
  def new
    @title = "Sign in"
    @tabs = Tabs.new.logged_out.select :signin
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])

    if user.nil?
      # Create an error message and re-render the signin form.
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      @tabs = Tabs.new.logged_out
      render 'new'
    else
      sign_in user
      redirect_to user_path(user)
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
