# device/empa/smartnfc/smartnfc.mk

# Add custom application
PRODUCT_PACKAGES += \
    coffeeui

# Remove unnecessary system packages (mostly from handheld_* and telephony_*)
REMOVE_PACKAGES += \
    AccessibilityMenu \
    BasicDreams \
    BlockedNumberProvider \
    BookmarkProvider \
    BootAnimation \
    Browser2 \
    BuiltInPrintService \
    Calendar \
    CalendarProvider \
    Camera2 \
    cameraserver \
    CameraExtensionsProxy \
    CaptivePortalLogin \
    CertInstaller \
    Contacts \
    CredentialManager \
    DeskClock \
    DocumentsUI \
    DownloadProviderUi \
    EasterEgg \
    ExternalStorageProvider \
    frameworks-base-overlays \
    FusedLocation \
    Gallery2 \
    Launcher3QuickStep \
    ManagedProvisioning \
    MmsService \
    Music \
    MusicFX \
    PrintRecommendationService \
    PrintSpooler \
    Provision \
    ProxyHandler \
    QuickSearchBox \
    screenrecord \
    SharedStorageBackup \
    StorageManager \
    Telecom \
    TelephonyProvider \
    TeleService \
    Traceur \
    UserDictionaryProvider \
    VpnDialogs \
    vr \
    WallpaperCropper

REMOVE_PACKAGES += \
    Launcher3 \
    Quickstep \
    Launcher3QuickStep 

# Optional packages (commented out: review before removal)
# REMOVE_PACKAGES += \
#     Bluetooth \
#     BluetoothMidiService \
#     InputDevices \
#     KeyChain \
#     LatinIME \
#     librs_jni \
#     PacProcessor \
#     preinstalled-packages-platform-handheld-product.xml \
#     preinstalled-packages-platform-handheld-system.xml \
#     SecureElement \
#     Settings \
#     SettingsIntelligence \
#     SimAppDialog \
#     SystemUI

# Filter out removed packages from the build
PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES), $(PRODUCT_PACKAGES))
