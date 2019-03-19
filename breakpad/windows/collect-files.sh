#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

PACKAGE_NAME="breakpad-Windows"
DIST_DIR="${SCRIPT_DIR}/dist"
GLOBAL_DIST="${SCRIPT_DIR}/../dist"
ARCHIVES_DIR="${DIST_DIR}/out"
ARCHIVE_OUT_NAME="${ARCHIVES_DIR}/${PACKAGE_NAME}.zip"
OUT_DIR="${DIST_DIR}/${PACKAGE_NAME}"
OUT_DIR_BIN="${OUT_DIR}/bin"
OUT_DIR_INCLUDE="${OUT_DIR}/include"
OUT_DIR_LIB="${OUT_DIR}/lib"
BREAKPAD_DIR="${SCRIPT_DIR}/../deps/breakpad"
PREMAKE_DIR="${SCRIPT_DIR}/../premake"

VS_DIR="/c/Program Files (x86)/Microsoft Visual Studio/2017"

if [[ "${BUILD_ARCH:-}" == "i686" ]]; then
    BUILD_DIR="${PREMAKE_DIR}/bin/Win32/Release"
    MSDIA_DLL_PATH="$VS_DIR/Enterprise/DIA SDK/bin/msdia140.dll"
else
    BUILD_DIR="${PREMAKE_DIR}/bin/Win64/Release"
    MSDIA_DLL_PATH="$VS_DIR/Enterprise/DIA SDK/bin/amd64/msdia140.dll"
fi

rm -rf $OUT_DIR $ARCHIVE_OUT_NAME $ARCHIVES_DIR
mkdir -p $OUT_DIR $ARCHIVES_DIR

# include/
mkdir $OUT_DIR_INCLUDE
cp -R -L $BREAKPAD_DIR/src/{client,common,google_breakpad,third_party} $OUT_DIR_INCLUDE
find $OUT_DIR_INCLUDE -type f -not -name '*.h' -delete
find $OUT_DIR_INCLUDE -type d -empty -exec rmdir -p {} \; 2>/dev/null || true

# bin/
mkdir $OUT_DIR_BIN
cp $BUILD_DIR/{crash.*,dump_syms.*} "$OUT_DIR_BIN"
# msdia140.dll is needed for dump_syms.exe
cp "$MSDIA_DLL_PATH" "$OUT_DIR_BIN"

# lib/
mkdir $OUT_DIR_LIB
cp $BUILD_DIR/breakpad_client.* "$OUT_DIR_LIB"

ZIP=$SCRIPT_DIR/../../bin/zip.py

pushd $DIST_DIR
$ZIP $ARCHIVE_OUT_NAME $PACKAGE_NAME

mkdir -p $GLOBAL_DIST
cp $ARCHIVE_OUT_NAME $GLOBAL_DIST
