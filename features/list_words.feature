Feature: Listing
  In order to find words easily
  Arden
  want to organize the words

@arden @listing @done
  Scenario: list words for this week
	Given "Arden" logged in
	When "Arden" visit new words for "days7"
	Then "Arden" can see:
	|word|
	|tomato|
	|to|

@arden @listing @done
  Scenario: list words for this week in time sequence
	Given "Arden" logged in
	When "Arden" visit new words for "all"
	Then "Arden"'s words for "all" should sorted by updated time

@arden @listing	@done
  Scenario: list words for this month
	Given "Arden" logged in
	When "Arden" visit new words for "days30"
	Then "Arden" can see:
	|word|
	|tomato|
	|last|
	
@arden @listing	@done
Scenario: list words for this month
	Given "Arden" logged in
	When "Arden" visit new words for "all"
	Then "Arden" can see:
	|word|
	|tomato|
	|last|
	|month|
	|year|
	
@arden @listing	@done
Scenario: list all words I mastered
	Given "Arden" logged in
	When "Arden" visit new words for "mastered"
	Then "Arden" can see all "mastered" words:
	|word|
	|year|
	
@arden @listing @done
Scenario: list all words I do not master
	Given "Arden" logged in
	When "Arden" visit new words for "notmastered"
	Then "Arden" can see all "notmastered" words:
	|word|
	|tomato|
	|to|

@arden @listing @done
  Scenario: list all words I am unfamiliar with
	Given "Arden" logged in
	When "Arden" visit new words for "unfamiliar"
	Then "Arden" can see all "unfamiliar" words:
	|word|
	|last|
	|month|
	

@arden @wip
  Scenario: hide the translation for the words words for this month
	Give "Arden" logged in
	When "Arden" visit new words for "this month"
	Then "Arden" cannot see any translation

@arden @wip
  Scenario: show the translation for the words words for this month
	Give "Arden" logged in
	When "Arden" visit new words for "this month"
	Then "Arden" cannot see any translation