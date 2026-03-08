@progress @heartbeat
Feature: Heartbeats and mid-task progress updates
  Validate liveness reporting from the wrapper and from Codex-triggered helper updates.

  Background:
    Given I have a valid session key for the channel under test
    And I have a prompt that runs for at least 70 seconds
    And that prompt instructs Codex to send at least one progress update

  Scenario Outline: Wrapper heartbeat arrives after roughly one minute
    When I launch a long-running task for "<channel>"
    Then a launch notification should appear in the source chat
    And after about 60 seconds a wrapper heartbeat should appear
    And the heartbeat should include live activity information when available

    Examples:
      | channel  |
      | whatsapp |
      | telegram |

  Scenario: Telegram progress helper posts into the same thread
    Given I launch a Telegram thread run
    When Codex invokes the injected helper script
    Then a "📡 🟢 Codex" progress update should appear in the same Telegram thread
    And the update should not require an agent wake
    And the update should not land in the main chat

  Scenario: Silent mode is used for Telegram notifications
    Given I launch a Telegram thread run
    When launch, heartbeat, progress, and final result messages are delivered
    Then they should be sent with Telegram silent notifications enabled

  Scenario: WhatsApp still receives progress without silent semantics
    Given I launch a WhatsApp run
    When heartbeats and results are delivered
    Then they should appear in WhatsApp normally
