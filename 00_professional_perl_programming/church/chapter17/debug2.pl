#!/usr/bin/perl
# debug2.pl
use warnings;
use strict;
# predeclare 'debug' in the symbol table
use subs 'debug';
if ( $ENV{'DEBUG'} ) {
  # define a real debug subroutine if debugging is enabled
  *debug = sub {
    print STDERR @_, "\n";
  }
} else {
  # otherwise define a useless stub
  *debug = sub { };
}
debug "This is a debug message";
