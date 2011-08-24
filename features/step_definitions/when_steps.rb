When /^"([^"]*)" save "([^"]*)" into vocabulary from home page$/ do |user, wordx|
  visit user_path(User.find_by_name(user))
  fill_in "word_word", :with => wordx
  click_button "word_submit"
end

When /^"([^"]*)" visit new words for "([^"]*)"$/ do |user, period|
  visit user_words_path(User.find_by_name(user), {:today=>DateTime.parse("2011-01-21"), :mode=>period})
end

When /^I click the "([^"]*)" tag$/ do |tag|
  click_link tag
end

When /^I click the "([^"]*)" tab$/ do |tab|
  within('.words-stream-tabs') do
    page.find("a[@id=#{tab}-tab]").click
  end
end

When /^I flipper the word "([^"]*)" (\d+) times$/ do |word, times|
  #class="sponsor" title="Click to flip"
  div1 = page.find("div[@id=#{word}]").find("div[@class=sponsor]")
  div1.click
  div1.click
end

When /^I view the word without flipping$/ do
  next_link = page.find("a[@class=next]")
  next_link.click

  prev_link = page.find("a[@class=prev]")
  prev_link.click
end

When /^I flip the word "([^"]*)"$/ do |word_name|
  word = Word.find_by_word(word_name)
  div = page.find("div[@id=word#{word.id}]")
  div.click
end

When /^"([^"]*)" post a sign in information with email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  path = "/sessions/userid.json"
  data = {"email" => email, "password" => password}.to_json
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  post path, data
end

When /^I mark "([^"]*)" as "([^"]*)"$/ do |word, tag|
  within ('.new-sponsorListHolder') do
    page.find("div[@id=#{word}]").find("div[@class=#{tag}]").click
  end
end