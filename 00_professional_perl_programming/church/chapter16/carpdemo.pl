#!/usr/bin/perl
# carpdemo.pl
use warnings;
&Top::top;

package Top;
use Carp qw(cluck);

sub top {
  cluck "Called 'top'";
  &Middle::middle;
}

package Middle;
use Carp;

sub middle {
  carp "Are we there yet? Called 'middle'";
  &Bottom::bottom;
}

package Bottom;
use Carp;

sub bottom {
  carp "Here we are. Called 'bottom'";
  confess "I did it!";
}

