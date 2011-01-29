Feature: Live
  In order to live
  people
  want to be able to eat strawberries

@Figo @done
  Scenario: Save single english word
    Given "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "\u82f9\u679c"

@Figo
  Scenario: Save incorrect english word
    Given "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "苹果"

@Figo @wip
Scenario: Save the example sentence
	 Given "Figo" logged in
	 When  "Figo" save "apple@I love apple" into vocabulary from home page
	 Then  "Figo" should see "apple" with translation ""
	 Then  "Figo" should see sample "I love apple"

@Figo @wip
  Scenario: Save where the word from
 	 Given "Figo" logged in
	 When  "Figo" save "apple@http://google.com" into vocabulary from home page
	 Then  "Figo" should see "apple" with translation ""
	 Then  "Figo" should see link "http://google.com"


@Figo
  Scenario: See the first video tutorial on the right hand
    Given "Figo" did not add any word
    When  "Figo" logged in
    Then  "Figo" should see the first time video tutorial on the right side

  


  

	
