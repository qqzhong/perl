#!/usr/bin/perl
# B_Lint.pl
use warnings;
use strict;
$count = @file = <>;
for (@file) {
  if ( /^\d\d\d/ and $& > 300 ) {
    print;
  } else {
    summarize($_);
  }
}
