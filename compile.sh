compiler='/proj/isaac/tools/sjasmplus/build/sjasmplus'

$compiler \
  --outprefix=build/ \
  --nologo \
  --lst=build/source.lst \
  --sym=build/isaac.sym \
  src/main.asm
