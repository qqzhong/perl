#!/usr/bin/perl
# menu.pl
use warnings;
use strict;
use Term::ReadKey;
ReadMode 'cbreak';
print "Enter an option 1 to 9: ";
my $selection = 0;
do {
  $selection = int( ReadKey 0 );
} until ( $selection > 0 and $selection < 10 );
print "You typed $selection\n";
ReadMode 'restore';
