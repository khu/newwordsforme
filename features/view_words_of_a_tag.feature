Feature: View Words of A Tag
  As a register User of Keepin
  I want to view all the words belongs to the same tag
  So that I can find the words by tag

  Background:
    Given "Rick" is user of keepin
    And "Rick" has two words of the same tag which is "starred", the words are:
      |word|
      |apple|
      |orange|

  @javascript
  Scenario: View words by tag
    Given I logged in as "Rick"
    And I go to the index page
    When I click the "starred" tab
    Then I should see the words under the tab:
      | word   |
      | apple  |
      | orange |


#Do not fit for new UI
#@javascript
#Scenario: View all tags
#   Given I logged in as "Rick"
#   When I go to the index page
#   Then I should see all his tags:
#     |tag|
#     |fruit|
#
#@javascript
#Scenario: View words by tag
#   Given I logged in as "Rick"
#   And I go to the index page
#   When I click the "fruit" tag
#   Then I should see the words belongs to the tag:
#     |word|
#     |apple|
#     |orange|
#
#@javascript
#Scenario: Get tip message when no tag
#   Given I logged in as "Rick"
#   And  "Rick" has not any tag
#   When I go to the index page
#   Then I should see "There is no tag" tip message


