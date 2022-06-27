#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# simplegrep1.pl
use warnings;
use strict;
die "Usage: $0 <pattern> <file> [<file> ...]\n" unless scalar(@ARGV) > 1;
my $pattern = shift @ARGV;    # get pattern from first argument
while (<>) {
  print "$ARGV:$. $_" if /$pattern/;
  close(ARGV) if eof;
}
exit 0;
