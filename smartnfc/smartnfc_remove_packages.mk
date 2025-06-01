
PRODUCT_PACKAGES_REMOVE += bootanimation

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

#PRODUCT_PACKAGES_REMOVE += \
#    Provision \
#    com.android.provision \
#    com.android.managedprovisioning

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

PRODUCT_PACKAGES_REMOVE += \
    SampleLocationAttribution \
    PhotoTable \
    LiveWallpapersPicker \
    Traceur \
    HTMLViewer 
    
#    ConnectionSecurityService \
#    TrustZoneAccessService \
#    UnifiedSensorTestApp
#    CallFeaturesSetting \
#    ConfURIDialer \
#    remoteSimLockAuthentication \

# Safe removal of non-essential priv-app packages
# Safe removal of non-essential priv-app packages
PRODUCT_PACKAGES_REMOVE += \
    CallLogBackup \
    CellBroadcastLegacyApp \
    ContactsProvider \
    LocalTransport \
    MtpService \
    NetworkStackNext \
    ONS \
    ProxyHandler \
    SoundPicker \
    TelephonyProvider \
    Telecom \
    TeleService

#    DownloadProviderUi \
#    ManagedProvisioning \
#    StatementService \


#    InputDevices \
#    FusedLocation \
#    IntentResolver \
#    CredentialManager \
#    SharedStorageBackup \
#    MediaProviderLegacy \
#    DocumentsUI \
#    ExternalStorageProvider \
#    Tag \

# Descriptions:
# CallLogBackup: Legacy call log backup handler
# CellBroadcastLegacyApp: Old cell broadcast app (not required for kiosk)
# ContactsProvider: Contacts database provider
# CredentialManager: Used for credential storage UI (not needed)
# DocumentsUI: Storage file picker UI
# DownloadProviderUi: Download UI (not needed in kiosk)
# ExternalStorageProvider: External storage interface for file picker
# FusedLocation: Location fusion engine (disable if no GPS/location needed)
# InputDevices: External input settings
# IntentResolver: Chooser activity for implicit intents (safe to remove if no sharing)
# LocalTransport: Local backup transport
# ManagedProvisioning: Setup wizard and enterprise provisioning
# MediaProviderLegacy: Legacy media scanner
# MtpService: Media Transfer Protocol over USB
# NetworkStackNext: Next-gen network stack (keep only if advanced connectivity is required)
# ONS: Opportunistic Network Service
# ProxyHandler: Proxy auto-config handler
# SharedStorageBackup: Backup for shared storage data
# SoundPicker: Sound selection UI
# StatementService: Web domain verification handler
# Tag: Basic NFC tag handler (remove if using your own NFC stack)
# TelephonyProvider, Telecom, TeleService: Telephony stack (remove if no SIM or calling needed)


# Safe removal of non-essential system app packages from /system/app
    #Bluetooth \
    #BluetoothMidiService \
    #CameraExtensionsProxy \
	
PRODUCT_PACKAGES_REMOVE += \
    CarrierDefaultApp \
    Email \
    FotaUpdater \
    SecureElement \
    SimAppDialog \
    Stk \
    WallpaperBackup

#    CertInstaller \
#    CompanionDeviceManager \
#    KeyChain \
#    ExtShared \

#    PacProcessor \


# Descriptions:
# Bluetooth: Disable only if Bluetooth is not needed
# BluetoothMidiService: MIDI over Bluetooth support
# CameraExtensionsProxy: Camera2 extensions (safe to remove if not using AOSP camera)
# CarrierDefaultApp: Default carrier app (used for SIM-based provisioning)
# CertInstaller: Certificate installer UI
# CompanionDeviceManager: Wearable & IoT pairing (disable in kiosk)
# Email: AOSP email app
# ExtShared: External shared library proxy
# FotaUpdater: Firmware over-the-air updater
# KeyChain: Credential manager UI
# PacProcessor: Proxy auto-config interpreter
# SecureElement: SE/NFC applet manager
# SimAppDialog: STK UI (SIM Toolkit)
# Stk: SIM Toolkit service
# WallpaperBackup: Wallpaper backup handler (safe in kiosk)

# Additional packages generally safe to remove in kiosk mode
PRODUCT_PACKAGES_REMOVE += \
    BackupRestoreConfirmation \
    DynamicSystemInstallationService

# Descriptions:
# BackupRestoreConfirmation: Shown during backup operations
# DynamicSystemInstallationService: DSU support (not required for static system images)