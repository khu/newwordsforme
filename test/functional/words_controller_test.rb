# coding: utf-8
require 'test_helper'
require 'iconv'

class WordsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should create word with only the word" do
    post :create, {:word => 'apple'}, {'user_id' => @user.id}
    word = Word.find_by_word('apple')
    assert_not_nil(word)
    assert_equal "苹果", word.translation
    assert_response :redirect
  end
  
  test "should save multiple words into the vocabulary" do
    post :create, {:word => 'apple\npear'}, {'user_id' => @user.id}
    word = Word.find_by_word('apple')
    assert_equal "苹果", word.translation
    word = Word.find_by_word('pear')
    assert_equal "梨", word.translation
    assert_response :redirect
  end
  
end
