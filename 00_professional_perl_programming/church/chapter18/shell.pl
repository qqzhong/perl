#!/usr/bin/perl
# shell.pl
use warnings;
use strict;
use Text::ParseWords qw(shellwords);
my @input = ( 'This is "a phrase"', 'So is\ this', q('and this'), "But this isn\\'t", 'And neither \"is this\"', );
print "Input: ", join( '', @input ), "\n";
my @words = shellwords(@input);
print scalar(@words), " words:\n";

foreach (@words) {
  print "\t$_\n";
}
