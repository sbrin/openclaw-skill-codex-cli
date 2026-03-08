@iterate @wake @continuity
Feature: Iterate mode and wake continuity
  Validate that multi-step continuation keeps the original OpenClaw conversation semantics.

  Scenario: Iterate mode still requires a visible decision turn
    Given I launch a run with "--completion-mode iterate"
    When the first Codex run completes
    Then the agent should post a visible analysis/decision message
    And the next detached launch must not happen silently

  Scenario: Telegram iterate continuation stays in the same thread
    Given I launch an iterate-mode task in a Telegram thread
    When the first run completes and the agent decides to continue
    Then the decision message should appear in the same Telegram thread
    And any next launch should also remain in that same Telegram thread

  Scenario: Wake deduplication avoids duplicate continuations
    Given I produce conditions that could trigger duplicate or stale wakes
    When the runner evaluates the wake dispatch
    Then duplicate or stale wake delivery should be skipped
    And the conversation should not receive duplicate continuation turns

  Scenario: Trace mode exposes technical milestones in chat
    Given I launch a debug run with "--trace-live"
    When the run progresses through launch, wake, or skip logic
    Then trace markers should be emitted into the same chat or thread
