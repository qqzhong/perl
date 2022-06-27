#!/usr/bin/perl
# filenames.pl
use strict;
use warnings;
use Getopt::Long;
my @filenames;
GetOptions( "file=s" => \@filenames );
print scalar(@filenames), " files entered\n";
foreach (@filenames) {
  print "\t$_\n";
}
