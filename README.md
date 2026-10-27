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
discover it — as `install-gemini-cli`), and `install-specify`. Install one
with `wb tools install <name>` (e.g. `wb tools install claude-code`) and
update an installed one with `wb tools upgrade <name>`.

Installers only — no shell aliases or interactive functions. This repo is
distinct from a personal, separately-tracked AI-config tool (skills/prompts
you've built on top of these CLIs) by *kind* of content, not topic: this
repo installs the tools, generically, for anyone; a personal config repo
holds what you've built with them. Same split as "the terraform binary" vs.
"your terraform module library."

## Requires

- `install-copilot-cli`/`install-claude-code` (npm fallback path) need
  Node.js — `wb tools install nvm` (`workbench-devtools`) if you don't
  already have a suitable version.
- `install-specify` needs `uv` — `wb tools install uv` (`workbench-devtools`).

## What these installers verify

Nothing beyond "the download arrived and isn't empty." Each one runs the
vendor's own current install path, unpinned and without a checksum or
signature check. This is an accepted trade-off (2026-10 decision), unlike
the installers in other workbench modules that pin a key or check a
SHA-256:

| Installer | What runs |
|---|---|
| `install-claude-code` | Anthropic's install script, `https://claude.ai/install.sh`, downloaded then run with `bash`; on failure, npm `@anthropic-ai/claude-code` at its latest version |
| `install-antigravity` / `install-gemini-cli` | Google's install script, `https://antigravity.google/cli/install.sh`, downloaded then run with `bash` |
| `install-copilot-cli` | npm `@github/copilot` at its latest version |
| `install-specify` | `uv tool install` from the head of the `github/spec-kit` git repository |

If that isn't acceptable on a machine, don't run these installers there;
install the tool yourself from a release you've checked.
