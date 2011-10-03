Feature: Add Words Via API
  In order to use Keepin browser plugins to add word
  Rick
  want to have a URL to post the word

@Rick
  Scenario: Add a new word
    Given "Rick" registed in Keepin with email "rick@example.com" and password "rick123"
    When  "rick@example.com" post a word "cucumber" to the API with password "123456"
    Then  Rick can get a response with HTTP status code 201 (Created)
    And   the JSON response should be an array having a "word" element with content "cucumber"
