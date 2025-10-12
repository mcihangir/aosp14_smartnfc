# device/empa/smartnfc/sepolicy/SEPolicy.mk

# Add our system_ext sepolicy dirs (public/private)
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS  += device/empa/smartnfc/sepolicy/generic/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/empa/smartnfc/sepolicy/generic/private

# PN7220
BOARD_VENDOR_SEPOLICY_DIRS += device/empa/smartnfc/nfc_pn7220/sepolicy

# (optional) EMVCo vendor sepolicy
#BOARD_VENDOR_SEPOLICY_DIRS += device/empa/smartnfc/nfc_pn7220/sepolicy_emvco