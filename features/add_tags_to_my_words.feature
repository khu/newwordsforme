Feature: Add Tags
  As a register User of Keepin
  I want to categorize my words by adding tags
  So that I can find my words specifically

  Background:
	Given "Rick" is user of keepin
	And there exists a word "hello" for "Rick"

@javascript
Scenario: Single Tag should be added to my specific word
   Given I logged in as "Rick"
   When I follow "edit"
   And I fill in "greeting" for "tag"
   And I press "OK"
   Then I should see "greeting" tag
   
@javascript
Scenario: Auto add tag "unfamiliar" to my specific word
   Given I logged in as "Rick"
   When I flipper the word "hello" 2 times
   Then I should see "unfamiliar" tag