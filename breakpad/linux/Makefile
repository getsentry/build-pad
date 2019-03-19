dist:
	bash ./collect-files.sh

clean:
	rm -rf ./dist
	rm -f *dmp a.out

main: dist
	g++ main.cpp --std=c++11 -I ./dist/breakpad-Linux/include/ -L ./dist/breakpad-Linux/lib -lbreakpad_client -lpthread
