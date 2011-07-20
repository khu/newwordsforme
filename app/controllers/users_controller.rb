class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  
  def show
      tag_name = params[:name]
      @user = User.find(params[:id])
      
      if !current_user.id
        deny_access
      end
      if @user.id != current_user.id
        redirect_to(user_path(current_user))
      end
      @tabs = Tabs.new.logged_in @user
      # if tag_name
      #   @words = Array.new
      #   @user.word.each do |word|
      #     is_has_tag = false
      #     word.tags.each do |tag|
      #       if tag.name == tag_name
      #         is_has_tag = true
      #         break
      #       end
      #     end
      # 
      #     if is_has_tag
      #       @words.push(word)
      #     end
      # 
      #   end
      # else
      #   @words = @user.word.reverse;
      # end
      @words = @user.word.reverse;
      @title = "Settings"
      
      @word_list = Word.find(:all, :conditions => "user_id = #{@user.id}", :order => "updated_at DESC")
  end
  
  def show_word_by_tag
    tag_name = params[:name]
    @user = User.find(params[:id])
    @words = @user.word.find_all do |word|
      if word.tags.find_by_name(tag_name)
        word.id
      end
    end
    @title = "Show words by tag"
    @words.reverse
  end
  
  def new
      @user = User.new
      @title = "Sign up"
      @tabs = Tabs.new.logged_out
      render 'new'
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to keepin!"
      redirect_to @user
    else
      @title = "Sign up"
      ## Reset password input after failed password attempt
      @user.password = nil
      @user.password_confirmation = nil
      @tabs = Tabs.new.logged_out
      render 'new'
    end
  end
  
  def signed_in_user
    if current_user?(@user)
      flash[:success] = "You are already signed in"
    else
      redirect_to root_path# unless current_user?(@user)
    end
  end  
end
