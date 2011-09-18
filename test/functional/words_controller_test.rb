# coding: utf-8
require 'test_helper'
require 'iconv'

class WordsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should create word with only the word" do
    post :create, {:word => {:word => "apple"}, :user_id => @user.to_param }
    word = Word.find_by_word('apple')
    assert_not_nil(word)
    assert_equal "苹果", word.translation
    assert_response :redirect
  end
end
