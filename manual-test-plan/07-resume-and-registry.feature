@resume @registry
Feature: Session resumption and registry tracking
  Validate Codex thread_id capture, storage, and later resumption.

  Background:
    Given I have a project directory "<PROJECT_DIR>"
    And I have a session key for delivery

  Scenario: A successful run registers a Codex thread_id
    When I launch and complete an initial run with "--session-label"
    Then the run log should show a registered thread_id
    And the registry should contain that thread_id
    And the registry entry should include project_dir, output_file, status, and session label

  Scenario: Resume a previous Codex session successfully
    Given I have a real Codex thread_id from a previous completed run
    When I launch a follow-up run with "--resume <thread-id>"
    Then Codex should continue the previous conversation
    And a new result should be delivered normally
    And the registry entry should be updated or reused correctly

  Scenario: Resume failure is surfaced clearly
    Given I use an invalid or expired Codex thread_id
    When I launch a run with "--resume <bad-thread-id>"
    Then the source channel should receive a resume failure message
    And the message should suggest starting fresh without "--resume"

  Scenario: Registry helper queries work on stored sessions
    Given I have completed several runs with labels
    When I query the registry manually or through helper functions
    Then recent sessions should be listed in reverse chronological order
    And label-based lookup should find a matching session
