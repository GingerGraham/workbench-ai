# Changelog

All notable changes to `workbench-ai` are documented here.

## [Unreleased]

## [0.1.0] - 2026-09-09

### Added

- Initial decomposition from `workbench-precursor` (Wave C):
  `install-copilot-cli`, `install-claude-code`, `install-antigravity`,
  `install-gemini-cli`, `install-specify`.
- Added `installed-copilot-cli`, `installed-claude-code`,
  `installed-antigravity`, `installed-gemini-cli`, `installed-specify` —
  report install status to `wb tools upgrade`/`wb tools list --status`
  (workbench-core §12 D43).

### Fixed

- `install-gemini-cli` was a shell `alias` to `install-antigravity`, not a
  function — `wb tools`' discovery (`_extract_function_names`) matches
  `install-<name>()` function definitions only, so the alias form was
  invisible to `wb tools list`/`wb tools update`. Converted to a real
  one-line wrapper function.
- `install-antigravity` trusted `curl -fsSL … | bash`'s own exit status. In
  an interactive shell (no `pipefail`), that's `bash`'s status, not
  `curl`'s — a 404 or network failure leaves `curl -f` non-zero but `bash`
  sees empty input and exits 0, so the function could report success on a
  failed install. Now re-checks that `agy` actually landed, matching
  `install-claude-code`'s pattern.

### Changed

- `install-antigravity` drops the precursor's `_restore_managed_shell_files`
  call — that workaround reset git-tracked rc-file symlinks after the
  upstream installer script appended PATH lines to them; `workbench-core`'s
  rc files are plain stubs, never a live git working tree, so the problem
  it solved doesn't exist here.
- `WORKBENCH_OS` replaces `DOTFILES_OS`.
