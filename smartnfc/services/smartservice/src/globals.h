#ifndef GLOBALS_H
#define GLOBALS_H

#include <android/log.h>

#define LOG_TAG "SmartManager"

// Simple macro for logging
#define LOGI(fmt, ...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, fmt, ##__VA_ARGS__)
#define LOGE(fmt, ...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, fmt, ##__VA_ARGS__)

#endif // GLOBALS_H
