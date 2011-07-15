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


Then /^"([^"]*)" should see "([^"]*)" with translation "([^"]*)"$/ do |name, english, translation|
  page.body.should have_content(translation)
end