# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

# Commonly used webrat steps
# http://github.com/brynary/webrat

#And the translation of word "hello" is "你好"
And /^the translation of word "([^"]*)" is "([^"]*)"$/ do |word, translation|
  word = Word.first(:conditions => ["word = ?", word])
  word.translation = translation
  word.save
end

#And the word "hello" updated at "2011-07-07 18:00"
And /^the word "([^"]*)" updated at "([^"]*)"$/ do |word, updateddate|
  word = Word.first(:conditions => ["word = ?", word])
  word.updated_at = updateddate
  word.save
end

#When "Lee" want to subscribe "Rick"'s words
When /^"([^"]*)" want to subscribe words of "([^"]*)"$/ do |subsrciber, username|
  keepin_user = User.first(:conditions => ["name = ?", username])
  visit users_path(keepin_user.id, :format => :rss)
end 

#Then "Lee" can get a response of RSS format
Then /^"([^"]*)" can get a response of RSS format$/ do |username|
  response.should be_success
  response.should have_selector("rss[version='2.0']")
  response.should have_selector("channel")
  response.should have_selector("title", :content => "Words")
  response.should have_selector("description", :content => "All the words which #{username} is learning")
end

#Given "Lee" is a user
Given /^"([^"]*)" is a user$/ do |user|

end
