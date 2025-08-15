//smartdaemon.cpp
#include "SmartLedService.h"
#include <aidl/smartnfc/hardware/led/ISmartLed.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>
#include <android-base/logging.h>

using aidl::smartnfc::hardware::led::SmartLedService;
using aidl::smartnfc::hardware::led::ISmartLed;

int main(int argc, char** argv) {
    // Initialize logging and set a global tag
    android::base::InitLogging(argv, android::base::StderrLogger);
    android::base::SetDefaultTag("SmartDaemon");

    LOG(INFO) << "Starting smartdaemon...";

    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<SmartLedService> service =
        ndk::SharedRefBase::make<SmartLedService>();

    const std::string instance = std::string(ISmartLed::descriptor) + "/default";
    if (AServiceManager_addService(service->asBinder().get(), instance.c_str()) != STATUS_OK) {
        LOG(ERROR) << "Failed to register service: " << instance;
        return EXIT_FAILURE;
    }

    LOG(INFO) << "Service registered: " << instance << " (joining thread pool)";
    ABinderProcess_joinThreadPool();
    LOG(INFO) << "smartdaemon exiting.";
    return EXIT_SUCCESS;
}
