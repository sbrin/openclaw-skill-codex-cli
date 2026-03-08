@whatsapp @smoke
Feature: WhatsApp smoke flow
  Validate the basic OpenClaw -> Codex -> WhatsApp -> OpenClaw round-trip.

  Background:
    Given I have a valid WhatsApp group session key "<WA_GROUP_SESSION>"
    And I have a writable project directory "<PROJECT_DIR>"

  Scenario: Launch a simple Codex task to WhatsApp
    Given the project directory exists
    And the project directory is not actively used by another test
    When I launch "run-task.py" via "nohup" with the WhatsApp session key
    Then the command should return a PID
    And the process should still be alive after launch
    And the run log should contain "Starting OpenAI Codex"
    And a launch notification should appear in the WhatsApp group

  Scenario: Successful completion wakes the agent
    Given a WhatsApp Codex task is running
    When the task completes successfully
    Then the final result should be delivered directly to the WhatsApp group
    And the agent should be woken through the OpenClaw session
    And the agent continuation should appear in the same WhatsApp conversation
    And the output file path should be included in the result message

  Scenario: Basic artifacts are created for a WhatsApp run
    Given a WhatsApp Codex task has completed
    When I inspect local artifacts
    Then a "/tmp/codex-<timestamp>.txt" output file should exist
    And a run log file should exist
    And a registry entry should exist in "~/.openclaw/codex_sessions.json"
