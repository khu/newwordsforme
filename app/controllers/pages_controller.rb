class PagesController < ApplicationController


  def home
    logger.info(user_path(current_user))
    if !current_user.nil?
      redirect_to(user_path(current_user))
    end
    @title = "Home"
    @tabs = Tabs.new.logged_out
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
      @tabs = Tabs.new.logged_out
    else
      @tabs = Tabs.new.logged_in current_user
    end
  end
end
