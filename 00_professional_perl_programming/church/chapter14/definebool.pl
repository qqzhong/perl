#!/usr/bin/perl
# definebool.pl
use warnings;
use strict;
use Getopt::Long;
my ( $verbose, $background );    # parse 'verbose' and 'background' flags
GetOptions( verbose => \$verbose, background => \$background );
print "Verbose messages on \n" if $verbose;
