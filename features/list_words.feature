Feature: Listing
  In order to find words easily
  Arden
  want to organize the words

@arden
  Scenario: list words for this week
	Give "Arden" logged in
	When "Arden" visit new words for "this week"
	Then "Arden" can see all words added within "this week" sorted by time in descending order
@arden	
  Scenario: list words for this month
	Give "Arden" logged in
	When "Arden" visit new words for "this month"
	Then "Arden" can see all words added within "this month" sorted by time in descending order
@arden
  Scenario: list all words
	Give "Arden" logged in
	When "Arden" visit new words for "all"
	Then "Arden" can see all words added within "all" sorted by time in descending order
@arden
  Scenario: list all words I mastered
	Give "Arden" logged in
	When "Arden" visit new words for "all"
	Then "Arden" can see all words added within "all" sorted by time in descending order
@arden
  Scenario: list all words I do not master
	Give "Arden" logged in
	When "Arden" visit new words for "all"
	Then "Arden" can see all words added within "all" sorted by time in descending order
@arden
  Scenario: list all words I not familiar
	Give "Arden" logged in
	When "Arden" visit new words for "all"
	Then "Arden" can see all words added within "all" sorted by time in descending order

@arden
  Scenario: hide the translation for the words words for this month
	Give "Arden" logged in
	When "Arden" visit new words for "this month"
	Then "Arden" cannot see any translation

@arden
  Scenario: show the translation for the words words for this month
	Give "Arden" logged in
	When "Arden" visit new words for "this month"
	Then "Arden" cannot see any translation