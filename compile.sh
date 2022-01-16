compiler='/proj/isaac/tools/sjasmplus/build/sjasmplus'

$compiler \
  --outprefix=build/ \
  --nologo \
  --lst=build/source.lst \
  --raw=build/build.raw \
  src/main.asm
