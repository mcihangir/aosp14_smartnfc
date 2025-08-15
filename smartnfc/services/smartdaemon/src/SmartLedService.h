// File: SmartLedService.h
// Description: AIDL-based service implementation header for controlling LEDs.

#pragma once
// Implements AIDL NDK server side for ISmartLed

#include <aidl/smartnfc/hardware/led/BnSmartLed.h>
#include <string>

namespace aidl::smartnfc::hardware::led {

class SmartLedService : public BnSmartLed {
public:
    SmartLedService() = default;
    ~SmartLedService() override = default;

    // Implements AIDL interface methods
    ndk::ScopedAStatus setLedState(const std::string& ledName, int state) override;
    ndk::ScopedAStatus getLedState(const std::string& ledName, int* _aidl_return) override;

private:
    // Helper to build sysfs path
    static std::string ledPath(const std::string& ledName) {
        return "/sys/class/leds/" + ledName + "/brightness";
    }
};

} // namespace aidl::smartnfc::hardware::led
