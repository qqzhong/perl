#!/usr/bin/perl
# join.pl
use warnings;
use strict;
# check we have threads
BEGIN {
  use Config;
  die "Threadbare! \n" unless $Config{'usethreads'};
}
use Thread;
# define a subroutine for threads to execute
sub threadsub {
  my $self = Thread->self;
  print "Thread ", $self->tid, " started \n";
  sleep 10;
  print "Thread ", $self->tid, " ending \n";
}
# start up five threads, one second intervals
my @threads;
foreach ( 1 .. 5 ) {
  push @threads, new Thread \&threadsub;
  sleep 1;
}
# wait for the last thread started to end
while ( my $thread = shift @threads ) {
  print "Waiting for thread ", $thread->tid, " to end... \n";
  $thread->join;
  print "Ended \n";
}
# exit
print "All threads done \n";
