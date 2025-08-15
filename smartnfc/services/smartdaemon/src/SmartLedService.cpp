//SmartLedService.cpp
#include "SmartLedService.h"
#include <android-base/logging.h>
#include <fstream>
#include <string>

namespace aidl::smartnfc::hardware::led {

ndk::ScopedAStatus SmartLedService::setLedState(const std::string& ledName, int state) {
    const int value = (state ? 255 : 0);
    const std::string path = SmartLedService::ledPath(ledName);

    LOG(INFO) << "setLedState() called: ledName=" << ledName
              << " path=" << path << " value=" << value;

    std::ofstream file(path, std::ios::out | std::ios::trunc);
    if (!file.is_open()) {
        PLOG(ERROR) << "open failed (write) path=" << path;
        return ndk::ScopedAStatus::fromServiceSpecificErrorWithMessage(
            -1, ("open failed: " + path).c_str());
    }
    file << value << std::endl;
    if (!file.good()) {
        PLOG(ERROR) << "write failed path=" << path << " value=" << value;
        return ndk::ScopedAStatus::fromServiceSpecificErrorWithMessage(
            -2, ("write failed: " + path).c_str());
    }

    LOG(INFO) << "setLedState() ok: ledName=" << ledName << " -> " << value;
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus SmartLedService::getLedState(const std::string& ledName, int* _aidl_return) {
    const std::string path = SmartLedService::ledPath(ledName);
    LOG(INFO) << "getLedState() called: ledName=" << ledName << " path=" << path;

    std::ifstream file(path);
    if (!file.is_open()) {
        *_aidl_return = -1;
        PLOG(ERROR) << "open failed (read) path=" << path;
        return ndk::ScopedAStatus::fromServiceSpecificErrorWithMessage(
            -1, ("open failed: " + path).c_str());
    }
    int v = 0;
    file >> v;
    if (!file.good()) {
        *_aidl_return = -1;
        PLOG(ERROR) << "read failed path=" << path;
        return ndk::ScopedAStatus::fromServiceSpecificErrorWithMessage(
            -2, ("read failed: " + path).c_str());
    }

    *_aidl_return = (v > 0) ? 1 : 0;
    LOG(INFO) << "getLedState() ok: ledName=" << ledName
              << " raw=" << v << " normalized=" << *_aidl_return;
    return ndk::ScopedAStatus::ok();
}

} // namespace aidl::smartnfc::hardware::led
