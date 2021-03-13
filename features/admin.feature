Feature: basic admin functionality

  As an admin
  So that I can see how many people are teaching BJC
  I can login in an see the dashboard

Scenario: Logging in as an admin
  Given I am on the BJC home page
  Given I have an admin email
  And I follow "Log In"
  Then I can log in with Google
  And I should see "BJC Teacher Dashboard"

Scenario: Viewing all teachers as an admin
  Given I am on the BJC home page
  Given I have an admin email
  And I follow "Log In"
  Then I can log in with Google
  When I go to the teachers page
  Then I should see "All BJC Teachers"

# TODO: Add steps to check basic dashboard functions
# A search field should be visible on the index pages
# Check for a CSV button

Scenario: Logging in with random Google Account should fail
  Given I have a random email
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  And I should see "Please Submit a teacher request"

Scenario: Logging in as an env-removed admin should not give admin access
  Given the following teachers exist:
  | first_name | last_name | admin | email                        |
  | Joseph     | Mamoa     | true  | testteacheruser@berkeley.edu |
  Given I am on the BJC home page
  And I follow "Log In"
  Then I can log in with Google
  And I should see "Please Submit a teacher request"

Scenario: Edit teacher info as an admin
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  Given I am on the BJC home page
  Given I have an admin email
  And   I follow "Log In"
  Then  I can log in with Google
  When  I go to the teachers page
  When  I go to the edit page for Joseph Mamoa
  Then  I should see "Joseph"
  And   I enter my "First Name" as "Joe"
  And   I press "Update"
  Then I see a confirmation "Successfully updated information"

Scenario: Not logged in should not have access to edit
  Given the following schools exist:
  |       name      |     city     |  state  |            website            |
  |   UC Berkeley   |   Berkeley   |   CA    |   https://www.berkeley.edu    |
  Given the following teachers exist:
  | first_name | last_name | admin | email                    | school      |
  | Joseph     | Mamoa     | false | testteacher@berkeley.edu | UC Berkeley |
  When  I go to the edit page for Joseph Mamoa
  Then  should see "You need to log in to access this."

