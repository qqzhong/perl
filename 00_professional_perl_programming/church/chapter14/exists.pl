#!/usr/bin/perl
# exists.pl
use warnings;
use strict;
use Getopt::Long;
my %opts;
GetOptions( \%opts, 'option!' );
if ( exists $opts{'option'} ) {    # the option was seen on the command-line
}
