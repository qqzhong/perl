#!/usr/bin/perl
# serial2.pl
use warnings;
use strict;
use lib '.';
use Serial;
my $serial = new Serial;
print "First serial number is ", $serial->serial, "\n";
$serial->next(10000);
my $serial2 = new Serial;
print "Second serial number is ", $serial2->serial, "\n";
