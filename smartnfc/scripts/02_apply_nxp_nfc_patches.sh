#!/usr/bin/env bash
# Minimal, file-level checkout + patch apply with ABSOLUTE patch paths.
# Run from AOSP root: /home/mcihangir/workspace/qcm2290_4290_android14.0_ba04_r001/QSSI.14
set -euo pipefail

ROOT="$(pwd)"
PATCH_ROOT="device/empa/smartnfc/patches/nfc/platform_reference/build_cfg/build_pf_patches"

PATCH_BAZEL="${ROOT}/${PATCH_ROOT}/AROOT_build_bazel.patch"
PATCH_MAKE="${ROOT}/${PATCH_ROOT}/AROOT_build_make.patch"
PATCH_SOONG="${ROOT}/${PATCH_ROOT}/AROOT_build_soong.patch"
PATCH_FWB="${ROOT}/${PATCH_ROOT}/AROOT_frameworks_base.patch"
PATCH_FWN="${ROOT}/${PATCH_ROOT}/AROOT_frameworks_native.patch"
PATCH_PROTO="${ROOT}/${PATCH_ROOT}/AROOT_frameworks_proto_logging.patch"
PATCH_BT="${ROOT}/${PATCH_ROOT}/AROOT_packages_modules_Bluetooth.patch"
PATCH_SYSLOG="${ROOT}/${PATCH_ROOT}/AROOT_system_logging.patch"

echo "== AROOT_build_bazel.patch =="
echo "[INFO] checkout: build/bazel/common.bazelrc"
[ -f build/bazel/common.bazelrc ] && git checkout -- build/bazel/common.bazelrc
echo "[INFO] apply   : build/bazel <= ${PATCH_BAZEL}"
git -C build/bazel apply -p1 "${PATCH_BAZEL}"
echo

echo "== AROOT_build_make.patch =="
echo "[INFO] checkout: build/make/target/product/gsi/34.txt"
[ -f build/make/target/product/gsi/34.txt ] && git checkout -- build/make/target/product/gsi/34.txt
echo "[INFO] checkout: build/make/target/product/gsi/current.txt"
[ -f build/make/target/product/gsi/current.txt ] && git checkout -- build/make/target/product/gsi/current.txt
echo "[INFO] apply   : build/make <= ${PATCH_MAKE}"
git -C build/make apply -p1 "${PATCH_MAKE}"
echo

echo "== AROOT_build_soong.patch =="
echo "[INFO] checkout: build/soong/cc/config/vndk.go"
[ -f build/soong/cc/config/vndk.go ] && git checkout -- build/soong/cc/config/vndk.go
echo "[INFO] apply   : build/soong <= ${PATCH_SOONG}"
git -C build/soong apply -p1 "${PATCH_SOONG}"
echo

echo "== AROOT_frameworks_base.patch =="
echo "[INFO] checkout: frameworks/base/core/java/android/nfc/INfcAdapter.aidl"
[ -f frameworks/base/core/java/android/nfc/INfcAdapter.aidl ] && git checkout -- frameworks/base/core/java/android/nfc/INfcAdapter.aidl
echo "[INFO] checkout: frameworks/base/core/java/android/os/BinderProxy.java"
[ -f frameworks/base/core/java/android/os/BinderProxy.java ] && git checkout -- frameworks/base/core/java/android/os/BinderProxy.java
echo "[INFO] checkout: frameworks/base/core/res/res/values/config.xml"
[ -f frameworks/base/core/res/res/values/config.xml ] && git checkout -- frameworks/base/core/res/res/values/config.xml
echo "[INFO] checkout: frameworks/base/services/core/java/com/android/server/Watchdog.java"
[ -f frameworks/base/services/core/java/com/android/server/Watchdog.java ] && git checkout -- frameworks/base/services/core/java/com/android/server/Watchdog.java
echo "[INFO] apply   : frameworks/base <= ${PATCH_FWB}"
git -C frameworks/base apply -p1 "${PATCH_FWB}"
echo

echo "== AROOT_frameworks_native.patch =="
echo "[INFO] new file: frameworks/native/data/etc/com.android.se.xml (no checkout needed)"
echo "[INFO] apply   : frameworks/native <= ${PATCH_FWN}"
git -C frameworks/native apply -p1 "${PATCH_FWN}"
echo

echo "== AROOT_frameworks_proto_logging.patch =="
echo "[INFO] checkout: frameworks/proto_logging/stats/stats_log_api_gen/Android.bp"
[ -f frameworks/proto_logging/stats/stats_log_api_gen/Android.bp ] && git checkout -- frameworks/proto_logging/stats/stats_log_api_gen/Android.bp
echo "[INFO] apply   : frameworks/proto_logging <= ${PATCH_PROTO}"
git -C frameworks/proto_logging apply -p1 "${PATCH_PROTO}"
echo

echo "== AROOT_packages_modules_Bluetooth.patch =="
echo "[INFO] checkout: packages/modules/Bluetooth/system/btif/Android.bp"
[ -f packages/modules/Bluetooth/system/btif/Android.bp ] && git checkout -- packages/modules/Bluetooth/system/btif/Android.bp
echo "[INFO] apply   : packages/modules/Bluetooth <= ${PATCH_BT}"
git -C packages/modules/Bluetooth apply -p1 "${PATCH_BT}"
echo

echo "== AROOT_system_logging.patch =="
echo "[INFO] checkout: system/logging/liblog/logger_write.cpp"
[ -f system/logging/liblog/logger_write.cpp ] && git checkout -- system/logging/liblog/logger_write.cpp
echo "[INFO] apply   : system/logging <= ${PATCH_SYSLOG}"
git -C system/logging apply -p1 "${PATCH_SYSLOG}"
echo

echo "== DONE =="
echo "[KONTROL] git status"
echo "[KONTROL] git diff --name-only --stat | sed -n '1,200p'"
