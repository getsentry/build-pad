#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

PACKAGE_NAME="breakpad-Android"
DIST_DIR="${SCRIPT_DIR}/dist"
GLOBAL_DIST="${SCRIPT_DIR}/../dist"
ARCHIVES_DIR="${DIST_DIR}/out"
ARCHIVE_OUT_NAME="${ARCHIVES_DIR}/${PACKAGE_NAME}.zip"
BREAKPAD_DIR="${SCRIPT_DIR}/../deps/breakpad"
BUILD_DIR="${BREAKPAD_DIR}/src"

OUT_DIR="${DIST_DIR}/${PACKAGE_NAME}"
OUT_DIR_INCLUDE="${OUT_DIR}/include"

ANDROID_OBJ_DIR="$BREAKPAD_DIR/android/sample_app/obj"

rm -rf $OUT_DIR $ARCHIVE_OUT_NAME $ARCHIVES_DIR
mkdir -p $OUT_DIR $ARCHIVES_DIR

collect_for_platform() {
    PLATFORM="$1"
    PLATFORM_OBJ_PATH="$ANDROID_OBJ_DIR/local/${PLATFORM}"

    # bin/
    OUT_DIR_BIN="${OUT_DIR}/bin/${PLATFORM}"
    mkdir -p $OUT_DIR_BIN
    cp ${PLATFORM_OBJ_PATH}/test_google_breakpad $OUT_DIR_BIN

    # lib/
    OUT_DIR_LIB="${OUT_DIR}/lib/${PLATFORM}"
    mkdir -p $OUT_DIR_LIB
    cp ${PLATFORM_OBJ_PATH}/libbreakpad_client.a $OUT_DIR_LIB
}

# include/
mkdir $OUT_DIR_INCLUDE
cp -R -L $BREAKPAD_DIR/src/{client,common,google_breakpad,third_party} $OUT_DIR_INCLUDE
find $OUT_DIR_INCLUDE -type f -not -name '*.h' -delete
find $OUT_DIR_INCLUDE -type d -empty -exec rmdir -p {} \; 2>/dev/null || true
# TODO ^ this is the common part that can be shared between all platforms (win, linux, mac, android)

PLATFORMS=(arm64-v8a armeabi-v7a x86 x86_64)

for PLATFORM in "${PLATFORMS[@]}"; do
    collect_for_platform $PLATFORM
done

pushd $DIST_DIR
zip -r $ARCHIVE_OUT_NAME $PACKAGE_NAME

mkdir -p $GLOBAL_DIST
cp $ARCHIVE_OUT_NAME $GLOBAL_DIST
