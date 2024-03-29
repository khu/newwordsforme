class Tabs
  
  def initialize
    @tabs = []
  end
  
  def logged_in user
    @tabs = []
    @tabs << Tab.new(:home , 'Home', root_path)
    @tabs << Tab.new(:addons, 'Addons', addons_path)
    @tabs << Tab.new(:signin, 'Sign out', signout_path)
    @tabs.reverse!
    return self
  end

  def logged_out
    @tabs = []
    @tabs << Tab.new(:home , 'Home', root_path)
    @tabs << Tab.new(:addons, 'Addons', addons_path)
    @tabs.reverse!
    return self
  end
  
  def select id
    @tabs.each { |tab|
      tab.css = "" unless tab.id == id
      tab.css = "selected" if tab.id == id
    }
    return self
  end  
  
  def each(&blk)
      @tabs.each(&blk)
  end
end

class Tab
  attr_accessor :id, :label, :url, :css
  
  def initialize id, label, url
    @id = id
    @label = label
    @url = url
  end
end
