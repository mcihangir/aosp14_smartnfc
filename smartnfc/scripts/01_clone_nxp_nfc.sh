#!/usr/bin/env bash
# NXP NFC (PN7220) repositories installer for AOSP/QSSI
# - Uses staging folder (nxp_repo) to keep clean .git repos outside AOSP tree.
# - Overwrites targets (force update) and creates missing directories.
# - Preserves target’s own .git (no nested git).
# - Safe to re-run; staging repos are reset to remote branch.

set -euo pipefail

# ---------- CONFIG ----------
ANDROID_ROOT="/home/mcihangir/workspace/qcm2290_4290_android14.0_ba04_r001/QSSI.14"
BRANCH="br_ar_14_comm_infra_dev"
TMP="/home/mcihangir/workspace/nxp_repo"
# ----------------------------

log()  { echo -e "\033[1;32m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*" >&2; }
err()  { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; }

[[ -d "$ANDROID_ROOT" ]] || { err "ANDROID_ROOT not found: $ANDROID_ROOT"; exit 1; }
mkdir -p "$TMP"

# Clone or hard-reset to remote branch (idempotent)
ensure_repo() {
  local url="$1" dst="$2" br="$3"
  if [[ -d "$dst/.git" ]]; then
    log "Updating existing repo: $dst"
    git -C "$dst" fetch --all --tags
    git -C "$dst" checkout "$br" || git -C "$dst" checkout -B "$br"
    git -C "$dst" reset --hard "origin/$br"
    git -C "$dst" clean -fdx
  else
    log "Cloning $url -> $dst (branch: $br)"
    mkdir -p "$(dirname "$dst")"
    git clone -b "$br" "$url" "$dst"
  fi
}

# Sync content but exclude source .git
safe_sync() {
  local SRC="$1" DEST="$2" LABEL="${3:-}"
  mkdir -p "$DEST"
  [[ -d "$SRC" ]] || { warn "Skip: $LABEL (source not found: $SRC)"; return; }
  log "Syncing $LABEL -> $DEST"
  rsync -a --delete --exclude='.git' "$SRC"/ "$DEST"/
}

log "ANDROID_ROOT = $ANDROID_ROOT"
log "NXPREPO      = $TMP"

# -------------------- TABLE 3 --------------------
ensure_repo "https://github.com/nxp-nfc-infra/nxp_nci_hal_nfc.git"                  "$TMP/nxp_nci_hal_nfc"               "$BRANCH"
ensure_repo "https://github.com/nxp-nfc-infra/nxp_nci_hal_libnfc-nci.git"           "$TMP/nxp_nci_hal_libnfc-nci"        "$BRANCH"
ensure_repo "https://github.com/nxp-nfc-infra/nfcandroid_nfc_hidlimpl.git"          "$TMP/nfcandroid_nfc_hidlimpl"       "$BRANCH"
ensure_repo "https://github.com/nxp-nfc-infra/nfcandroid_frameworks.git"            "$TMP/nfcandroid_frameworks"         "$BRANCH"
ensure_repo "https://github.com/nxp-nfc-infra/nfcandroid_emvco_aidlimpl.git"        "$TMP/nfcandroid_emvco_aidlimpl"     "$BRANCH"

safe_sync "$TMP/nxp_nci_hal_nfc"               "$ANDROID_ROOT/packages/apps/Nfc"                 "Table3 → packages/apps/Nfc"
safe_sync "$TMP/nxp_nci_hal_libnfc-nci"        "$ANDROID_ROOT/system/nfc"                        "Table3 → system/nfc"
safe_sync "$TMP/nfcandroid_nfc_hidlimpl"       "$ANDROID_ROOT/hardware/nxp/nfc"                  "Table3 → hardware/nxp/nfc"
safe_sync "$TMP/nfcandroid_frameworks"         "$ANDROID_ROOT/vendor/nxp/frameworks"             "Table3 → vendor/nxp/frameworks"
safe_sync "$TMP/nfcandroid_emvco_aidlimpl"     "$ANDROID_ROOT/hardware/nxp/emvco"                "Table3 → hardware/nxp/emvco"

# -------------------- Step-6 payloads --------------------
ensure_repo "https://github.com/nxp-nfc-infra/nfcandroid_platform_reference.git"    "$TMP/nfcandroid_platform_reference" "$BRANCH"

safe_sync "$TMP/nfcandroid_platform_reference/vendor/nxp/nfc"   "$ANDROID_ROOT/vendor/nxp/nfc"   "Step-6 → vendor/nxp/nfc"
safe_sync "$TMP/nfcandroid_platform_reference/vendor/nxp/emvco" "$ANDROID_ROOT/vendor/nxp/emvco" "Step-6 → vendor/nxp/emvco"

# -------------------- TABLE 4 --------------------
ensure_repo "https://github.com/nxp-nfc-infra/nfcandroid_infra_test_apps.git"       "$TMP/nfcandroid_infra_test_apps"    "$BRANCH"
ensure_repo "https://github.com/nxp-nfc-infra/nfcandroid_infra_comm_libs.git"       "$TMP/nfcandroid_infra_comm_libs"    "$BRANCH"

TA="$TMP/nfcandroid_infra_test_apps/test_apps"
CL="$TMP/nfcandroid_infra_comm_libs"

safe_sync "$TA/SMCU_Switch"        "$ANDROID_ROOT/packages/apps/SMCU_Switch"         "Table4 → packages/apps/SMCU_Switch"
safe_sync "$TA/EMVCoModeSwitchApp" "$ANDROID_ROOT/packages/apps/Nfc/EMVCoModeSwitchApp" "Table4 → packages/apps/Nfc/EMVCoModeSwitchApp"
safe_sync "$CL/NfcTdaTestApp"      "$ANDROID_ROOT/packages/apps/Nfc/NfcTdaTestApp"   "Table4 → packages/apps/Nfc/NfcTdaTestApp"

safe_sync "$TA/Cockpit"            "$ANDROID_ROOT/hardware/nxp/nfc/Cockpit"          "Table4 → hardware/nxp/nfc/Cockpit"
safe_sync "$TA/SelfTest"           "$ANDROID_ROOT/hardware/nxp/nfc/SelfTest"         "Table4 → hardware/nxp/nfc/SelfTest"
safe_sync "$TA/SelfTest_pn7160"    "$ANDROID_ROOT/hardware/nxp/nfc/SelfTest_pn7160"  "Table4 → hardware/nxp/nfc/SelfTest_pn7160"
safe_sync "$TA/SelfTestAidl"       "$ANDROID_ROOT/hardware/nxp/nfc/SelfTestAidl"     "Table4 → hardware/nxp/nfc/SelfTestAidl"
safe_sync "$TA/load_unload"        "$ANDROID_ROOT/hardware/nxp/nfc/load_unload"      "Table4 → hardware/nxp/nfc/load_unload"

safe_sync "$CL/nfc_tda"            "$ANDROID_ROOT/system/nfc_tda"                    "Table4 → system/nfc_tda"
safe_sync "$CL/emvco_tda"          "$ANDROID_ROOT/hardware/nxp/emvco/emvco_tda"      "Table4 → hardware/nxp/emvco/emvco_tda"
safe_sync "$CL/emvco_tda_test"     "$ANDROID_ROOT/hardware/nxp/emvco/emvco_tda_test" "Table4 → hardware/nxp/emvco/emvco_tda_test"

log "============================================================"
log " Done. Table 3 + Table 4 installed; Step-6 payloads deployed."
log " Staging repos (with .git) are under: $TMP"
log " To update later: git -C <repo> checkout <tag> && re-run."
log "============================================================"
