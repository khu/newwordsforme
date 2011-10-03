require 'spec_helper'

describe UserSessionsController do
  render_views


  # GET NEW =========================================================
  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should contain("Sign in")
    end

  end # GET new

  # POST CREATE =====================================================
  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :user_session => {:email => "email@example.com", :password => "123456" }}
      end

      it "should redirect to home page" do
        post :create, :session => @attr
        redirect_to root_path
      end

    end # "invalid signin"

    describe "with valid email and password" do

      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => "123456"}
      end

      it "should sign the user in" do
        post :create, :user_session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        post :create, :user_session => @attr
        redirect_to user_path(@user)
      end

    end
    
    describe "valid signin json" do

        before(:each) do
          @user = Factory(:Rick)
          @attr = { :email => @user.email, :password => "123456" }
          end

          it "should redirect to home page" do
            post :create, :session => @attr ,:format => :json
            controller.should be_signed_in
            result = JSON.parse(response.body)
            result['state'].include?("success").should be_true
            result['data']['user']['id'].should == @user.id
            result['data']['user']['name'].should == @user.name
          end
        end # "valid signin json"
     

  end # "POST create"

  # DELETE DESTROY ==================================================
  describe "DELETE 'destroy'" do

    it "should sign a user out" 
    # do
    #       test_sign_in(Factory(:user))
    #       controller.should be_signed_in
    #       delete :destroy
    #       controller.should_not be_signed_in
    #       response.should redirect_to(root_path)
    #     end

  end # "DELETE 'destroy'"

end
