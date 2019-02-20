#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PACKAGE_NAME="crashpad-Windows"
DIST_DIR="${SCRIPT_DIR}/dist"
ARCHIVES_DIR="${DIST_DIR}/out"
ARCHIVE_OUT_NAME="${ARCHIVES_DIR}/${PACKAGE_NAME}.zip"
OUT_DIR="${DIST_DIR}/${PACKAGE_NAME}"
OUT_DIR_BIN="${OUT_DIR}/bin"
OUT_DIR_INCLUDE="${OUT_DIR}/include"
OUT_DIR_LIB="${OUT_DIR}/lib"
CRASHPAD_DIR="${SCRIPT_DIR}/build/crashpad"
BUILD_DIR="${CRASHPAD_DIR}/out/Default"

rm -rf $OUT_DIR $ARCHIVE_OUT_NAME $ARCHIVES_DIR
mkdir -p $OUT_DIR $ARCHIVES_DIR

# include/
mkdir $OUT_DIR_INCLUDE
cp -R $CRASHPAD_DIR/{client,util,third_party/mini_chromium/mini_chromium} $OUT_DIR_INCLUDE
find $OUT_DIR_INCLUDE -type f -not -name '*.h' -delete
find $OUT_DIR_INCLUDE -type d -empty -exec rmdir -p {} \; 2>/dev/null || true

# bin/
mkdir $OUT_DIR_BIN
cp $BUILD_DIR/{crashpad_handler.exe,crashpad_http_upload.exe,crashpad_database_util.exe} $OUT_DIR_BIN

# lib/
mkdir $OUT_DIR_LIB
cp $BUILD_DIR/obj/{client/client{.lib,_cc.pdb},util/util{.lib,_cc.pdb},third_party/mini_chromium/mini_chromium/base/base{.lib,_cc.pdb}} $OUT_DIR_LIB

ZIP=$SCRIPT_DIR/../bin/zip.py

pushd $DIST_DIR
$ZIP -r $ARCHIVE_OUT_NAME $PACKAGE_NAME
