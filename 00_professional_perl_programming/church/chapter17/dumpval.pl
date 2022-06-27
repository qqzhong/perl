#!/usr/bin/perl
# dumpval.pl
use warnings;
use strict;
use Dumpvalue;
my $dumper         = new Dumpvalue( compactDump => 1, globPrint => 1 );
my %myhashvariable = (
  'top' => {
    middle => [
      'left', 'right',
      {
        'bottom' =>
      }
    ]
  }
);
# dump one variable
$dumper->dumpValue( \%myhashvariable )
