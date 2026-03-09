# Manual Test Plan

This folder contains manual Gherkin scenarios for validating that the OpenClaw skill was adapted from Claude Code to OpenAI Codex correctly.

Use these files when you:

- install the skill into a real OpenClaw setup
- run OpenClaw manually
- verify runtime behavior channel by channel
- confirm that the Codex adaptation preserved the original logic

## Recommended execution order

1. `01-prerequisites-and-install.feature`
2. `02-whatsapp-smoke.feature`
3. `03-telegram-thread-smoke.feature`
4. `04-telegram-routing-guards.feature`
5. `05-heartbeats-and-progress.feature`
6. `06-completion-timeout-error-crash.feature`
7. `07-resume-and-registry.feature`
8. `08-codex-flags-and-git-init.feature`
9. `09-iterate-and-wake-continuity.feature`
10. `10-run-task-sh-wrapper.feature`

## Test data you should prepare

- one working OpenClaw instance
- one installed copy of this skill
- one WhatsApp group session key
- one Telegram thread session key
- one Telegram thread session UUID for `--notify-session-id`
- a valid local Codex CLI login

## Suggested placeholders

Replace these placeholders during testing:

- `<BASE_DIR>`: absolute path to this repo or installed skill directory
- `<WA_GROUP_SESSION>`: `agent:...:whatsapp:group:...`
- `<TG_THREAD_SESSION>`: `agent:...:main:<thread|topic>:<id>`
- `<TG_THREAD_UUID>`: OpenClaw session UUID for that Telegram thread
- `<PROJECT_DIR>`: temporary or real project directory
- `<MODEL>`: optional Codex model name

## Evidence to collect

For each scenario, record:

- command used
- whether launch proof passed
- which channel/thread received launch
- whether heartbeat arrived after ~60s
- whether mid-task progress arrived
- whether final result arrived
- whether agent continuation happened in the same session
- relevant log/output files

## Important validation rules

- Always launch long runs via `nohup`.
- For Telegram thread runs, do `--validate-only` first.
- For iterate-mode checks, there must be a visible decision turn before the next launch.
- When testing resume, use the real Codex `thread_id`, not `run_id` or `wake_id`.
