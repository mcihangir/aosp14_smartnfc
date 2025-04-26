# device/empa/smartnfc/smartnfc.mk
include $(call all-subdir-makefiles)
LOCAL_PATH := $(call my-dir)

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
    device/empa/smartnfc/init.smartnfc.rc:/system/etc/init/init.smartnfc.rc \
    device/empa/smartnfc/configs/device_owner.xml:system/etc/device_owner.xml \
    device/empa/smartnfc/configs/privapp-permissions-coffeeui.xml:system/etc/permissions/privapp-permissions-coffeeui.xml

# run init_smartnfc.rc in init stage
INIT += /system/etc/init/init.smartnfc.rc
######################################################################
# Add custom application
PRODUCT_PACKAGES += \
    CoffeeUI

# Remove unnecessary system packages (mostly from handheld_* and telephony_*)
PRODUCT_PACKAGES_REMOVE += \
    BasicDreams \
    BlockedNumberProvider \
    BookmarkProvider \
    Browser2 \
    BuiltInPrintService \
    Calendar \
    CalendarProvider \
    Contacts \
    DeskClock \
	EasterEgg \
	Gallery2 \
    MmsService \
    Music \
    MusicFX \
    PrintRecommendationService \
    PrintSpooler \
    QuickSearchBox \
    screenrecord \
    UserDictionaryProvider \
    VpnDialogs \
    WallpaperCropper

#REMOVE_PACKAGES += \

PRODUCT_PACKAGES_REMOVE += \
    Launcher3 \
    Quickstep \
    Launcher3QuickStep 