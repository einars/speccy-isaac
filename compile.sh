compiler='/proj/isaac/tools/sjasmplus/build/sjasmplus'

$compiler \
  --syntax=ab \
  --outprefix=build/ \
  --nologo \
  --lst=build/source.lst \
  --sym=build/isaac.sym \
  src/main.asm
