#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# NDK version
cat ${ANDROID_NDK_HOME}/source.properties

cd ${SCRIPT_DIR}/../deps/breakpad/android/sample_app

# Override APP_STL
# See https://developer.android.com/ndk/guides/cpp-support.html
APP_STL_CONFIG='APP_STL := c++_static'
if ! grep "${APP_STL_CONFIG}" jni/Application.mk; then
    echo -e "\n${APP_STL_CONFIG}" >> jni/Application.mk
fi

# Compile!
${ANDROID_NDK_HOME}/ndk-build --debug
