@flags @git
Feature: Codex-specific flags and git initialization behavior
  Validate the Codex-only differences introduced by the adaptation.

  Scenario: Dangerous unattended mode is the default
    When I launch a normal run without "--full-auto"
    Then the built Codex command should include "--dangerously-bypass-approvals-and-sandbox"
    And the run should not require interactive approvals

  Scenario: Full-auto mode can be requested explicitly
    When I launch a run with "--full-auto"
    Then the built Codex command should include "--full-auto"
    And the run should not use the default dangerous flag at the same time

  Scenario: Search is enabled by default
    When I launch a normal run
    Then the built Codex command should include "--search"

  Scenario: Search can be disabled explicitly
    When I launch a run with "--no-search"
    Then the built Codex command should not include "--search"

  Scenario: Model override is passed through
    When I launch a run with "--model <MODEL>"
    Then the built Codex command should include that model name

  Scenario: Missing git repository is auto-initialized
    Given the project directory exists but has no ".git" directory
    When I launch a run
    Then the runner should initialize a git repository before starting Codex
    And Codex should be able to run in that directory

  Scenario: Existing git repository is preserved
    Given the project directory already contains ".git"
    When I launch a run
    Then the runner should not break the existing repository
