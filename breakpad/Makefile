all:
	echo 'Nothing to do' && exit 1

clean-deps:
	rm -rf ./deps

clean-all: clean-deps

fetch-breakpad:
	bash fetch-all.sh

# MacOS
build-macos:
	cd premake && premake5 gmake && make verbose=1

collect-macos:
	bash ./macos/collect-files.sh

build-macos-all: clean-deps fetch-breakpad build-macos collect-macos

# Linux
build-linux:
	bash ./linux/build-shell.sh

collect-linux:
	bash ./linux/collect-files.sh

build-linux-all: clean-deps fetch-breakpad build-linux collect-linux

build-linux-docker-all:
	bash ./linux/build-docker.sh

# Windows
build-windows:
	bash ./windows/build.sh

collect-windows:
	bash ./windows/collect-files.sh

build-windows-all: clean-deps fetch-breakpad build-windows collect-windows

# Android
build-android:
	bash ./android/build.sh

collect-android:
	bash ./android/collect-files.sh

build-android-all: clean-deps fetch-breakpad build-android collect-android
