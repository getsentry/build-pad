#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

PACKAGE_NAME="breakpad-$(uname -s)"
DIST_DIR="${SCRIPT_DIR}/dist"
GLOBAL_DIST="${SCRIPT_DIR}/../dist"
ARCHIVES_DIR="${DIST_DIR}/out"
ARCHIVE_OUT_NAME="${ARCHIVES_DIR}/${PACKAGE_NAME}.zip"
OUT_DIR="${DIST_DIR}/${PACKAGE_NAME}"
OUT_DIR_BIN="${OUT_DIR}/bin"
OUT_DIR_INCLUDE="${OUT_DIR}/include"
OUT_DIR_LIB="${OUT_DIR}/lib"
BREAKPAD_DIR="${SCRIPT_DIR}/../deps/breakpad"
BUILD_DIR="${SCRIPT_DIR}/build"

rm -rf $OUT_DIR $ARCHIVE_OUT_NAME $ARCHIVES_DIR
mkdir -p $OUT_DIR $ARCHIVES_DIR

# include/
mkdir $OUT_DIR_INCLUDE
cp -R $BREAKPAD_DIR/src/{client,common} $OUT_DIR_INCLUDE
find $OUT_DIR_INCLUDE -type f -not -name '*.h' -delete
find $OUT_DIR_INCLUDE -type d -empty -exec rmdir -p {} \; 2>/dev/null || true

# bin/
mkdir $OUT_DIR_BIN
cp $BUILD_DIR/{dump_syms,minidump_dump,minidump_stackwalk} $OUT_DIR_BIN

# lib/
mkdir $OUT_DIR_LIB
cp $BUILD_DIR/{libbreakpad_client,libdisasm}.a $OUT_DIR_LIB

pushd $OUT_DIR
zip -r $ARCHIVE_OUT_NAME .

mkdir -p $GLOBAL_DIST
cp $ARCHIVE_OUT_NAME $GLOBAL_DIST
