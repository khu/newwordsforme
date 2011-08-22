Then /^"([^"]*)" can see:$/ do |arg1, words_table|
  words_table.hashes.each {|hash|
    page.body.should have_content(hash[:word])
  }
end

Then /^"([^"]*)" can see all "([^"]*)" words:$/ do |user, status, words|
  words.hashes.each { |hash|
    page.body.should have_content(hash[:word])
  }
end

Then /^"([^"]*)"'s words for "([^"]*)" should sorted by updated time$/ do |username, period|
    user = User.find_by_name(username)
    today = DateTime.parse("2011-01-21")
    words = user.method(period).call(today).order("updated_at");
    match_regex = ""
    words.all.each { |word|
      match_regex="#{word.word}.*"+match_regex
    }
    page.body.should =~ Regexp.new(match_regex, Regexp::MULTILINE)
end

Then /^"([^"]*)" should see only one "([^"]*)"$/ do |user, word|
  array=page.body.scan(/id="#{word}"/)
  # puts "-------->"+array.length.to_s
  if (array.length != 1)
    YOU SHALL NOT PASS
  end
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
  tag_table.hashes.each do |hash|
    # there is a problem
    # div.should contain("#{hash[:tag]}")
    div.should have_selector("a", :content => "#{hash[:tag]}")
  end
end

Then /^I should see the words belongs to the tag:$/ do |word_table|

  div = page.find('div[@class=slides_container]')
  word_table.hashes.each {|hash|
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

Then /^Rick can get a response with HTTP status code "([^"]*)" \(success\)$/ do |code_wanted|
  last_response.status.should == code_wanted.to_i
end