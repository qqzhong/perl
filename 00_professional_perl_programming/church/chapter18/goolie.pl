#!/usr/bin/perl
# goolie.pl
use warnings;
use strict;
use Text::Abbrev;
my $abbreviations;

sub print_hash {
  print "Abbreviations: \n";
  foreach ( sort keys %{$abbreviations} ) {
    print "\t$_ => $abbreviations->{$_} \n";
  }
}
$abbreviations = abbrev( 'gin', 'gang', 'goolie' );
print_hash($abbreviations);
