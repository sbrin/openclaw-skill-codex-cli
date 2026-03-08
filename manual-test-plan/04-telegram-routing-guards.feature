@telegram @routing @guards
Feature: Telegram routing guards
  Validate that unsafe or inconsistent Telegram routing is blocked before Codex starts.

  Scenario: Block a thread launch if target resolution fails
    Given I use a Telegram thread session key that cannot be resolved to a target
    When I run "run-task.py" with "--validate-only"
    Then the script should exit with "Invalid routing"
    And no Codex process should be started

  Scenario: Block a thread launch if notify session UUID mismatches
    Given I have a valid Telegram thread session key
    And I intentionally pass a wrong "--notify-session-id"
    When I run "run-task.py" with "--validate-only"
    Then the script should exit with "Invalid routing"
    And the error should mention the mismatch

  Scenario: Block non-thread Telegram user-scope launch by default
    Given I use a Telegram user-scope session key like "agent:main:telegram:user:<id>"
    When I run "run-task.py" without "--allow-main-telegram"
    Then the script should block the run before Codex starts
    And the error should explain that unsafe routing was blocked

  Scenario: Allow intentional non-thread Telegram launch when explicitly forced
    Given I use a Telegram user-scope session key like "agent:main:telegram:user:<id>"
    When I run "run-task.py" with "--allow-main-telegram"
    Then the script should allow launch validation to continue

  Scenario: Enforce thread-only mode
    Given I use a Telegram launch without ":thread:<id>" or ":topic:<id>"
    When I run "run-task.py" with "--telegram-routing-mode thread-only"
    Then the launch should be rejected before Codex starts
