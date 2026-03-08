@completion @timeout @error @crash
Feature: Completion, timeout, error, and crash handling
  Validate the non-happy-path result delivery logic.

  Scenario: Successful run produces completion message and saved output
    Given I launch a task that succeeds
    When Codex exits with code 0
    Then the final notification should be marked as success
    And the output file should contain the last Codex message
    And the registry status should be "completed"

  Scenario: Timeout path sends timeout notification and preserves partial output
    Given I launch a task that will exceed the configured timeout
    When the timeout threshold is reached
    Then the runner should terminate the process with SIGTERM then SIGKILL if needed
    And a timeout notification should be delivered to the source channel
    And partial output should still be saved to the output file
    And the registry status should be "timeout"

  Scenario: Non-zero exit path sends error notification
    Given I launch a task that causes Codex to exit non-zero
    When the run ends
    Then an error notification should be delivered to the source channel
    And the registry status should be "failed"
    And the output or stderr summary should be preserved

  Scenario: Runner crash path still notifies the source channel
    Given I intentionally create a runner-side failure after launch conditions are met
    When "run-task.py" crashes
    Then a crash notification should be attempted
    And the source channel should receive a "crash" style message

  Scenario Outline: Completion notifications preserve channel-specific behavior
    Given I launch a run for "<channel>"
    When the run ends in "<result>"
    Then the source channel should receive the corresponding notification
    And OpenClaw wake behavior should match the channel design

    Examples:
      | channel  | result  |
      | whatsapp | success |
      | whatsapp | error   |
      | whatsapp | timeout |
      | telegram | success |
      | telegram | error   |
      | telegram | timeout |
