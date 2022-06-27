#!/usr/bin/perl
# listhostnames.pl
use warnings;
use strict;
my @hosts;
while ( my $name = gethostent ) {
  push @hosts, $name;
}
print "Hosts: @hosts\n";
