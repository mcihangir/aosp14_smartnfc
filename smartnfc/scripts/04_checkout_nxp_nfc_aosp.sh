#!/usr/bin/env bash
set -euo pipefail

# ============================================
# NXP NFC trees checkout/update helper
# - Works from any directory
# - Operates on two groups:
#     1) CORE_PROJECTS   -> real git repos (Table 3)
#     2) TEST_PATHS      -> leaf drop-ins (Table 4); most are NOT git repos
# - By default: detect origin HEAD branch and fast-forward only.
# ============================================

# Usage:
#   04_checkout_nxp_trees.sh [--root <AOSP_ROOT>] [--reset] [--stash] [--stash-all] [--check-only] [--branch <name>]
#
# Options:
#   --root/-R       : AOSP root. Default: $AOSP_ROOT_FOLDER or ~/workspace/.../QSSI.14
#   --reset/-r      : Force reset to origin/<branch> (destructive)
#   --stash/-s      : Stash tracked changes (keeps untracked out/)
#   --stash-all     : Stash tracked + untracked (can be slow if out/ is huge)
#   --check-only/-c : Only show status/last commit; no checkout/pull/reset
#   --branch        : Override branch for ALL repos (otherwise use origin HEAD)
#
# Notes:
# - TEST_PATHS are usually plain directories (no .git). We will just report them.

ROOT_DEFAULT="${AOSP_ROOT_FOLDER:-$HOME/workspace/qcm2290_4290_android14.0_ba04_r001/QSSI.14}"
AOSP_ROOT="$ROOT_DEFAULT"
DO_RESET=0
DO_STASH=0
DO_STASH_ALL=0
CHECK_ONLY=0
OVERRIDE_BRANCH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root|-R) AOSP_ROOT="$2"; shift 2;;
    --reset|-r) DO_RESET=1; shift;;
    --stash|-s) DO_STASH=1; shift;;
    --stash-all) DO_STASH=1; DO_STASH_ALL=1; shift;;
    --check-only|-c) CHECK_ONLY=1; shift;;
    --branch) OVERRIDE_BRANCH="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

if [[ ! -d "$AOSP_ROOT" ]]; then
  echo "[ERR] AOSP root not found: $AOSP_ROOT"; exit 1
fi

cd "$AOSP_ROOT"

# -----------------------------
# GROUP 1: Core git repositories (Table 3)
# -----------------------------
CORE_PROJECTS=(
  packages/apps/Nfc
  system/nfc
  hardware/nxp/nfc
  vendor/nxp/frameworks
  hardware/nxp/emvco
  device/empa/smartnfc/patches/nfc/platform_reference
)

# -----------------------------
# GROUP 2: Test / TDA leaves (Table 4) – usually NOT git repos
# -----------------------------
TEST_PATHS=(
  packages/apps/SMCU_Switch
  packages/apps/Nfc/EMVCoModeSwitchApp
  hardware/nxp/nfc/Cockpit
  hardware/nxp/nfc/SelfTest
  hardware/nxp/nfc/SelfTest_pn7160
  hardware/nxp/nfc/SelfTestAidl
  hardware/nxp/nfc/load_unload
  # NOTE: You placed nfc_tda at top-level system/nfc_tda in your clone script.
  # If you later relocate it under system/nfc/src/adaptation/tda, update this path.
  system/nfc_tda
  hardware/nxp/emvco/emvco_tda
  hardware/nxp/emvco/emvco_tda_test
  packages/apps/Nfc/NfcTdaTestApp
)

ts() { date +%Y%m%d_%H%M%S; }

default_branch() {
  local repo="$1"
  git -C "$repo" remote show origin 2>/dev/null | sed -n 's/.*HEAD branch: //p' | head -n1
}

do_repo() {
  local p="$1"
  echo "==== $p ===="

  if ! [[ -d "$p/.git" ]]; then
    echo "[SKIP] Not a git repo (or missing): $p"
    return 0
  fi

  # Show quick status
  git -C "$p" status -s -b -uno || true

  if [[ "$CHECK_ONLY" -eq 1 ]]; then
    git -C "$p" log -1 --oneline || true
    echo
    return 0
  fi

  # Stash if requested
  if [[ "$DO_STASH" -eq 1 ]]; then
    if ! git -C "$p" diff-index --quiet HEAD --; then
      if [[ "$DO_STASH_ALL" -eq 1 ]]; then
        git -C "$p" stash push -u -m "auto-stash-$(ts)"
      else
        git -C "$p" stash push -m "auto-stash-$(ts)"
      fi
    fi
  else
    # Avoid destructive ops on dirty tree
    if ! git -C "$p" diff-index --quiet HEAD --; then
      echo "[WARN] Working tree dirty. Use --stash or --reset to proceed. Skipping."
      echo
      return 0
    fi
  fi

  # Resolve branch
  local BR="$OVERRIDE_BRANCH"
  if [[ -z "$BR" ]]; then
    BR="$(default_branch "$p")"
    if [[ -z "${BR:-}" ]]; then
      echo "[WARN] Could not detect origin HEAD branch. Falling back to 'main'."
      BR="main"
    fi
  fi

  # Fetch
  git -C "$p" fetch --prune origin || true

  # Ensure local branch exists & checked out
  if ! git -C "$p" rev-parse --verify "$BR" >/dev/null 2>&1; then
    git -C "$p" checkout -B "$BR" "origin/$BR" || git -C "$p" checkout "$BR" || true
  else
    git -C "$p" checkout "$BR" || true
  fi

  # Update
  if [[ "$DO_RESET" -eq 1 ]]; then
    git -C "$p" reset --hard "origin/$BR" || true
  else
    git -C "$p" pull --ff-only origin "$BR" || {
      echo "[WARN] Fast-forward not possible on $p. Consider '--reset'."
    }
  fi

  git -C "$p" log -1 --oneline || true
  echo
}

echo ">>> CORE PROJECTS (git) <<<"
for p in "${CORE_PROJECTS[@]}"; do
  do_repo "$p"
done

echo ">>> TEST / TDA PATHS (likely NOT git) <<<"
for p in "${TEST_PATHS[@]}"; do
  if [[ -d "$p/.git" ]]; then
    # Rare case: if you kept them as independent repos, treat like core
    do_repo "$p"
  else
    if [[ -d "$p" ]]; then
      echo "==== $p ===="
      echo "[INFO] Present (not a git repo) – nothing to checkout/pull."
      echo
    else
      echo "==== $p ===="
      echo "[MISS] Path does not exist."
      echo
    fi
  fi
done

echo "[DONE] Checkout/update finished. Use '--check-only' to re-verify."
