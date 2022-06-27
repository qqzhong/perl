#!/usr/bin/perl
# config.pl
use warnings;
use strict;
use Getopt::Long;
my %config;
GetOptions( "config=s" => \%config );
print scalar( keys %config ), " definitions\n";
foreach ( sort keys %config ) {
  print "\t$_ => $config{$_}\n";
}
