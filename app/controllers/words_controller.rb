require 'net/http'
require 'uri'

class WordsController < ApplicationController
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
    user = find_user
    translated = Net::HTTP.get 'ajax.googleapis.com', '/ajax/services/language/translate?v=1.0&q='+ params[:word] + '&langpair=en|zh-CN'
    j = ActiveSupport::JSON
    encoded = j.decode(translated)
    @word = Word.new({:word=>params[:word], :translation=>encoded["responseData"]["translatedText"]})
    
    
    respond_to do |format|
      if @word.save
        format.html { redirect_to(@word, :notice => 'Word was successfully created.') }
        format.xml  { render :xml => @word, :status => :created, :location => @word }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @word.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def find_user 
    if not session[:user]
      session[:user] = User.find_by_id(params[:user_id])
    end
  end
end
