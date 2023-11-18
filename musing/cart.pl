#!/usr/bin/env perl

# cart port view, 1 in lower left corner, anticlockwise, 24 entries
$c26 = "a7 a6 a5 a4 a3 a2 a1 a0 d0 d1 d2 gnd " .
       "d3 d4 d5 d6 d7 a12 a10 a11 a9 a8 +5v sgnd";
# add gaps...
$c26 =~ s/gnd d3/gnd gap gap gap gap gap gap d4/g;
$c26 = "gap gap gap ". $c26 . " gap gap gap";

# cart port view, 1 in lower left, anticlockwise, 36 entries
$c52 = "d0 d1 d2 d3 d4 d5 d6 d7 en8000 eb4000 nc gnd gnd gnd a6 a5 a2 lock ".
       "a0 a1 a3 a4 gnd vid/gnd gnd +5v a7 nc a8 audio a9 a13 a10 a12 a11 lock";

#cart port view, 1 in lower left, anticlockwise, 36 entries
$c78 = "a15 audio key a7 a6 a5 a4 a3 a2 a1 a0 d0 d1 d2 gnd key irq phase2 ".
       "r/w halt key d3 d4 d5 d6 d7 a12 a10 a11 a9 a8 +5v gnd key a13 a14";

# compare

@c26 = split / /, $c26;
@c52 = split / /, $c52;
@c78 = split / /, $c78;

for ($i = 0 ; $i < 36; $i++) {
   print ($i+1);
   print "\t";
   print $c26[$i];
   print "\t";
   print $c52[$i];
   print "\t";
   print $c78[$i];
   print "\n";
}
