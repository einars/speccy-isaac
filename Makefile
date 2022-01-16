all: compile run

compile:
	./compile.sh

run:
	fuse ./build/isaac.sna

watch:
	watchexec -W -w src ./compile.sh

sprites:
	cd scripts && clj parse-sprites.clj

deploy:
	cp build/isaac.sna /services/web/dev.spicausis.lv/isaac/
	scp build/isaac.sna spicausis.lv:spicausis.lv/isaac/
