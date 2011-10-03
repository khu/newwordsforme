require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_http_auth_user, :if => Proc.new { |c| c.request.format == 'json' }
  before_filter :require_user, :only => [:show, :edit, :update]
  skip_before_filter :require_user, :if => Proc.new { |c| c.request.format == 'rss' }

  def show
    @user = User.find(params[:id])
    if (request.format != 'rss' && @user.id != current_user.id)
      redirect_to(user_path(current_user))
    end
    @title = "Show words"
    if params[:date].nil?
      @words = Word.find(:all, :conditions => ["user_id = ?", @user.id], :order => "updated_at DESC")
    else
      @words = Word.find(:all, :conditions => ["user_id = ? and updated_at > ?", @user.id, DateTime.parse(params[:date])], :order => "updated_at DESC")
    end
  end

  def show_word_by_tag
    @user = current_user
    if (request.format != 'rss' && @user.id != current_user.id)
      redirect_to(user_path(current_user))
    end

    if params[:name] == "all"
      @words = @user.word.order("updated_at DESC")
    else
      @words = @user.word.order("updated_at DESC").find_all do |word|
        if word.tags.find_by_name(params[:name])
          word.id
        end
      end
    end
    respond_to do |format|
      format.json { render :json => @words, :content_type => "text/html" }
      format.js
    end

  end

  def new
    @user = User.new
    @title = "Sign up"
    render 'new'
  end

  def create
   @user = User.new(params[:user])
   if @user.save
     flash[:notice] = "Account registered!"
     redirect_back_or_default "/users/#{@user.id}"
   else
     @title = "Sign up"
     @user.password = nil
     @user.password_confirmation = nil
     render :action => :new
   end    
  end

  def signed_in_user
    if current_user?(@user)
      flash[:success] = "You are already signed in"
    else
      redirect_to root_path
    end
  end
  
  def sign_up
    @title = "Sign up"
    print "This is sign_up method. \n"
    render 'signup'
  end
end
