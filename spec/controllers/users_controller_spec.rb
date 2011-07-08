require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
      before(:each) do
        @user = Factory(:Figo)
      end

      it "should be successful" do
        get :show, :id => @user
        response.should be_success
      end

      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end
      
      it "should subscribe the rss results" do
        get :show, :id => @user.id, :format => :rss
        response.should be_success
        response.should have_selector("rss[version='2.0']")
        response.should have_selector("channel")
        response.should have_selector("title", :content => "Words")
        response.should have_selector("description", :content => "All the words which #{@user.name} is learning")
      end
      
      it "should subscribe all the words" do
        @user.word.create!(:word =>"new", :translation => "Xin de", :created_at => Time.new, :updated_at => Time.new)
        @user.word.create!(:word =>"go", :translation => "Jin ru", :created_at => Time.new, :updated_at => (Time.new - 60 * 60 * 24))
        get :show, :id => @user.id, :format => :rss
        
        @user.word.each do |word|
          response.should have_selector("description", :content => "#{word.word}")
          response.should have_selector("title", :content => "#{word.updated_at.to_date}")
        end
      end

      it "should subscribe all the words group by updated date" do
        @user.word.create!(:word =>"new", :translation => "Xin de", :created_at => Time.new, :updated_at => Time.new)
        @user.word.create!(:word =>"go", :translation => "Jin ru", :created_at => Time.new, :updated_at => (Time.new - 60 * 60 * 24))
        get :show, :id => @user.id, :format => :rss
        
        response.should have_selector("item", :count => 2)
        @user.word.each do |word|
          response.should have_selector("rss channel item title", :content => "#{word.updated_at.to_date}")
          response.should have_selector("rss channel item description", :content => "#{word.word} #{word.translation}")
        end
      end
  end
  
  describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end

      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Sign up")
      end
  end
  
  describe "POST 'create'" do
    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  end
end
