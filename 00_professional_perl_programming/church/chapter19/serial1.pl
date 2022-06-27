#!/usr/bin/perl
# serial1.pl
use warnings;
use strict;
use lib '.';
use Serial;
my @serials;
foreach ( 1 .. 10 ) {
  push @serials, new Serial;
}
print $serials[4]->serial, "\n";
my $serial = new Serial(2001);
print $serial->serial, "\n";
