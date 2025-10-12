LOCAL_PATH := $(call my-dir)
include $(call all-subdir-makefiles)
# Include package removal definitions
include device/empa/smartnfc/smartnfc_remove_packages.mk
# --- Pull in local SEPolicy additions
$(call inherit-product, device/empa/smartnfc/sepolicy/SEPolicy.mk)
#include device/empa/smartnfc/sepolicy/SEPolicy.mk

######################################################################
# Boot Optimization
WITH_DEXPREOPT := true
PRODUCT_DEXPREOPT_SPEED_APPS += CoffeeUI
DEX_PREOPT_DEFAULT := nostripping
PRODUCT_DEX_PREOPT_BOOT_IMAGE_ENABLED := true
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true

# Reduce log level for user builds
ifneq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.log.tag=*E \
    persist.kernel.kloglevel=3 \
    ro.kernel.android.bootloglevel=3
endif

# Dexopt settings
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt.boot=verify-profile \
    dalvik.vm.dex2oat-filter=speed-profile \
    dalvik.vm.image-dex2oat-filter=speed-profile \
    dalvik.vm.boot-dex2oat-threads=4

PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# Qt Quick Compiler and QML pre-compilation
QT_COMPILER_OPTIMIZATION := speed
QT_QMLLOCALSTORAGE_PRECOMPILE := true
QT_QMLCACHE_GENERATION := true
CONFIG += qtquickcompiler

# Zygote startup tweaks
PRODUCT_PROPERTY_OVERRIDES += \
    persist.zygote.prefetch_disable=false \
    ro.zygote.disable_gl_preload=true

######################################################################
# SEPolicy configuration

#SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS  += device/empa/smartnfc/sepolicy/system_ext/public
#SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/system_ext/private
#PRODUCT_PUBLIC_SEPOLICY_DIRS  += device/empa/smartnfc/sepolicy/system_ext/public
#PRODUCT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/system_ext/private
#PRODUCT_FILE_CONTEXTS            += device/empa/smartnfc/sepolicy/private/file_contexts
#SYSTEM_EXT_FILE_CONTEXTS         += device/empa/smartnfc/sepolicy/system_ext/private/file_contexts
#SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS  += device/empa/smartnfc/sepolicy/public
#SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/private
#BOARD_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy
#BOARD_PLAT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/plat_private
#PRODUCT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/private
#PRODUCT_FILE_CONTEXTS += device/empa/smartnfc/sepolicy/file_contexts
#PRODUCT_PUBLIC_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/public

######################################################################
# Copy custom init and configuration files
PRODUCT_COPY_FILES += \
    device/empa/smartnfc/init.smartnfc.rc:system/etc/init/init.smartnfc.rc \
    device/empa/smartnfc/configs/device_owner.xml:system/etc/device_owner.xml \
    device/empa/smartnfc/configs/device_policies.xml:system/etc/device_policies.xml \
    device/empa/smartnfc/configs/privapp-permissions-smartlauncher.xml:system/etc/permissions/privapp-permissions-smartlauncher.xml \
    device/empa/smartnfc/configs/privapp-permissions-coffeeui.xml:system/etc/permissions/privapp-permissions-coffeeui.xml \
    device/empa/smartnfc/configs/smartnfc_system.prop:system/etc/smartnfc_system.prop \
    device/empa/smartnfc/services/smartdaemon/smartdaemon.rc:system_ext/etc/init/smartdaemon.rc \
    device/empa/smartnfc/configs/smartlauncher_whitelist.xml:system/etc/smartlauncher_whitelist.xml \
    device/empa/smartnfc/configs/privapp-permissions-smartperipheral.xml:system/etc/permissions/privapp-permissions-smartperipheral.xml


#   device/empa/smartnfc/ueventd.smartnfc.rc:system/etc/ueventd.rc \
#   device/empa/smartnfc/configs/fstab.smartnfc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.smartnfc \

PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce
PRODUCT_DEFAULT_PERMISSION_EXCEPTIONS += device/empa/smartnfc/configs/default-permissions-smartlauncher.xml

TARGET_INIT_VENDOR_RC += device/empa/smartnfc/init.smartnfc.rc
TARGET_RECOVERY_FSTAB := device/empa/smartnfc/configs/fstab.smartnfc
TARGET_VENDOR_FSTAB := device/empa/smartnfc/configs/fstab.smartnfc


#DEVICE_MANIFEST_FILE += device/empa/smartnfc/vintf_fragments/smartnfc_manifest.xml
#DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/empa/smartnfc/vintf_fragments/smartnfc_framework_matrix.xml
######################################################################
# Default properties
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    lockscreen.locked_out_disabled=true \
    lockscreen.disable_pinning_dialogs=true \
    loglevel=3 \
    ro.kernel.android.bootloglevel=3 \
    sys.init_log_level=1

######################################################################
# Display orientation properties (reverse landscape)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.hwrotation=270 \
    persist.panel.orientation=270 \
    ro.surface_flinger.primary_display_orientation=3 \
    persist.sys.accelerometer_rotation=0 \
    ro.bootanimation.disabled=1

# Qualcomm cihazlar için ekstra (device/qcom/qssi/system.prop)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.orientation=3 \
    vendor.display.orientation=270 \
    vendor.display.primary_rotation_270=1

#    ro.input.touch.orientation.calibration=matrix \
#    ro.input.touch.orientation.matrix=0,-1,1,0,0,0,0,0,1 \
# Temporary: Allow permissive SELinux for development
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

######################################################################
# Warm-up packages for faster zygote startup
PRODUCT_PROPERTY_OVERRIDES += \
    zygote.warmup.packages=org.qtproject.smartlauncher

######################################################################
# Include custom applications in the build
PRODUCT_PACKAGES += \
    SmartLauncher \
    CoffeeUI \
    SmartPeripheral \
    OpenCamera \
    AngryBirds \
    TagInfo \
    smartnfc.hardware.led-ndk_platform \
    smartnfc.hardware.led-java \
    smartdaemon 

#    Firefox \
#    GeometryDash \
#    smartservice-api
#    SmartService \
######################################################################
# --- PN7220 seçimi (inherit'ten ÖNCE!) ---
TARGET_NXP_NFC_HW       := pn7220_i2cs

$(call inherit-product, vendor/nxp/nfc/device-nfc.mk)

# Keep only AOSP NFC
PRODUCT_PACKAGES += \
    NfcNci

# Remove vendor/NQ/QTI stacks & tools if present
PRODUCT_PACKAGES_REMOVE += \
    NQNfcNci \
    Nfc_st \
    nqnfcinfo \
    nqnfcservice

PRODUCT_PACKAGES_REMOVE += NQNfcNci Nfc_st nqnfcinfo nqnfcservice
PRODUCT_SYSTEM_EXT_REMOVE_PACKAGES += NQNfcNci Nfc_st nqnfcinfo nqnfcservice
STM_SYSTEM_NFC :=


# (Opsiyonel) SystemExt veya Product bölgelerinde bu apk’ları getiren overlay varsa kapat


# Board-level NFC konfig (varsa)
include vendor/nxp/nfc/BoardConfigNfc.mk
