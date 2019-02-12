#!/usr/bin/env bash
set -eux

OUT_DIR="package_out"
OUT_DIR_BIN="$OUT_DIR/bin"
OUT_DIR_INCLUDE="$OUT_DIR/include"
OUT_DIR_LIB="$OUT_DIR/lib"
CRASHPAD_DIR="./build/crashpad"
BUILD_DIR="${CRASHPAD_DIR}/out/Default"

rm -rf $OUT_DIR
mkdir $OUT_DIR

# include/
mkdir $OUT_DIR_INCLUDE
cp -R $CRASHPAD_DIR/{client,util,third_party/mini_chromium/mini_chromium} $OUT_DIR_INCLUDE
find $OUT_DIR_INCLUDE -type f -not -name '*.h' -delete

# bin/
mkdir $OUT_DIR_BIN
cp $BUILD_DIR/{crashpad_handler,crashpad_http_upload,crashpad_database_util} $OUT_DIR_BIN

# lib/
mkdir $OUT_DIR_LIB
cp $BUILD_DIR/obj/{client/libclient.a,util/libutil.a,third_party/mini_chromium/mini_chromium/base/libbase.a} $OUT_DIR_LIB
