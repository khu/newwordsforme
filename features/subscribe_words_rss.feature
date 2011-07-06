Feature: Subscribe words
  In order to learn English words
  Lee
  want to be able to subscribe words by RSS

@Lee
  Scenario: Subscribe words by RSS
    Given "Rick" registed in Keepin
    When "Lee" want to subscribe "Rick"'s words 
    Then "Lee" can get a response of RSS format words list
  
  Scenario: Get all words for the first time
    Given "Rick" rigisted in Keepin
    When "Lee" want to subscribe "Rick"'s words for the fist time
    Then "Lee" can get all "Rick"'s words in RSS format

  Scenario: Refresh local vocabulary
    Given "Lee" has subscribed "Rick"'s words
    When "Lee" want to subscribe "Rick"'s words again
    Then "Lee" should fresh his local vocabulary