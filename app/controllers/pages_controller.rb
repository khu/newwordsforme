class PagesController < ApplicationController


  def home
    if !current_user.nil?
      redirect_to(user_path(current_user))
    end
    @title = "Home"
  end

  def help
    @title = "Help"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def addons
    @title = "Addons"
    if current_user.nil?
    else
    end
  end
end
