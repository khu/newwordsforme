Feature: Sign In Via API
  In order to use Keepin browser plugins to sign in
  Rick
  want to use a API to sign in

@Rick
  Scenario: Sign in
    Given "Rick" registed in Keepin with email "rick@example.com" and password "rick123"
    When  "Rick" post a sign in information with email "rick@example.com" and password "rick123"
    Then  Rick can get a response with HTTP status code "200" (success)
