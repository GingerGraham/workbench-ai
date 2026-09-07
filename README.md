# workbench-ai

Install/update automation for AI CLIs, for the
[`workbench`](https://github.com/GingerGraham/workbench-core) ecosystem.

An **ecosystem module** (`workbench-core` ARCHITECTURE.md §2) — meaningless
standalone. Requires `workbench-core` installed first:

```sh
wb add ai
```

## What this gives you

`install-copilot-cli`, `install-claude-code`, `install-antigravity`
(aliased — as a real function, not a shell `alias`, so `wb tools` can
discover it — as `install-gemini-cli`), and `install-specify`, all via
`wb tools update`.

Installers only — no shell aliases or interactive functions. This repo is
distinct from a personal, separately-tracked AI-config tool (skills/prompts
you've built on top of these CLIs) by *kind* of content, not topic: this
repo installs the tools, generically, for anyone; a personal config repo
holds what you've built with them. Same split as "the terraform binary" vs.
"your terraform module library."

## Requires

- `install-copilot-cli`/`install-claude-code` (npm fallback path) need
  Node.js — `install-nvm` (`workbench-devtools`) if you don't already have
  a suitable version.
- `install-specify` needs `uv` — `install-uv` (`workbench-devtools`).
