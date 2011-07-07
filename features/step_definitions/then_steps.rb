Then /^I should see "([^"]*)" tag$/ do |tag|
    page.body.should contain(tag)
end
