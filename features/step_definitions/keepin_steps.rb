# coding: utf-8
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^"([^"]*)" logged in$/ do |user|
  visit signin_path
  fill_in "session_email", :with => user
  fill_in "session_password", :with => "password"
  click_button "session_submit"
end

When /^"([^"]*)" save "([^"]*)" into vocabulary from home page$/ do |user, wordx|
  visit user_path(Factory.create(user))
  fill_in "word_word", :with => wordx
  click_button "word_submit"
end

Then /^"([^"]*)" should see "([^"]*)" with translation "([^"]*)"$/ do |name, english, translation|
  page.body.should contain(translation)
end

When /^"([^"]*)" visit new words for "([^"]*)"$/ do |user, period|
  visit user_words_path(User.find_by_name(user), {:today=>DateTime.parse("2011-01-21"), :mode=>period})
end

Then /^"([^"]*)" can see:$/ do |arg1, words_table|
  words_table.hashes.each {|hash| 
    page.body.should contain(hash[:word])
  }
end

Then /^"([^"]*)" can see all "([^"]*)" words:$/ do |user, status, words|
  words.hashes.each {|hash| 
    page.body.should contain(hash[:word])
  }
end

Then /^"([^"]*)" should see sample "([^"]*)"$/ do |user, sample|
    page.body.should contain(sample)
end

Then /^"([^"]*)" should see link "([^"]*)"$/ do |user, link|
    page.body.should contain(link)
end





