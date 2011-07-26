require 'net/http'
require 'uri'
require 'json'

class WordsController < ApplicationController
  before_filter :authenticate, :except => [:add_tag, :create]
  # GET /users
  # GET /users.xml
  def index
    today  = params[:today].nil? ? DateTime.now : DateTime.parse(params[:today])
    mode   = params[:mode].nil? ? "days7" : params[:mode]
    @user  =  User.find(params[:user_id])
    if @user.id != current_user.id
      @user=current_user
    else
      @words = @user.method(mode).call(today).order("updated_at").reverse
      puts @words
      @tabs = Tabs.new.logged_in(@user)
    
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
        format.json { render :json => @words, :content_type => "text/html"}
      end
    end
  end

  def show
    @word = Word.find_by_user_id_and_word(params[:user_id], params[:id])
    
    respond_to do |format|
      format.html {redirect_to(user_path(@word.user))}
      format.xml  { render :xml => @user }
    end
  end
  
  def show_word
    @word = Word.find_by_user_id_and_word(params[:id], params[:word])
    respond_to do |format|
      format.html
      format.json { render :json => @word, :status => :created, :content_type => "text/html"}
    end
  end
  
  # POST /users
  # POST /users.xml
  def create
    if params[:format]==nil 
      user=current_user
    else
      user=User.authenticate_with_password(params[:user_id], params[:password])
      deny_access unless user.nil?
    end
    userid = params[:user_id]
    single_word = params[:word][:word].strip()
    old_word = Word.find_by_word_and_user_id(single_word,userid)
    if old_word==nil
      @word =  Word.create({:word=>single_word, :user_id => userid})
      @word.translate!
      operation_success=@word.save
      add_unfamiliar_tag_when_word_create(@word)
    else
      @word = old_word
      operation_success=@word.update_attribute(:updated_at, Time.now)
      @word.save
    end
    if operation_success
      respond_to do |format|
        format.json { render :json => @word, :status => :created }
        format.html {redirect_to(user_path(@word.user).to_s)}
      end
    end
  end
  
  def add_unfamiliar_tag_when_word_create(word)
    if Tag.find_by_name('unfamiliar')
      word.tags.push(Tag.find_by_name('unfamiliar'))
    else
      word.tags.create!(:name => 'unfamiliar')
    end
  end
  
  def add_tag
   if (not Word.exists? params[:word][:word_id]) || params[:word][:tag].length == 0
     render :json => {:state => "failure"}
     return 
   end
   
    word = Word.find(params[:word][:word_id])
    
    if Tag.find_by_name(params[:word][:tag])
      tag = Tag.find_by_name(params[:word][:tag])
      if word.tags.include? tag
        render :json => {:state => "attached"}
        return
      end
      word.tags << Tag.find_by_name(params[:word][:tag])
      word.save
      
    else
      tag = word.tags.create(:name => params[:word][:tag])
      tag.save
    end
    render :json => {:state => "created"}
  end
  
  def get_word_tags
    word = Word.find(params[:id])
    tags = word.tags
  
    respond_to do |format|
      format.json { render :json => tags }
    end
  end
end
