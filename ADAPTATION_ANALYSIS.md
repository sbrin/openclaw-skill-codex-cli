# Adaptation Analysis

Comparison basis: current working tree vs original repo state from `HEAD` (`git diff HEAD`).

This file lists the important differences that still remain after adapting the project from Claude Code to OpenAI Codex, and why each difference exists.

## Important remaining differences

### 1. CLI backend changed from `claude -p` to `codex exec`

Files:
- `run-task.py`
- `run-task.sh`
- `README.md`
- `SKILL.md`
- `examples/README.md`

What changed:
- Claude launch commands were replaced with Codex launch commands.
- The runner now builds `codex exec ...` / `codex resume ...` commands instead of `claude -p ...`.

Why:
- This is the core purpose of the adaptation. The skill still works as an OpenClaw async runner, but the actual executor is now Codex CLI.

### 2. Codex uses different unattended flags and output flags

Files:
- `run-task.py`
- `run-task.sh`
- `README.md`
- `SKILL.md`

What changed:
- `--dangerously-skip-permissions` was replaced with `--dangerously-bypass-approvals-and-sandbox`.
- Codex runs with `--experimental-json`.
- Final output is captured with `--output-last-message`.

Why:
- Codex does not expose the same flag set as Claude Code.
- `--dangerously-bypass-approvals-and-sandbox` is the Codex equivalent needed for detached unattended runs.
- `--experimental-json` is needed for machine-readable live event parsing.
- `--output-last-message` is the cleanest Codex-native way to persist the final answer.

### 3. Live activity parsing had to be rewritten for Codex event format

Files:
- `run-task.py`

What changed:
- The old Claude stream-json parser was replaced with a parser for Codex `--experimental-json` events.
- State tracking now follows Codex events like `session.created`, `token_count`, and `item.*`.
- Heartbeat state changed from Claude-style chunk/subagent tracking to Codex item/event tracking.

Why:
- Claude and Codex emit different structured event streams.
- Without rewriting this parser, heartbeat messages, session capture, activity labels, and tool counts would be wrong or empty.

### 4. Resume behavior is different because Codex resume semantics are different

Files:
- `run-task.py`
- `README.md`
- `SKILL.md`
- `examples/README.md`

What changed:
- Resume now uses Codex session IDs.
- The actual command form is different from Claude's workflow.
- Resume failure detection now looks for Codex-style stderr patterns.

Why:
- Codex stores and resumes sessions differently from Claude Code.
- The skill needed a Codex-specific resume path to preserve the original "continue previous async run" feature.

### 5. Search is explicit in Codex, so the runner now controls it

Files:
- `run-task.py`
- `run-task.sh`
- `README.md`
- `SKILL.md`
- `examples/README.md`

What changed:
- The runner enables `--search` by default.
- A Codex-only `--no-search` option was added.
- A Codex-only `--model` option was added.
- A Codex-only `--full-auto` option was added as an alternative mode.

Why:
- In the original project, Claude's general-agent behavior included web-capable research without this exact CLI toggle shape.
- For Codex, search is an explicit execution choice, so the runner has to decide.
- Search is on by default to stay closer to the original "delegate full research/coding work" idea.
- `--model` and `--full-auto` exist because Codex exposes those controls and they are operationally useful.

### 6. Session registry moved from Claude naming to Codex naming

Files:
- `session_registry.py`
- `run-task.py`
- `README.md`
- `SKILL.md`

What changed:
- `~/.openclaw/claude_sessions.json` became `~/.openclaw/codex_sessions.json`.
- Output file examples and docs were renamed accordingly.

Why:
- The registry now stores Codex session IDs, not Claude session IDs.
- Keeping the old filename would be misleading and would mix two incompatible session namespaces.

### 7. Temporary files, logs, and helper script names were renamed

Files:
- `run-task.py`
- `run-task.sh`
- `README.md`
- `SKILL.md`
- `examples/README.md`

What changed:
- `/tmp/cc-*` naming became `/tmp/codex-*`.
- The injected progress helper became `/tmp/codex-notify-{pid}.py`.
- Per-project orchestrator state file became `/tmp/codex-orchestrator-state-<hash>.json`.

Why:
- These files now belong to Codex runs, not Claude runs.
- Renaming avoids confusion during debugging and keeps new artifacts separate from old Claude-task state.

### 8. Telegram mid-task helper wording and prefixes changed

Files:
- `run-task.py`
- `SKILL.md`
- `README.md`

What changed:
- The injected helper still exists, but it now references Codex and uses a Codex prefix.
- Example: `"📡 🟢 CC: "` became `"📡 🟢 Codex: "`.

Why:
- The helper is still needed for the same OpenClaw/Telegram routing reason as the original project.
- Only the executor identity changed.

### 9. `agents/openai.yaml` was added

Files:
- `agents/openai.yaml`
- `README.md`

What changed:
- New UI metadata file for the OpenAI/Codex interface layer.

Why:
- This is not part of the original runtime logic.
- It was added to give the skill a proper display name, description, and default prompt in OpenAI/Codex-oriented skill UIs.
- Runtime does not depend on it. It is a tooling/UI addition, not a core execution requirement.

### 10. OpenClaw metadata block was added to `SKILL.md`

Files:
- `SKILL.md`

What changed:
- A `metadata.openclaw` block was added with declared binaries, Python module, config requirements, and state dir.

Why:
- This makes dependencies explicit in a machine-readable way.
- It is not required for the runner logic itself.
- It was added for clarity/tooling, not because Codex requires it.

### 11. `references/testing-protocol.md` was added

Files:
- `references/testing-protocol.md`
- `SKILL.md`

What changed:
- New reference file for canonical end-to-end validation flow.

Why:
- `SKILL.md` now points to an explicit test protocol reference.
- This was added to preserve an important operational/testing concept from the original skill in a concrete file, instead of leaving it implied or dangling.

### 12. Some README/SKILL wording had to change where Codex and Claude are materially different

Files:
- `README.md`
- `SKILL.md`
- `examples/README.md`

What changed:
- Any section that described Claude-only behavior, flags, session IDs, or economics was adapted to Codex reality.
- Billing language was changed because the original Max-subscription explanation does not apply to Codex.
- Capability descriptions were updated to reflect actual Codex CLI behavior.

Why:
- Keeping Claude-specific claims in place would make the adapted skill inaccurate.
- These edits were necessary where the underlying executor behavior is genuinely different.

## Checked and currently aligned with the original idea

These were changed earlier during adaptation, then restored to stay close to the original project behavior:

- Dangerous unattended execution is the default again.
- Git repo auto-init was restored in both runners if the project has no `.git`.
- The detached `nohup` launch model remains the same.
- The OpenClaw wake/delivery model remains the same.
- Telegram thread-safe routing logic remains the same overall design.
- The session-resume feature remains present.

## Checked and unchanged

Files checked with no current diff against the original:

- `scripts/openclaw_notify.py`
- `LICENSE`

## Bottom line

Most remaining differences are in one of these buckets:

1. Required because Codex CLI works differently from Claude Code.
2. Naming changes needed to avoid mixing Codex state with Claude state.
3. Optional metadata/reference additions for skill tooling and operator usability.

If you want a stricter "minimum-diff" version, the best candidates to reconsider are:

- `agents/openai.yaml`
- the `metadata.openclaw` block in `SKILL.md`
- any non-essential wording in docs that goes beyond direct Claude→Codex substitution
