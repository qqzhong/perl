#!/usr/bin/perl
# pid3.pl
use warnings;
use strict;
open( PS, "-|" ) || exec 'ps', 'aux';
while (<PS>) {
  chomp;
  print "PS: $_ \n";
}
close PS;
