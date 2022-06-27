#!/usr/bin/perl
# dot.pl
use warnings;
use strict;
use Term::ReadKey;
ReadMode 'cbreak';
# enable autoflush
$| = 1;
my $char;
do {
  $char = ReadKey 0.5;
  print $char? $char : '.';
} until ( lc($char) eq 'q' );
ReadMode 'restore';
