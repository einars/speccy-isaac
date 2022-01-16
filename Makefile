all: compile run

compile:
	./compile.sh

run:
	fuse ./build/isaac.sna

watch:
	watchexec -W -w src ./compile.sh
