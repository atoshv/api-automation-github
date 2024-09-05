Feature: GitHub API User Endpoints

  Background:
    * url baseUrl = 'https://api.github.com'
    * def accessToken = 'paste your access token'

  # Failure Cases

  Scenario: No Token Provided
    Given path '/user'
    When method GET
    Then status 401
    And match response.message == 'Requires authentication'

  Scenario: Invalid Token Provided
    Given header Authorization = 'Bearer invalid_token'
    And path '/user'
    When method GET
    Then status 401
    And match response.message == 'Bad credentials'

  Scenario: Forbidden Access (Token Without Necessary Permissions)
    Given header Authorization = 'Bearer some_token_without_permissions'
    And path '/user'
    When method GET
    Then status 403
    And match response.message == 'Forbidden'

  # Success Cases

  Scenario: Get User With Valid Token
    Given header Authorization = 'Bearer ' + accessToken
    And path '/user'
    When method GET
    Then status 200
    And match response.name == 'Atosh'
    And match response.login == 'atoshv'

  Scenario: Update User Bio With Valid Token
    Given header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And path '/user'
    And request { "bio": "Hey, Atosh here" }
    When method PATCH
    Then status 200
    And match response.bio == 'Hey, Atosh here'
    # revert to old
    Given url 'https://api.github.com'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-Type = 'application/json'
    And path '/user'
    And request { "bio": "Working as an Automation Test Lead and I love doing automation of everything" }
    When method PATCH

