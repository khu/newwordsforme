require 'net/http'
require 'uri'
require 'json'

class WordsController < ApplicationController
  before_filter :require_http_auth_user, :if => Proc.new { |c| c.request.format == 'json' }
  before_filter :require_user, :except => [:add_tag, :create]

  # GET /users
  # GET /users.xml
  def index
    today = params[:today].nil? ? DateTime.now : DateTime.parse(params[:today])
    mode = params[:mode].nil? ? "days7" : params[:mode]
    @user = User.find(params[:user_id])
    if @user.id != current_user.id
      @user = current_user
    else
      @words = @user.method(mode).call(today).order("updated_at").reverse

      respond_to do |format|
        format.html # index.html.erb
        format.xml { render :xml => @users }
        format.json { render :json => @words, :content_type => "text/html" }
      end
    end
  end

  def show
    @word = Word.find_by_user_id_and_word(params[:user_id], params[:id])

    respond_to do |format|
      format.html { redirect_to(user_path(@word.user)) }
      format.xml { render :xml => @user }
    end
  end

  def show_word
    @word = Word.find_by_user_id_and_word(params[:id], params[:word])
    respond_to do |format|
      format.html
      format.json { render :json => @word, :status => :created, :content_type => "text/html" }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    if params[:format]==nil
      user=current_user
    else
      user= current_user
      deny_access if user.nil?
    end
    if params[:word].nil?
      return
    end
    userid = params[:user_id]
    single_word = params[:word][:word].strip()
    old_word = Word.find_by_word_and_user_id(single_word, userid)
    if old_word==nil
      @word = Word.create({:word=>single_word, :user_id => userid})
      @word.translate!
      operation_success=@word.save
      @word.add_tag_by_name('unfamiliar')
    else
      @word = old_word
      operation_success=@word.update_attribute(:updated_at, Time.now)
      @word.save
    end

    if operation_success
      respond_to do |format|
        format.json { render :json => @word, :status => :created }
        format.html { redirect_to(user_path(@word.user).to_s) }
      end
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

  def delete_tag

    tagId=Tag.find_by_name(params[:word][:tag])
    if (not Word.exists? params[:word][:word_id]) || (not Tag.exists? params[:word][:tag_id]) || tagId.nil?#params[:word][:tag].length == 0
      render :json => {:state => "failure"}
      return
    end
    WordTagRelation.find_by_word_id_and_tag_id(params[:word][:word_id],tagId).destroy
    render :json => {:state => "deleted"}
  end

  def get_word_tags
    word = Word.find(params[:id])
    tags = word.tags

    respond_to do |format|
      format.json { render :json => tags }
    end
  end

  def update_tag
    word = Word.find(params[:word][:word_id])
    hash = {:oldTag => "#{params[:word][:oldTag]}", :newTag => "#{params[:word][:newTag]}"}
    word.update_tag_by_new_name(hash)
    respond_to do |format|
      format.json { render :json => 'updated' }
    end
  end

  def update_words
    words = params[:words]
    words.each do |upLoadWord|
      word = Word.find(upLoadWord[:id])
      if word.updated_at < upLoadWord[:updated_at]
        word.update_attribute(:updated_at, upLoadWord[:updated_at])
        hash = {:oldTag => word.tag_names.join(","), :newTag => upLoadWord[:tag]}
        word.update_tag_by_new_name(hash)
      end
    end

    render :json => {:state => "updated"}
  end
end
