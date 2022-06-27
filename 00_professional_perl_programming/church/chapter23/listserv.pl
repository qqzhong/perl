#!/usr/bin/perl
# listserv.pl
use warnings;
use strict;
while ( my ( $name, $aliases, $port, $proto ) = getservent ) {
  print "$name\t$port/$proto\t$aliases\n";
}
