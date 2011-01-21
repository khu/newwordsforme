class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  
  def show
      @user = User.find(params[:id])
      @title = "Settings"
  end
  
  def new
      @user = User.new
      @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      ## Reset password input after failed password attempt
      @user.password = nil
      @user.password_confirmation = nil
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
