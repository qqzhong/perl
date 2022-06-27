#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# multifind.pl
use warnings;
use strict;
use Getopt::Long;
my @terms;
my $all = 0;    # find any term by default
GetOptions( 'term:s' => \@terms, 'all' => \$all );
die "Must specify search term" unless @terms;

# build regular expressions and logic
my @regexps = map { "/\\b$_\\b/o" } @terms;
my $logic   = join $all ? ' && ' : ' || ', @regexps;
# dump out the logic for interest
print "Searching with: $logic \n";
# interpolate an anonymous sub to test logic
my $match = eval "sub {$logic;}";
# scan input
while (<>) {
  print "$ARGV:$.:$_" if &$match;
}

print(qx(date));
exit 0;
