Feature: Add Words Via API
  In order to use Keepin browser plugins to add word
  Rick
  want to have a URL to post the word

@Rick
  Scenario: Add a new word
    Given "Rick" registed in Keepin with email "rick@example.com" and password "rick123"
    When  "Rick" post a word "cucumber" to the API with password "rick123"
    Then  Rick can get a response with HTTP status code 201 (Created)