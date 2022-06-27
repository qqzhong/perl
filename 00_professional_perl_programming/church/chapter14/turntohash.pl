#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# turntohash.pl
use warnings;
use strict;
my %args;
if ( scalar(@ARGV) % 2 ) {
  die "Odd number of arguments passed to $0";
} else {
  %args = @ARGV;    # convert to hash
  foreach ( keys %args ) {
    # check each of the keys
    die "Bad argument '$_' does not start with -" unless /^-/;
    print "$_ => $args{$_}\n";
  }
}

print(qx(date));
exit 0;
