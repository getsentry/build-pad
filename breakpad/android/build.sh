#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# NDK version
cat ${ANDROID_NDK_HOME}/source.properties

cd ${SCRIPT_DIR}/../deps/breakpad/android/sample_app


CONFIG_LINES=(
  # Override APP_STL
  # See https://developer.android.com/ndk/guides/cpp-support.html
  'APP_STL := c++_static'
  # See https://developer.android.com/ndk/guides/application_mk#app_platform
  'APP_PLATFORM := android-16'
)

for conf_line  in "${CONFIG_LINES[@]}"; do
  if ! grep "${conf_line}" jni/Application.mk; then
    echo -e "\n${conf_line}" >> jni/Application.mk
  fi
done

# Compile!
${ANDROID_NDK_HOME}/ndk-build --debug
