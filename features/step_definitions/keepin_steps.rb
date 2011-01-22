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
  follow_redirect!
end

Then /^"([^"]*)" should see "([^"]*)" with translation "([^"]*)"$/ do |name, english, translation|
  response.should contain(translation)
end