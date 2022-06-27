#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# autodefine.pl
use warnings;
use strict;

print(qx(date));

sub my_subroutine {
  print "Defining sub...\n";
  # uncomment next line and remove 'no warnings' for Perl < 5.6
  # local $^W = 0;
  eval 'no warnings; sub my_subroutine { print "Autodefined!\n"; }';
  &my_subroutine;
}
my_subroutine;
my_subroutine;

exit 0;
