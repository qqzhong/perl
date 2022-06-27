#!/usr/bin/perl
# bundle2.pl
use warnings;
use strict;
use Getopt::Long;
Getopt::Long::Configure("bundling_override");
my ( $a, $b, $c, $abc ) = ( -1, -1, -1, -1 );
GetOptions( a => \$a, b => \$b, c => \$c, "abc:s" => \$abc );
print "a: $a\n";
print "b: $b\n";
print "c: $c\n";
print "abc: $abc\n";
