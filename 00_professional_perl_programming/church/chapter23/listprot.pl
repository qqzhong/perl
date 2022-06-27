#!/usr/bin/perl
# listprot.pl
use warnings;
use strict;
while ( my ( $name, $aliases, $proto ) = getprotoent ) {
  print "$proto $name ($aliases)\n";
}
