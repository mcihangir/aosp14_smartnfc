#include "DisplayManager.h"
#include "globals.h"
#include <binder/IServiceManager.h>
#include <binder/Parcel.h>
#include <utils/String16.h>

using namespace android;

bool DisplayManager::setReverseLandscape() {
    sp<IServiceManager> sm = defaultServiceManager();
    sp<IBinder> wm = sm->getService(String16("window"));
    if (wm == nullptr) {
        LOGE("Cannot get window service");
        return false;
    }

    Parcel data, reply;
    data.writeInterfaceToken(String16("android.view.IWindowManager"));
    data.writeInt32(3); // 3 = reverse landscape

    status_t status = wm->transact(18, data, &reply); // 18 = freezeRotation
    if (status == NO_ERROR) {
        LOGI("Orientation set to reverse landscape (270°)");
        return true;
    } else {
        LOGE("Failed to set orientation, status=%d", status);
        return false;
    }
}
