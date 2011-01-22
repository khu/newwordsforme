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

  def show
    puts "show method"
    @word = Word.find_by_user_id_and_word(params[:user_id], params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end
  
  def show_word
    puts "show word"
    @word = Word.find_by_user_id_and_word(params[:id], params[:word])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end
  
  # POST /users
  # POST /users.xml
  def create
    userid = params[:user_id]
    puts userid
    words = params[:word][:word].split('\n')
    words.each{ |single_word|
      translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ single_word + '&langpair=en|zh-CN'
      j = ActiveSupport::JSON
      encoded = j.decode(translated)
      @word = Word.new({:word=>single_word, :translation=>encoded["responseData"]["translatedText"], :user_id => userid})
      @word.save
    }

    respond_to do |format|
      format.html { redirect_to(show_word_path(User.find(userid), @word.word), :notice => 'Word was successfully created.') }
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
