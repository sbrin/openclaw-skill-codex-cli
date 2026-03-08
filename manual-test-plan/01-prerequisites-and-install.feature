@setup @smoke
Feature: Prerequisites and installation
  Validate that the environment is ready before any functional scenario is run.

  Scenario: Verify required binaries, Python dependency, and OpenClaw configuration
    Given OpenClaw is installed and running locally
    And the skill is installed under the OpenClaw skills directory
    When I verify that "codex" is available in PATH
    And I verify that "python3" is available in PATH
    And I verify that Python module "requests" can be imported
    And I verify that "~/.openclaw/openclaw.json" exists
    And I verify that "gateway.auth.token" is present in OpenClaw config
    And I verify that "gateway.tools.allow" includes "sessions_send"
    And I verify that "tools.sessions.visibility" is set to "all"
    Then the skill prerequisites should be satisfied

  Scenario: Verify the installed files are present
    Given the skill is installed at "<BASE_DIR>"
    When I inspect the skill directory
    Then file "SKILL.md" should exist
    And file "README.md" should exist
    And file "run-task.py" should exist
    And file "run-task.sh" should exist
    And file "session_registry.py" should exist
    And file "scripts/openclaw_notify.py" should exist

  Scenario: Verify Codex can run in the current shell
    Given Codex CLI is authenticated
    When I run a trivial Codex command manually
    Then it should complete without an authentication error

  Scenario: Verify OpenClaw session keys needed for testing are known
    Given I have access to OpenClaw session listing or logs
    When I identify one WhatsApp group session key
    And I identify one Telegram thread session key
    And I identify the Telegram thread session UUID
    Then I should have enough routing data for the rest of the manual scenarios
