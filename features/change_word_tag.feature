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


# Don't fit for new UI
# @Rich @javascript
#   Scenario: slip a Word
# 	Given I logged in as "Rick"
#     When I go to the index page
#     And I click the "unfamiliar" tag
#     And I view the word without flipping
#     And I go to the index page
#     And I click the "familiar" tag
#     Then I should see the words belongs to the tag:
#       |word|
#       |apple|
#       |orange|
#
# @javascript
#   Scenario: flip a Word
#     Given I logged in as "Rick"
#     And "Rick" add two words, the words are:
#       |word|
#       |red|
#       |green|
#     When I go to the index page
#     And I click the "unfamiliar" tag
#     And I flip the word "green"
#     And I go to the index page
#     And I click the "unfamiliar" tag
#     Then I should see the words belongs to the tag:
#       |word|
#       |green|
