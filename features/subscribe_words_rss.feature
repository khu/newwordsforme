Feature: Subscribe words
  In order to learn English words
  Lee
  want to be able to subscribe words by RSS

  Background:
	Given "Rick" is user of keepin
	And there exists a word "hello" for "Rick"
	And there exists a word "go" for "Rick"
	And the translation of word "hello" is "你好"
	And the translation of word "go" is "进入"
	And the word "hello" updated at "2011-07-07 18:00"
	And the word "go" updated at "2011-07-08 18:00"

@Lee
  Scenario: Subscribe words by RSS
	Given "Lee" is a user
    When "Lee" want to subscribe words of "Rick" 
    Then "Lee" can get a response of RSS format