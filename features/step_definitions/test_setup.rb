
 Given /^there is an Register user$/ do
   attr = {
     :name => "Risk",
     :email => "risk@keepin.com",
     :password => "password",
     :password_confirmation => "password"
   }
   User.create!(attr)
 end
 
Given /^there exists an added word$/ do
  Word.create! (:word => "hello", :translation => "你好",:user_id =>1)
end
 
   