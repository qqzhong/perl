#!/usr/bin/perl
# signals.pl
use warnings;
use strict;
foreach ( sort keys %SIG ) {
  print "$_\n";
}
