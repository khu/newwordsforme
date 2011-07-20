Then /^I should see "([^"]*)" tag$/ do |tag|
    page.body.should have_content(tag)
end

Then /^"([^"]*)" can see:$/ do |arg1, words_table|
  words_table.hashes.each {|hash| 
    page.body.should have_content(hash[:word])
  }
end

Then /^"([^"]*)" can see all "([^"]*)" words:$/ do |user, status, words|
  words.hashes.each {|hash| 
    page.body.should have_content(hash[:word])
  }
end

Then /^"([^"]*)" should see sample "([^"]*)"$/ do |user, sample|
    page.body.should have_content(sample)
end

Then /^"([^"]*)" should see link "([^"]*)"$/ do |user, link|
    page.body.should have_content(link)
end

# Then /^"([^"]*)" should see "([^"]*)" with translation "([^"]*)"$/ do |name, english, translation|
#   page.body.should contain(translation)
# end

Then /^I should see all his tags:$/ do |tag_table|
  # In support/paths/rb to manage to route info, in feature , use go to to find which page
  div = page.find('div[@id=tags-list]')
  tag_table.hashes.each do  |hash|
    # there is a problem
    # div.should contain("#{hash[:tag]}")
    div.should have_selector("a", :content => "#{hash[:tag]}")
  end
end

Then /^I should see the words belongs to the tag:$/ do |word_table|
  div = page.find('div[@id=cards]')
  word_table.hashes.each {  |hash|
    div.should have_content(hash[:word])
  }
end

Then /^I should see "([^"]*)" tip message$/ do |tip|
  div = page.find('div[@id=no-tag-message]')
  div.should have_content(tip)
end

Then /^"([^"]*)" should see "([^"]*)" with translation "([^"]*)"$/ do |name, english, translation|
  page.body.should have_content(translation)
end