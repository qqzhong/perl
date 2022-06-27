#!/usr/bin/perl
# anonhash.pl
use warnings;
use strict;
use Term::Cap;
# create a terminal capability object - warns of unknown output speed
my $termcap = Term::Cap->Tgetent( { TERM => undef } );
print "Capabilities found: ", join( ',', sort( keys %{$termcap} ) ), "\n";
