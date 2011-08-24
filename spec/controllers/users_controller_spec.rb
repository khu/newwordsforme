require 'spec_helper'

describe UsersController do
  render_views
  describe "unsign and GET 'show'" do
    before(:each) do
      @user = Factory(:Figo)
    end 
    it "should be successful" do
      get :show, :id => @user
      response.should_not be_success
    end
    
    it "should deny access" do
      get :show, :id => @user
      response.should redirect_to(root_path)
    end
    
     it "should subscribe the rss results" do
        get :show, :id => @user.id, :format => :rss 
        response.should be_success
        response.should have_selector("rss[version='2.0']")
        response.should have_selector("channel")
        response.should have_selector("title", :content => "Words")
        response.should have_selector("description", :content => "All the words which #{@user.name} is learning")
      end
      
      
    it "should display the all rss feed when given date is very old" do
     @user.word.create!(:word =>"new", :translation => "Xin de", :created_at => Time.new, :updated_at => DateTime.civil(2010, 2, 14, 11, 12, 13, 0))
     @user.word.create!(:word =>"go", :translation => "Jin ru", :created_at => Time.new, :updated_at => DateTime.civil(2010, 2, 14, 10, 12, 13, 0))

      get :show, :id => @user.id, :format => :rss, :date => DateTime.civil(2010, 2, 14, 10, 12, 12, 0).to_s
      response.should be_success
      @user.word.each do |word|
        response.should have_selector("rss channel item title", :content => "#{word.word}")
      end
    end

    it "should display the specific rss feed newer than the provided date" do
      @user.word.create!(:word =>"new", :translation => "Xin de", :created_at => Time.new, :updated_at => DateTime.civil(2010, 2, 14, 11, 12, 13, 0))
      @user.word.create!(:word =>"go", :translation => "Jin ru", :created_at => Time.new, :updated_at => DateTime.civil(2010, 2, 14, 10, 12, 13, 0))

      get :show, :id => @user.id, :format => :rss, :date => DateTime.civil(2010, 2, 14, 10, 30, 12, 0).to_s
      response.should be_success

      response.should have_selector("rss channel item title", :content => "new")
      response.should_not have_selector("rss channel item title", :content => "go")
     end
         
      it "should subscribe all the words" do
        word1 = @user.word.create!(:word =>"new", :translation => "Xin de", :created_at => Time.new, :updated_at => Time.new)
        word2 = @user.word.create!(:word =>"go", :translation => "Jin ru", :created_at => Time.new, :updated_at => (Time.new - 60 * 60 * 24))
        test_sign_in(@user)
        word1.tags.create!(:name => "unfamiliar")
        word2.tags.create!(:name => "familiar")
        get :show, :id => @user.id, :format => :rss
        
        
        @user.word.each do |word|
          response.should have_selector("rss channel item title", :content => "#{word.word}")
          response.should have_selector("rss channel item description", :content => "#{word.translation}")
          response.should have_selector("rss channel item pubdate", :content => "#{word.updated_at}")
          response.should have_selector("rss channel item category", :content => "#{word.id}")
          response.should have_selector("rss channel item category", :domain => 'id')
          response.should have_selector("rss channel item category", :domain => 'tags')
        end
         
        response.body.include?("<category domain=\"tags\">familiar</category>").should be_true
      end
  end
  
  describe "sign and GET 'show' other user" do
    before(:each) do
      @user = Factory(:Figo)
      test_sign_in(@user)
      @other_user = Factory(:Rick)
    end 
    it "should be successful" do
      get :show, :id => @other_user
      response.should_not be_success
    end
    
    it "should deny access" do
      get :show, :id => @other_user
      response.should redirect_to(user_path(@user))
    end
  end
  describe "sign in and GET 'show'" do
      before(:each) do
        @user = Factory(:Figo)
        test_sign_in(@user)
      end

      it "should be successful" do
        get :show, :id => @user
        response.should be_success
      end

      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
      end

      it "should subscribe all the words group by updated date" do
        @user.word.create!(:word =>"new", :translation => "Xin de", :created_at => Time.new, :updated_at => Time.new)
        @user.word.create!(:word =>"go", :translation => "Jin ru", :created_at => Time.new, :updated_at => (Time.new - 60 * 60 * 24))
        get :show, :id => @user.id, :format => :rss
        
        response.should have_selector("item", :count => 2)
        @user.word.each do |word|
          response.should have_selector("rss channel item title", :content => "#{word.word}")
          response.should have_selector("rss channel item description", :content => "#{word.translation}")
          response.should have_selector("rss channel item pubdate", :content => "#{word.updated_at}")
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
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
        end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end    
    end
  end
end
