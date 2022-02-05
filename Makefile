all: compile run

compile:
	./compile.sh

run:
	fuse ./build/isaac.sna

watch:
	watchexec --no-vcs-ignore --on-busy-update do-nothing -W -w src ./compile.sh

sprites:
	cd scripts && clj parse-sprites.clj

deploy:
	scp build/isaac.sna spicausis.lv:spicausis.lv/isaac/
