#!/usr/bin/perl
# bundle1.pl
use warnings;
use strict;
use Getopt::Long;
Getopt::Long::Configure("bundling");
my ( $a, $b, $c, $file );
GetOptions( a => \$a, b => \$b, c => \$c, "file=s" => \$file );
