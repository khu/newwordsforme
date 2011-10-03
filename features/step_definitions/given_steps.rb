Given /^"([^"]*)" is user of keepin$/ do |name|
  user = User.new(:username => name, :email => "#{name}@gmail.com", :password => "123456",:password_confirmation => "123456", :crypted_password=>"a7944c46edb15a444ee1facd57fb23cf7d675bf3634e0bd5728d9866bbd8f5154829981e0af0c5b50e2f5534484d8a398363fcd185c3737844e424dd81196907")
  user.save_without_session_maintenance
end

Given /^I logged in as "([^"]*)"$/ do |user_name|
  @user = User.find_by_username(user_name)
  #hack MUST set password manually
  visit login_path
  fill_in "user_session_email", :with => @user.email
  fill_in "user_session_password", :with => "123456"
  click_button "Sign in"
end


Given /^"([^"]*)" logged in$/ do |user_name|
  @user = User.find_by_username(user_name)
  #hack MUST set password manually
  visit login_path
  fill_in "user_session_email", :with => @user.email
  fill_in "user_session_password", :with => "123456"
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