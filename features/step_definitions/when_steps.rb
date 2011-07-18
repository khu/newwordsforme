When /^"([^"]*)" save "([^"]*)" into vocabulary from home page$/ do |user, wordx|
  visit user_path(Factory.create(user))
  fill_in "word_word", :with => wordx
  click_button "word_submit"
end

When /^"([^"]*)" visit new words for "([^"]*)"$/ do |user, period|
  visit user_words_path(User.find_by_name(user), {:today=>DateTime.parse("2011-01-21"), :mode=>period})
end

When /^I click the "([^"]*)" tag$/ do |tag|
   click_link tag
end
When /^I flipper the word "([^"]*)" (\d+) times$/ do |word, times|
  #class="sponsor" title="Click to flip"
  div1 = page.find("div[@id=#{word}]").find("div[@class=sponsor]")
  div1.click
  div1.click
end