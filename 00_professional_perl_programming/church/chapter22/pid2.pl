#!/usr/bin/perl
# pid2.pl
use warnings;
use strict;
my $pid = open( PS, "-|" );
die "Couldn't fork: $! \n" unless defined $pid;
if ($pid) {
  print "Subprocess ID is: $pid \n";
  while (<PS>) {
    chomp;
    print "PS: $_\n";
  }
  close PS;
} else {
  exec 'ps', 'aef';    # no shells here
}
