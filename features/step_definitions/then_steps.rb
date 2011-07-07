Then /^I should see "([^"]*)" tag$/ do |tag|
    page.body.should contain(tag)
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


Then /^"([^"]*)" should see "([^"]*)" with translation "([^"]*)"$/ do |name, english, translation|
  page.body.should contain(translation)
end