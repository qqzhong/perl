#!/usr/bin/perl
# siglist.pl
use warnings;
use strict;
use Config;
my @signals = split ' ', $Config{sig_name};
for ( 0 .. $#signals ) {
  print "$_ $signals[$_] \n" unless $signals[$_] =~ /^NUM/;
}
