Feature: Live
  In order to live
  people
  want to be able to eat strawberries

@Figo
  Scenario: Save single english word
    Given "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "苹果"

@Figo
  Scenario: Save incorrect english word
    Given "Figo" logged in
    When  "Figo" save "Apple" into vocabulary from home page
    Then  "Figo" should see "apple" with translation "苹果"

@Figo
  Scenario: See the first video tutorial on the right hand
    Given "Figo" did not add any word
    When  "Figo" logged in
    Then  "Figo" should see the first time video tutorial on the right side


  

	
