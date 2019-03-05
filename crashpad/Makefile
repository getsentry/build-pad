all:
	echo 'Nothing to do' && exit 1

clean-dist:
	rm -rf ./dist

clean-all: clean-dist
	rm -rf ./build

fetch-crashpad:
	bash ./fetch.sh

build:
	bash ./build-shell.sh

collect:
	bash ./collect-files.sh

build-docker:
	bash ./build-docker.sh

collect-windows:
	bash collect-files-windows.sh

build-windows-all: clean-all fetch-crashpad build collect-windows

build-linux-all: clean-all fetch-crashpad build-docker
	sudo chown -R $(USER) ./build
	$(MAKE) collect
	
build-mac-all: clean-all fetch-crashpad build collect
