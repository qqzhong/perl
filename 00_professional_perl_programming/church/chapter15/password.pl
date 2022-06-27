#!/usr/bin/perl
# password.pl
use warnings;
use strict;
use Term::ReadKey;
ReadMode 'noecho';
print "Enter your password: ";
my $password = ReadLine 0;
print "Thanks!\n";
ReadMode 'restore';
