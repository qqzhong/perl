#!/usr/bin/perl
# backseat.pl;
# lack of use warnings;
use strict;
setpgrp 0, 0;
if ( my $pid = fork ) {
  # exit if parent
  print "Backseat daemon started with id $pid \n";
  exit 0;
}
# child loops in background
while (1) {
  alarm 60;
  foreach ( int rand(3) ) {
    $_ == 0 and print("Go Left! \n"),       last;
    $_ == 1 and print("Go Right! \n"),      last;
    $_ == 2 and print("Wait, go back! \n"), last;
  }
  sleep rand(3) + 1;
}
