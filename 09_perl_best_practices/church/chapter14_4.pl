#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;

# Example 14-4. Command-line parsing via Getopt::Clade
# Handle command lines of the form:
#
# > orchestrate -in source.txt -o=dest.orc --verbose
# Specify and parse valid command-line arguments...
use Getopt::Clade q{
-i[n] [=] <file:in> Specify input file [default: '-']
-o[ut] [=] <file:out> Specify output file [default: '-']
-l[en] [=] <l:+int> Display length [default: 24 ]
-w[id] [=] <w:+int> Display width [default: 78 ]
-v Print all warnings
--verbose [ditto]
};
# Report intended behaviour...
if ( $ARGV{-v} ) {
  print "Loading first $ARGV{'-l'} chunks of file: $ARGV{'-i'}\n";
}
# etc.
