@telegram @thread @smoke
Feature: Telegram thread-safe happy path
  Validate that Telegram threaded delivery remains strict and thread-correct.

  Background:
    Given I have a valid Telegram thread session key "<TG_THREAD_SESSION>"
    And I know the matching OpenClaw session UUID "<TG_THREAD_UUID>"
    And I have a writable project directory "<PROJECT_DIR>"

  Scenario: Validate routing before launch
    When I run "run-task.py" with "--validate-only" for the Telegram thread session
    Then routing validation should succeed
    And the script should resolve a Telegram target
    And the script should resolve or accept the exact notify session UUID
    And no Codex subprocess should be started

  Scenario: Launch a Telegram thread task after validation
    Given routing validation already succeeded
    When I launch a real Telegram thread run via "nohup"
    Then the command should return a PID
    And the run log should contain "Starting OpenAI Codex"
    And the launch notification should appear in the same Telegram thread
    And the launch should not appear in the Telegram main chat by mistake

  Scenario: Successful Telegram completion stays in-thread
    Given a Telegram thread Codex task is running
    When the task completes successfully
    Then the final result should appear in the same Telegram thread
    And the agent should be woken in the same OpenClaw session
    And the continuation reply should be visible in the same Telegram thread
    And the completion should not drift into another thread or main chat
