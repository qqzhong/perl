#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# globdefine.pl
use warnings;
use strict;

sub my_subroutine {
  print "Defining sub...\n";
  no warnings;
  # remove above and add the following for Perl < 5.6
  # local $^W = 0;
  *my_subroutine = eval {
    sub {
      print "Autodefined!\n";
    }
  };
  &my_subroutine;
}
my_subroutine;
my_subroutine;

print(qx(date));
exit 0;
