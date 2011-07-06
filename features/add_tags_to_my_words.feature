Feature: Add Tags
  As a register User of Keepin
  I want to categorize my words by adding tags
  So that I can find my words specifically

  Background:
	Given "Rick" is user of keepin
	And there exists a word "hello" for "Rick"

@javascript
Scenario: I should see the edit link on the specific word
   Given I logged in as "Rick"
   Then I should be on Rick's page
   Then show me the page
   Then I follow "edit"

