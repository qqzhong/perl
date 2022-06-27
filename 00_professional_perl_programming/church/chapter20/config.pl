#!/usr/bin/perl
# config.pl
use warnings;
use strict;
use Config qw(myconfig config_vars);
print myconfig();
$" = "\n ";
my @env = map { "$_=\"$ENV{$_}\"" } sort grep { /^PERL/ } keys %ENV;
print " \%ENV:\n @env\n" if @env;
print " \@INC:\n @INC\n";
