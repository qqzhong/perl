#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;

# Example 14-5. Command-line parsing via Getopt::Euclid
# Handle command lines of the form:
#
# > orchestrate -in source.txt -o=dest.orc --verbose
# Create a command-line parser that implements the documentation below...
use Getopt::Euclid;
# Report intended behaviour...
if ( $ARGV{-v} ) {
  print "Loading first $ARGV{-l} chunks of file: $ARGV{-i}\n";
}
# etc.
_ _END_ _ = head1 NAME orchestrate - Convert a file to Melkor's . orc format
=head1 VERSION
This documentation refers to orchestrate version 1.9.4
=head1 USAGE
orchestrate -in source.txt -out dest.orc [options]
=head1 OPTIONS
=over
=item -i[n] [=] <file>
Specify input file
=for Euclid:
file.type: readable
file.default: '-'
=item -o[ut] [=] <file>
Specify output file
=for Euclid:
file.type: writable
file.default: '-'
=item -l[en] [=] <l>
Display length (default is 24 lines)
=for Euclid:
l.type: integer > 0
l.default: 24
=item -w[id] [=] <w>
Display width (default is 78 columns)
=for Euclid:
w.type: integer > 0
w.default: 78
=item –v
=item --verbose
Print all warnings
=item --version
=item --usage
=item --help
=item --man
Print the usual program information
=back
=begin remainder of documentation here...
