# device/empa/smartnfc/smartnfc.mk
LOCAL_PATH := $(call my-dir)
include $(call all-subdir-makefiles)
# Include package removal definitions
include device/empa/smartnfc/smartnfc_remove_packages.mk

######################################################################
# Boot Optimization
# Decrease Log level of kernel
PRODUCT_PROPERTY_OVERRIDES += \
    persist.log.tag=*V \
    persist.kernel.kloglevel=1 \
    persist.sys.init_log_level=1

# Decrease Dexopt optimization
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt.boot=verify-none \
    dalvik.vm.dex2oat-filter=verify-none \
    dalvik.vm.image-dex2oat-filter=verify-none \
    persist.device_config.runtime.native_boot_image=no \
    dalvik.vm.boot-dex2oat-threads=2

# Skip ART odsign processes
PRODUCT_PROPERTY_OVERRIDES += \
    ro.art.disableodsign=true \
    ro.odsign.disable=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.log.tag=*V \
    persist.kernel.kloglevel=1 \
    persist.sys.init_log_level=1 \
    sys.init_log_level=1 \
    loglevel=3 \
    ro.kernel.android.bootloglevel=3 \
    dalvik.vm.dexopt.boot=verify-none \
    dalvik.vm.dex2oat-filter=verify-none \
    dalvik.vm.image-dex2oat-filter=verify-none \
    dalvik.vm.boot-dex2oat-threads=2 \
    persist.device_config.runtime.native_boot_image=no \
    ro.art.disableodsign=true \
    ro.odsign.disable=true

######################################################################
BOARD_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy

#PRODUCT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy
#BOARD_SEPOLICY_DIRS += system/sepolicy/private
#BOARD_SEPOLICY_UNION, defines files that should be combined with existing files from AOSP of the same name.
BOARD_SEPOLICY_UNION += file_contexts \
                        seapp_contexts \
			            service_contexts \
			            smartnfc.te

######################################################################
# copy init.smartnfc.rc to /system/etc/init folder in the target file system
# device_owner.xml is used by the Device Policy Manager to designate the CoffeeUI APK as the Device Owner application.
PRODUCT_COPY_FILES += \
    device/empa/smartnfc/init.smartnfc.rc:system/etc/init/init.smartnfc.rc \
    device/empa/smartnfc/configs/device_owner.xml:system/etc/device_owner.xml \
    device/empa/smartnfc/configs/device_policies.xml:system/etc/device_policies.xml \
    device/empa/smartnfc/configs/privapp-permissions-coffeeui.xml:system/etc/permissions/privapp-permissions-coffeeui.xml \
    device/empa/smartnfc/configs/coffeeui_system.prop:system/etc/coffeeui_system.prop \
    device/empa/smartnfc/configs/fstab.smartnfc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.smartnfc

# run init_smartnfc.rc in init stage
#INIT += /system/etc/init/init.smartnfc.rc
# Modern init.rc dahil etme yöntemi
TARGET_INIT_VENDOR_RC += device/empa/smartnfc/init.smartnfc.rc

TARGET_RECOVERY_FSTAB := device/empa/smartnfc/configs/fstab.smartnfc
# Veya fstab için daha modern
TARGET_VENDOR_FSTAB := device/empa/smartnfc/configs/fstab.smartnfc

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    lockscreen.locked_out_disabled=true \
    lockscreen.disable_pinning_dialogs=true \
    loglevel=3 \
    ro.kernel.android.bootloglevel=3

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    sys.init_log_level=1

#    ro.launcher.default_package=org.qtproject.coffeeui \
#    ro.launcher.default_class=org.qtproject.coffeeui.CoffeeActivity \
######################################################################
# Add custom application
PRODUCT_PACKAGES += \
    CoffeeUI


