#!/usr/bin/env bash
# tests/check-installers-node-minimum.sh — workbench-ai
# Plain bash, numbered OK:/FAIL: checks, matching workbench-core's
# tests/check-*.sh convention (no framework).
#
# install-copilot-cli and install-claude-code's npm fallback must tell
# _ensure_npm the lowest Node.js major version they can use (22 and 18), so
# its package-manager fallback never sudo-installs an older Node.js just for
# the version check afterwards to fail (workbench-ai#26). The Core API
# helpers are stubbed here; nothing is installed or elevated.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

FAILED=0
check_no=0
ok()   { check_no=$((check_no + 1)); echo "OK:   [$check_no] $*"; }
fail() { check_no=$((check_no + 1)); echo "FAIL: [$check_no] $*"; FAILED=$((FAILED + 1)); }

CALLS="$(mktemp)"
trap 'rm -f "${CALLS}"' EXIT

# Stubs for what workbench-core provides. STUB_ENSURE_NPM_RC and
# STUB_NODE_OK_RC set what _ensure_npm and _node_version_at_least return.
log_info()  { :; }
log_warn()  { :; }
log_error() { echo "log_error: $*" >> "${CALLS}"; }
_ensure_npm()           { echo "_ensure_npm $*" >> "${CALLS}"; return "${STUB_ENSURE_NPM_RC}"; }
_node_version_at_least() { echo "_node_version_at_least $*" >> "${CALLS}"; return "${STUB_NODE_OK_RC}"; }
_npm_global_install()   { echo "_npm_global_install $*" >> "${CALLS}"; return 0; }

# shellcheck source=shell/installers.sh
source "${REPO_ROOT}/shell/installers.sh"

# Anything other than Linux/Mac sends install-claude-code straight to its
# npm fallback, without touching curl.
WORKBENCH_OS="TestOS"

# ── install-copilot-cli ──────────────────────────────────────────────────────
: > "${CALLS}"
STUB_ENSURE_NPM_RC=1 STUB_NODE_OK_RC=0 install-copilot-cli >/dev/null 2>&1
rc=$?
if [[ "${rc}" -eq 1 ]] \
    && grep -qx '_ensure_npm 22' "${CALLS}" \
    && ! grep -q '^_npm_global_install' "${CALLS}" \
    && grep -q 'log_error: .*wb tools install nvm' "${CALLS}"; then
    ok "install-copilot-cli: _ensure_npm 22 fails -> exit 1, no install, error points to nvm"
else
    fail "install-copilot-cli: expected _ensure_npm 22, exit 1, no install, nvm hint (rc=${rc}): $(tr '\n' ';' < "${CALLS}")"
fi

: > "${CALLS}"
STUB_ENSURE_NPM_RC=0 STUB_NODE_OK_RC=1 install-copilot-cli >/dev/null 2>&1
rc=$?
if [[ "${rc}" -eq 1 ]] \
    && grep -qx '_node_version_at_least 22' "${CALLS}" \
    && ! grep -q '^_npm_global_install' "${CALLS}"; then
    ok "install-copilot-cli: npm present but Node < 22 -> exit 1, no install"
else
    fail "install-copilot-cli: expected exit 1 and no install when Node < 22 (rc=${rc}): $(tr '\n' ';' < "${CALLS}")"
fi

: > "${CALLS}"
STUB_ENSURE_NPM_RC=0 STUB_NODE_OK_RC=0 install-copilot-cli >/dev/null 2>&1
if grep -qx '_npm_global_install @github/copilot' "${CALLS}"; then
    ok "install-copilot-cli: npm and Node 22+ available -> installs @github/copilot"
else
    fail "install-copilot-cli: expected @github/copilot install: $(tr '\n' ';' < "${CALLS}")"
fi

# ── install-claude-code (npm fallback) ───────────────────────────────────────
: > "${CALLS}"
STUB_ENSURE_NPM_RC=1 STUB_NODE_OK_RC=0 install-claude-code >/dev/null 2>&1
rc=$?
if [[ "${rc}" -eq 1 ]] \
    && grep -qx '_ensure_npm 18' "${CALLS}" \
    && ! grep -q '^_npm_global_install' "${CALLS}" \
    && grep -q 'log_error: .*wb tools install nvm' "${CALLS}"; then
    ok "install-claude-code: _ensure_npm 18 fails -> exit 1, no install, error points to nvm"
else
    fail "install-claude-code: expected _ensure_npm 18, exit 1, no install, nvm hint (rc=${rc}): $(tr '\n' ';' < "${CALLS}")"
fi

: > "${CALLS}"
STUB_ENSURE_NPM_RC=0 STUB_NODE_OK_RC=0 install-claude-code >/dev/null 2>&1
if grep -qx '_ensure_npm 18' "${CALLS}" \
    && grep -qx '_npm_global_install @anthropic-ai/claude-code' "${CALLS}"; then
    ok "install-claude-code: npm and Node 18+ available -> installs @anthropic-ai/claude-code"
else
    fail "install-claude-code: expected @anthropic-ai/claude-code install: $(tr '\n' ';' < "${CALLS}")"
fi

echo
echo "==============================="
echo "Total OK/FAIL checks: ${check_no}, failed: ${FAILED}"
echo "==============================="
[[ "${FAILED}" -eq 0 ]]
