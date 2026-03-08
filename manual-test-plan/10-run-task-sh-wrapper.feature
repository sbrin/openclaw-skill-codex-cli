@wrapper @shell
Feature: Minimal shell wrapper
  Validate that the shell wrapper still works after the Codex conversion.

  Background:
    Given I have a WhatsApp group session key "<WA_GROUP_SESSION>"
    And I have a writable project directory "<PROJECT_DIR>"

  Scenario: run-task.sh launches Codex and sends completion
    When I run "run-task.sh" with project dir, task text, and session key
    Then the wrapper should initialize git if needed
    And the wrapper should call "codex --search exec"
    And it should save the final output into "/tmp/codex-<timestamp>-result.txt"
    And it should send completion back through OpenClaw

  Scenario: run-task.sh logs Codex stderr/stdout separately from final output
    Given I launch a shell-wrapper run
    When the task completes
    Then the final result file should exist
    And a separate "/tmp/codex-<timestamp>-run.log" should exist

  Scenario: run-task.sh returns an error-style message on failure
    Given I launch a shell-wrapper run that fails
    When Codex exits non-zero
    Then the notification message should be marked as an error
