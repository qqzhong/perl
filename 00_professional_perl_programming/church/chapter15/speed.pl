#!/usr/bin/perl
# speed.pl
use warnings;
use strict;
use POSIX;
use Term::Cap;
# set the line speed explicitly - but 'POSIX::B9600' may not be defined
my $termcap1 = Term::Cap->Tgetent(
  {
    TERM   => undef,
    OSPEED => POSIX::B9600
  }
);
