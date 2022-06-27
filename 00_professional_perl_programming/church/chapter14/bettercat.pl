#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# bettercat.pl
use warnings;
use strict;
while (<>) {
  print "$ARGV:$.:$_";
  close(ARGV) if eof;
}
exit 0;
