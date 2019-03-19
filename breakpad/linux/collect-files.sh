#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

PACKAGE_NAME="breakpad-Linux"
DIST_DIR="${SCRIPT_DIR}/dist"
GLOBAL_DIST="${SCRIPT_DIR}/../dist"
ARCHIVES_DIR="${DIST_DIR}/out"
ARCHIVE_OUT_NAME="${ARCHIVES_DIR}/${PACKAGE_NAME}.zip"
OUT_DIR="${DIST_DIR}/${PACKAGE_NAME}"
OUT_DIR_BIN="${OUT_DIR}/bin"
OUT_DIR_INCLUDE="${OUT_DIR}/include"
OUT_DIR_LIB="${OUT_DIR}/lib"
BREAKPAD_DIR="${SCRIPT_DIR}/../deps/breakpad"
BUILD_DIR="${BREAKPAD_DIR}/../premake/bin/Release"

find $PREMAKE_DIR

rm -rf $OUT_DIR $ARCHIVE_OUT_NAME $ARCHIVES_DIR
mkdir -p $OUT_DIR $ARCHIVES_DIR

# include/
mkdir $OUT_DIR_INCLUDE
cp -R -L $BREAKPAD_DIR/src/{client,common,google_breakpad,third_party} $OUT_DIR_INCLUDE
find $OUT_DIR_INCLUDE -type f -not -name '*.h' -delete
find $OUT_DIR_INCLUDE -type d -empty -exec rmdir -p {} \; 2>/dev/null || true

# bin/
mkdir $OUT_DIR_BIN
cp $BUILD_DIR/processor/{minidump_dump,minidump_stackwalk} $OUT_DIR_BIN

# lib/
mkdir $OUT_DIR_LIB
cp $BUILD_DIR/{libbreakpad.a,client/linux/libbreakpad_client.a,third_party/libdisasm/libdisasm.a} $OUT_DIR_LIB

pushd $DIST_DIR
zip -r $ARCHIVE_OUT_NAME $PACKAGE_NAME

mkdir -p $GLOBAL_DIST
cp $ARCHIVE_OUT_NAME $GLOBAL_DIST
