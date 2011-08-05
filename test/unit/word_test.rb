require 'test_helper'

class WordTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should create the simple word" do
    word = Word.create({:word => "Apple"})
    assert_equal "Apple", word.word
    assert_equal nil, word.sample
    assert_equal nil, word.link
  end
  
  test "can split the link" do
    word = Word.create({:word => "Apple@I love Apple"})
    assert_equal "Apple", word.word
    assert_equal "I love Apple", word.sample
  end
  
  test "can split the sample" do
    word = Word.create({:word => "Apple@http://google.com"})
    assert_equal "Apple", word.word
    assert_equal "http://google.com", word.link
  end
  
  test "should return emptry array when there is no tag names" do
    word = Word.create({:word => "Apple@http://google.com"})
    assert_equal [], word.tag_names
  end

  test "should return array to contain all tag names" do
    word = Word.create({:word => "Apple@http://google.com"})
    word.tags = [Tag.create(:name=>"familiar"), Tag.create(:name=>"unfamiliar")]

    assert_equal ["familiar", "unfamiliar"], word.tag_names
  end

  
end
