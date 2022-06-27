#!/usr/bin/perl
# serialdestroy.pl
use warnings;
use strict;
use lib '.';
use Serial;
my @serials;
foreach ( 1 .. 10 ) {
  push @serials, new Serial;
}
my $serial = new Serial(2001);
