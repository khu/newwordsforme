require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create, :sign_up]
  skip_before_filter :authenticate, :if => Proc.new { |c| c.request.format == 'rss' }

  def show
    @user = User.find(params[:id])
    if (request.format != 'rss' && @user.id != current_user.id)
      redirect_to(user_path(current_user))
    end
    @tabs = Tabs.new.logged_in @user
    @title = "Show words"

    if params[:date].nil?
      @words = Word.find(:all, :conditions => ["user_id = ?", @user.id], :order => "updated_at DESC")
    else
      @words = Word.find(:all, :conditions => ["user_id = ? and updated_at > ?", @user.id, DateTime.parse(params[:date])], :order => "updated_at DESC")
    end
    #@wordsList = @words.paginate(:per_page => 8, :page => params[:page])
  end


  def show_word_by_tag

    @user = User.find(params[:id])
    if (request.format != 'rss' && @user.id != current_user.id)
      redirect_to(user_path(current_user))
    end
    @tabs = Tabs.new.logged_in @user

    if params[:name] == "all"
      @words = @user.word.order("updated_at DESC")
    else
      @words = @user.word.order("updated_at DESC").find_all do |word|
        if word.tags.find_by_name(params[:name])
          word.id
        end
      end
    end
    # @title = "Show words by tag"
    @wordsReverse = @words.reverse
    #@wordsList = @wordsReverse.paginate(:per_page => 8, :page => params[:page])
    respond_to do |format|
      format.json { render :json => @wordsReverse, :content_type => "text/html" }
      format.js
    end

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
      user = User.authenticate(@user.email, @user.password)
      sign_in user
      #flash[:success] = "Welcome to keepin!"
      #redirect_to user_path(user.id)
      redirect_to "/users/#{user.id}"
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
      redirect_to root_path # unless current_user?(@user)
    end
  end
  
  def sign_up
    @tabs = Tabs.new.logged_in @user
    @title = "Sign up"
    print "This is sign_up method. \n"
    render 'signup'
  end
end
