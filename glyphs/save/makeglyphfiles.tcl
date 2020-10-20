# makeglyphfiles.tcl
set entire [image create photo]
$entire read glyph.gif

set glyphlist {z3G zGG2 zG2G G2G2-G2G2 GGG2-GG2G G3G-GG3 GGGG-GGGG t3GGG-t3GGG
GGG2-G2GG GG2G-GGG2}

set g(z3G) "156 36 183 65"
set g(zGG2) "183 36 215 65"
set g(zG2G) "215 36 244 65"

set g(G2G2-G2G2) "26 72 64 103"
set g(GGG2-GG2G) "64 72 118 103"
set g(G3G-GG3) "119 72 161 103"
set g(GGGG-GGGG) "162 72 237 103"
set g(t3GGG-t3GGG) "238 72 292 103"
set g(GGG2-G2GG) "292 72 349 103"
set g(GG2G-GGG2) "350 72 405 103"



foreach glyph $glyphlist {
 set e [image create photo]
 set cmd "$e copy $entire -from $g($glyph)"
 eval $cmd
 $e write $glyph.gif -format gif
 image delete $e
 }

  
