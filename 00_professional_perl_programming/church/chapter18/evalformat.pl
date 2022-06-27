#!/usr/bin/perl
# evalformat.pl
use warnings;
use strict;
# list of values for field
my @values = qw(first second third fourth fifth sixth penultimate ultimate);
# determine maximum width of field
my $width = 0;
foreach (@values) {
  my $newwidth = length $_;
  $width = $newwidth if $newwidth > $width;
}
# create a format string with calculated width using '$_'
my $definition = "This is the \@" . ( '<' x ( $width - 1 ) ) . " line\n" . '$_' . "\n.\n";
# define the format through interpolation
eval "format STDOUT = \n$definition";
# print out the field values using the defined format
write foreach @values;
