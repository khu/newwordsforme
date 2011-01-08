require 'net/http'
require 'uri'

class WordsController < ApplicationController
  before_filter :authorize, :except => :login
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    words = params[:word].split('\n')
    words.each{ |single_word|
      translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ single_word + '&langpair=en|zh-CN'
      j = ActiveSupport::JSON
      encoded = j.decode(translated)
      @word = Word.new({:word=>single_word, :translation=>encoded["responseData"]["translatedText"]})      
      @word.save
    }

    respond_to do |format|
      format.html { redirect_to(@word, :notice => 'Word was successfully created.') }
      format.xml  { render :xml => @word, :status => :created, :location => @word }
    end
  end
  
  private
  def authorize
    #unless User.find_by_id(session[:user_id]) flash[:notice] = "Please log in" redirect_to :controller => :admin, :action => :login
    if not session[:user]
      session[:user] = User.find_by_id(params[:user_id])
    end
  end
end
