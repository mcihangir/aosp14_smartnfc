LOCAL_PATH := $(call my-dir)
include $(call all-subdir-makefiles)

# Include package removal definitions
include device/empa/smartnfc/smartnfc_remove_packages.mk

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
BOARD_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy

#SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/public
#SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/private

PRODUCT_PUBLIC_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/public
PRODUCT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/private


######################################################################
# Copy custom init and configuration files
PRODUCT_COPY_FILES += \
    device/empa/smartnfc/init.smartnfc.rc:system/etc/init/init.smartnfc.rc \
    device/empa/smartnfc/configs/device_owner.xml:system/etc/device_owner.xml \
    device/empa/smartnfc/configs/device_policies.xml:system/etc/device_policies.xml \
    device/empa/smartnfc/configs/privapp-permissions-smartlauncher.xml:system/etc/permissions/privapp-permissions-smartlauncher.xml \
    device/empa/smartnfc/configs/privapp-permissions-coffeeui.xml:system/etc/permissions/privapp-permissions-coffeeui.xml \
    device/empa/smartnfc/configs/smartnfc_system.prop:system/etc/smartnfc_system.prop \
    device/empa/smartnfc/configs/fstab.smartnfc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.smartnfc 
#    device/empa/smartnfc/services/smartservice/smartmanager.sh:system/bin/smartmanager.sh

PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce
PRODUCT_DEFAULT_PERMISSION_EXCEPTIONS += device/empa/smartnfc/configs/default-permissions-smartlauncher.xml

TARGET_INIT_VENDOR_RC += device/empa/smartnfc/init.smartnfc.rc
TARGET_RECOVERY_FSTAB := device/empa/smartnfc/configs/fstab.smartnfc
TARGET_VENDOR_FSTAB := device/empa/smartnfc/configs/fstab.smartnfc

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
    smartmanager \
    SmartLauncher \
    CoffeeUI \
    OpenCamera \
    AngryBirds \
    GeometryDash
