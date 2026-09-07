# Changelog

All notable changes to `workbench-ai` are documented here.

## [Unreleased]

### Added

- Initial decomposition from `workbench-precursor` (Wave C):
  `install-copilot-cli`, `install-claude-code`, `install-antigravity`,
  `install-gemini-cli`, `install-specify`.

### Fixed

- `install-gemini-cli` was a shell `alias` to `install-antigravity`, not a
  function — `wb tools`' discovery (`_extract_function_names`) matches
  `install-<name>()` function definitions only, so the alias form was
  invisible to `wb tools list`/`wb tools update`. Converted to a real
  one-line wrapper function.

### Changed

- `install-antigravity` drops the precursor's `_restore_managed_shell_files`
  call — that workaround reset git-tracked rc-file symlinks after the
  upstream installer script appended PATH lines to them; `workbench-core`'s
  rc files are plain stubs, never a live git working tree, so the problem
  it solved doesn't exist here.
- `WORKBENCH_OS` replaces `DOTFILES_OS`.
