all: compile run

compile:
	./compile.sh

run:
	fuse ./build/isaac.sna
