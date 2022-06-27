#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# multisearch.pl
use warnings;
use strict;
use Getopt::Long;
my @terms;
GetOptions( 'term:s' => \@terms );
die "Usage $0 [-t term [-t term]] file ...\n" unless @terms;
# build regular expressions
my $regexp = "";
foreach (@terms) {
  $regexp .= 'print("$ARGV:$.(' . $_ . ')$_\n") if /\b' . $_ . '\b/o;' . "\n";
}
# dump out the loop body for interest
print "Searching with:\n$regexp";
# build loop
my $loop = 'while (<>) {chomp; ' . $regexp . '}';
# evaluate loop
eval $loop;

print(qx(date));
exit 0;
