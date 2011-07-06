Given /^"([^"]*)" is user of keepin$/ do |name|
  user = User.create(:name => name, :password => 'password', :email => "#{name}@gmail.com")
  user.save
end

Given /^I logged in as "([^"]*)"$/ do |user_name|
  visit signin_path
  fill_in "session_email", :with => "#{user_name}@gmail.com"
  fill_in "session_password", :with => "password"
  click_button "session_submit"
end

Given /^there exists a word "([^"]*)" for "([^"]*)"$/ do |word, user|
  rick = User.find_by_name(user)
  hello = rick.word.create!(:word => word, :translation => "你好")
end
