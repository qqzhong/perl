#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;

# Example 14-3. Command-line parsing via Getopt::Long
# Handle command lines of the form:
#
# > orchestrate --i source.txt --o=dest.orc -v
# Use the standard Perl module...
use Getopt::Long;
# Variables that will be set in response to command-line arguments
# (with defaults values, in case those arguments are not provided)...
my $infile  = '-';
my $outfile = '-';

my $length  = 24;
my $width   = 78;
my $verbose = 0;
# Specify cmdline options and process command line...
my $options_okay = GetOptions(
  # Application-specific options...
  'in=s'     => \$infile,                       # --in option expects a string
  'out=s'    => \$outfile,                      # --out option expects a string
  'length=i' => \$length,                       # --length option expects an integer
  'width=i'  => \$width,                        # --width option expects an integer
  'verbose'  => \$verbose,                      # --verbose flag is boolean
                                                # Standard meta-options
                                                # (the subroutines are executed immediately the flag is encountered
                                                # and are used here to throw suitable exceptions – see Chapter 13)...
  'version'  => sub { X::Version->throw(); },
  'usage'    => sub { X::Usage->throw(); },
  'help'     => sub { X::Help->throw(); },
  'man'      => sub { X::Man->throw(); },
);
# Fail if unknown arguments encountered...
X::Usage->throw() if !$options_okay;
# Report intended behaviour...
if ($verbose) {
  print "Loading first $length chunks of file: $infile\n";
}
