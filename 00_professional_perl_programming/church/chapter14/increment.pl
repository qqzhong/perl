#!/usr/bin/perl
# increment.pl
use warnings;
use strict;
use Getopt::Long;
my $verbose = 0;    # default verbosity = off
GetOptions( "verbose+" => \$verbose );
# > perl increment.pl -verbose # $verbose == 1
# > perl increment.pl --verbose -verbose # $verbose == 2
# > perl increment.pl --verbose --verbose -verbose # $verbose == 3
