Given /^"([^"]*)" is user of keepin$/ do |name|
  @user = User.create(:username => name, :password => '123456', :email => "#{name}@gmail.com")
  @user.save
end

Given /^I logged in as "([^"]*)"$/ do |user_name|
  @user = User.find_by_username(user_name)
  #hack MUST set password manually
  @user.password="123456"
  visit login_path
  fill_in "user_session_email", :with => @user.email
  fill_in "user_session_password", :with => @user.password
  click_button "Sign in"
end


Given /^"([^"]*)" logged in$/ do |user_name|
  @user = User.find_by_username(user_name)
  #hack MUST set password manually
  @user.password="123456"
  visit login_path
  fill_in "user_session_email", :with => @user.email
  fill_in "user_session_password", :with => @user.password
  click_button "Sign in"
end
Given /^there exists a word "([^"]*)" for "([^"]*)"$/ do |word, user|
  rick = User.find_by_username(user)
  hello = rick.word.create!(:word => word, :translation => "hello")
end
Given /^"([^"]*)" has two words of the same tag which is "([^"]*)", the words are:$/ do |user, tag, word_table|
  rick = User.find_by_username(user)
  word_table.hashes.each {  |hash|
    word = rick.word.create!(:word => hash[:word], :translation => hash[:word])
    if Tag.find_by_name(tag)
      word.tags.push(Tag.find_by_name("#{tag}"))
    else
      word.tags.create!(:name => tag)
    end
  }
end

Given /^"([^"]*)" add two words, the words are:$/ do |user, word_table|
  rick = User.find_by_username(user)
  word_table.hashes.each do | hash |
    word = rick.word.create(:word => hash[:word], :translation => hash[:word])
    word.add_tag_by_name('unfamiliar')
  end
end