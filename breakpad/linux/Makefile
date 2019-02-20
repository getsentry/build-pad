dist:
	bash ./collect-files.sh

clean:
	rm -rf ./dist

main: dist
	g++ main.cpp --std=c++11 -I ./dist/breakpad-Linux/include/ -L ./dist/breakpad-Linux/lib -lbreakpad_client -lpthread -lbreakpad
