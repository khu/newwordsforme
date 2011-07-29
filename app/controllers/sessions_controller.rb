class SessionsController < ApplicationController
  def new
    @title = "Sign in"
    @tabs = Tabs.new.logged_out.select :signin
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      respond_to do |format|
        format.json {
          render :json => {:state => "failed"}
        }
        format.all{
          # Create an error message and re-render the signin form.
          flash.now[:error] = "Invalid email/password combination."
          @title = "Sign in"
          @tabs = Tabs.new.logged_out
          redirect_to root_path  
        }
      end
    else  
      respond_to do |format|
        format.json {
          sign_in user
          render :json  => {:state => "success", :data => user } 
        }
        format.all{
          sign_in user
          redirect_to user_path(user.id)
        }
      end
    end
  end
  
  def userid
    user = User.authenticate(params[:email],
                             params[:password])
    if user.nil?
      render :json => {:state => "failed"}
    else
      render :json  => {:state => "success", :id => user.id}
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
