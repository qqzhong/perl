#!/usr/bin/perl
# listhost.pl
use warnings;
use strict;
while ( my ( $name, $aliases, $type, $length, @addrs ) = gethostent ) {
  print "$name\t[$type]\t$length\t$aliases\n";
}
