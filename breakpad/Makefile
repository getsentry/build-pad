all:
	echo 'Nothing to do' && exit 1

clean-deps:
	rm -rf ./deps

clean-all: clean-deps

fetch-breakpad:
	bash fetch-all.sh

build-macos:
	$(MAKE) -C macos

collect-macos:
	bash ./macos/collect-files.sh

build-macos-all: clean-deps fetch-breakpad build-macos collect-macos

build-linux:
	bash ./linux/build-shell.sh

collect-linux:
	bash ./linux/collect-files.sh

build-linux-all: clean-deps fetch-breakpad build-linux collect-linux

build-linux-docker-all:
	bash ./linux/build-docker.sh
