# encoding: utf-8

require 'spec_helper'

describe WordsController do
  
  context "add tags for word" do
    before(:each) do
        @user = Factory(:Figo)
        @word = @user.word.create!(:word => 'hello', :translation => '你好')
    end

    it "should return created given a correct tag with existing word" do
      attrs = { :word_id => @word.id, :tag => 'greeting'}
      post :add_tag, :word => attrs

      response.should contain("created")
    end

    it "should return failure given a tag with not existing word" do
      attrs = { :word_id => 999, :tag => 'greeting'}
      post :add_tag, :word => attrs

      response.should contain("failure")
    end

    it "should return failure given a empty tag with existing word" do
      attrs = { :word_id => @word.id, :tag => ''}
      post :add_tag, :word => attrs

      response.should contain("failure")
    end    
    
    it "should return attached given a existing tag with existing word" do
      @word.tags.create!(:name => "greeting")
      attrs = { :word_id => @word.id, :tag => 'greeting'}
      post :add_tag, :word => attrs

      response.should contain("attached")
    end
    
    it "should return all tags of the special word in format of JSON" do
      @word.tags.create!(:name => "greeting")
      @word.tags.create!(:name => "test")
      get :get_word_tags, :id => @word.id, :format => :json
      result = JSON.parse(response.body)

      result[0]['tag']['name'].include?("greeting").should be_true      
      result[1]['tag']['name'].include?("test").should be_true      
    end
  end
end

