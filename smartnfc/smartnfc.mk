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
    device/empa/smartnfc/init.smartnfc.rc:system/etc/init/init.smartnfc.rc \
    device/empa/smartnfc/configs/device_owner.xml:system/etc/device_owner.xml \
    device/empa/smartnfc/configs/device_policies.xml:system/etc/device_policies.xml \
    device/empa/smartnfc/configs/privapp-permissions-coffeeui.xml:system/etc/permissions/privapp-permissions-coffeeui.xml \
    device/empa/smartnfc/configs/coffeeui_system.prop:system/etc/coffeeui_system.prop

# run init_smartnfc.rc in init stage
INIT += /system/etc/init/init.smartnfc.rc

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    lockscreen.locked_out_disabled=true \
    lockscreen.disable_pinning_dialogs=true
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

#Default Launchers
PRODUCT_PACKAGES_REMOVE += \
    Launcher3 \
    Launcher3QuickStep \
    Quickstep \
    SettingsIntelligence \
    AmbientSense

PRODUCT_PACKAGES_REMOVE += \
    VoiceAIRef \
    uimgbaservice \
    aptxui \
    RamdumpCopyUI \
    PresenceApp \
    PerformanceMode \
    AtFwd2 \
    Protips \
    RideModeAudio \
    ConferenceDialer \
    QCC \
    QdcmFF \
    EmergencyInfo \
    QesdkSysService \
    workloadclassifier \
    PowerSaveMode \
    WfdService \
    DCTestApp \
    imssettings \
    uceShimService \
    SnapdragonMusic \
    ConnectionManagerTestApp \
    MangoLwm2mApp \
    FM2 \
    BTTestApp \
    WigigSettings \
    SimContact \
    QtiTelephonySettings \
    QtiTelephonyService \
    QtiTelephony \
    QSensorTest \
    WigigTetheringRRO \
    QColor \
    colorservice \
    UnifiedSensorTestApp \
    TrustZoneAccessService \
    ConnectionSecurityService \
    datastatusnotification \
    DeviceStatisticsService \
    DeviceInfo \
    my.tests.snapdragonsdktest \
    SnapdragonSVA \
    ModemTestMode \
    QualcommVoiceActivation \
    aptxals \
    aptxacu \
    atfwd \
    DynamicDDSService \
    BTTestApp \
    xrwifiservice \
    xrcbservice \
    xrvdservice \
    dpmserviceapp \
    dcf \
    ODLT 

