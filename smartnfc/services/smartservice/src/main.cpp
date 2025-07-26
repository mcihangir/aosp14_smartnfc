#include "globals.h"
#include "DisplayManager.h"

int main() {
    LOGI("SmartManager started");
    
    DisplayManager dm;
    dm.setReverseLandscape();

    if (!DisplayManager::setReverseLandscape()) {
        LOGE("Failed to change orientation");
        return -1;
    }

    return 0; // Exit after setting orientation
}
