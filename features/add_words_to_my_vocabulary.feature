Feature: Live
  In order to live
  people
  want to be able to eat strawberries

@Figo @wip
  Scenario: Save single english word
    Given "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "\u82f9\u679c"

@Figo
  Scenario: Save incorrect english word
    Given "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "苹果"

@Figo
  Scenario: Save the example sentence
	 Given "Figo" logged in
	 When  "Figo" save "apple@I love apple"
	 Then  "Figo" should see translation and the example sentence

@Figo
  Scenario: Save where the word from
 	 Given "Figo" logged in
	 When  "Figo" save "apple@http://google.com"
	 Then  "Figo" should see translation and link to navigate to the page

@Figo
  Scenario: See the first video tutorial on the right hand
    Given "Figo" did not add any word
    When  "Figo" logged in
    Then  "Figo" should see the first time video tutorial on the right side

  


  

	
