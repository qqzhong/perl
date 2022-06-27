#!/usr/bin/perl
# timeit.pl
use warnings;
use strict;
use Benchmark;

sub mysubroutine {
  my $timewaster = time**rand;
}
my $result = timeit( 1000000, 'mysubroutine' );
print "Executed ", $result->iters, " iterations in ", timestr($result), "\n";
