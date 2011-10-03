Feature: Change Word Tag
  In order to classify the words
  Rick
  knows which words are unfamiliar or familiar

  Background:
    Given "Rick" is user of keepin
    And "Rick" add two words, the words are:
      | word   |
      | apple  |
      | orange |

  @javascript
  Scenario: mark a word starred
    Given I logged in as "Rick"
    When I go to the index page
    And I mark "apple" as "starred"
    And I click the "starred" tab
    Then I should see the words under the tab:
      | word  |
      | apple |
