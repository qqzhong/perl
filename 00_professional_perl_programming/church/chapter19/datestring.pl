#!/usr/bin/perl
# datestring.pl
use warnings;
use strict;
use lib '.';
use DateString;
my $date = new DateString(time);
print "$date \n";
$date->format('GB');
print "$date \n";
$date->format('US');
print "$date \n";
