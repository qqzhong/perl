#!/usr/bin/perl
# casesens.pl
use warnings;
use strict;
use Getopt::Long;
my %opts;
Getopt::Long::Configure( "ignore_case_always", "no_ignore_case" );
GetOptions( \%opts, 'verbose', 'visible', 'background' );
