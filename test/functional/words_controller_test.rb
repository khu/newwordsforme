require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should create word with only the word" do
    post :create, {:word => 'apple'}, {'user_id' => @user.id}
    word = Word.find_by_word('apple')
    assert_not_nil(word)
    assert_response :redirect
  end
  
  test "should save multiple words into the vocabulary" do
    post :create, {:word => 'apple'}, {'user_id' => @user.id}
    word = Word.find_by_word('apple')
    assert_not_nil(word)
    assert_response :redirect
  end
end
