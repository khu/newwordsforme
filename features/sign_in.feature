Feature: Sign in
  In order to view index page
  Arden
  want to sign in

@arden
Scenario: go to index page before sign in
	Give "Arden" not signed in
	When I go to the home page
	Then I should be on the home page

	
@arden @listing
Scenario: go to index page before sign in
	Given "Arden" is user of keepin
	When I go to Arden's page
	Then I should be on the home page

                                         	
@arden @listing
Scenario: go to index page after sign in
    Given I logged in as "Arden"
	When I go to the index page
	Then I should be on the index page


@arden @listing
Scenario: go to index page after sign in
    Given I logged in as "Arden"
	When I go to Rick's page
	Then I should be on the index page