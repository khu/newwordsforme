Feature: Live
  In order to live
  people
  want to be able to eat strawberries

@Figo @javascript
  Scenario: list words for this week in time sequence
	Given "Figo" is user of keepin
	And "Figo" logged in
	When "Figo" save "apple" into vocabulary from home page
	And "Figo" save "pear" into vocabulary from home page
	And "Figo" save "apple" into vocabulary from home page
	Then "Figo" should see only one "apple"
	And "Figo"'s words for "all" should sorted by updated time
	And "Figo" visit new words for "all"
	And "Figo"'s words for "all" should sorted by updated time

@Figo @done @javascript
  Scenario: Save single english word
	Given "Figo" is user of keepin
	And "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "苹果"

@Figo @javascript
  Scenario: Save incorrect english word
	Given "Figo" is user of keepin
	And "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "苹果"

@Figo @wip @javascript
Scenario: Save the example sentence
	Given "Figo" is user of keepin
	And "Figo" logged in
	 When  "Figo" save "apple@I love apple" into vocabulary from home page
	 Then  "Figo" should see "apple" with translation "\u82f9\u679c"
	 Then  "Figo" should see sample "I love apple"

@Figo @wip @javascript
  Scenario: Save where the word from
 	 Given "Figo" logged in
	 When  "Figo" save "apple@http://icgoogle.com" into vocabulary from home page
	 Then  "Figo" should see "apple" with translation "\u82f9\u679c"
	 Then  "Figo" should see link "http://icgoogle.com"


@Figo @javascript
  Scenario: See the first video tutorial on the right hand
    Given "Figo" did not add any word
    When  "Figo" logged in
    Then  "Figo" should see the first time video tutorial on the right side



  

	
