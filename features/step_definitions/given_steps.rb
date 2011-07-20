Given /^"([^"]*)" is user of keepin$/ do |name|
  @user = User.create(:name => name, :password => 'password', :email => "#{name}@gmail.com")
  @user.save
end

Given /^I logged in as "([^"]*)"$/ do |user_name|
  @user = User.find_by_name(user_name)
  #hack MUST set password manually
  @user.password="password"
  visit signin_path
  fill_in "session_email", :with => @user.email
  fill_in "session_password", :with => @user.password
  click_button "session_submit"
end


Given /^"([^"]*)" logged in$/ do |user_name|
  @user = User.find_by_name(user_name)
  #hack MUST set password manually
  @user.password="password"
  visit signin_path
  fill_in "session_email", :with => @user.email
  fill_in "session_password", :with => @user.password
  click_button "session_submit"
end
Given /^there exists a word "([^"]*)" for "([^"]*)"$/ do |word, user|
  rick = User.find_by_name(user)
  hello = rick.word.create!(:word => word, :translation => "hello")
end
