require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should create user" do
    post :create, {:word => 'apple', :translation => 'this is apple'}, {'user_id' => @user.id}
    word = Word.find_by_word('apple')
    assert_not_nil(word)
  end

end
