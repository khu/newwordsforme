class PagesController < ApplicationController
  layout "index-page-layout"
  
  def home
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
  
end
