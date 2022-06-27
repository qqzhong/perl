#!/usr/bin/perl
# tabconvert.pl
use warnings;
use strict;
use Text::Tabs qw(expand unexpand);
# insist on at least three arguments
die "Usage: $0 <in width> <out width> <file>...\n" if $#ARGV < 2;
# pull in the input and output tab widths
my $width_in = shift @ARGV;
$width_in = 4 unless $width_in;
my $width_out = shift @ARGV;
$width_out = 4 unless $width_out;
# quit if the tab lengths are the same
die "Nothing to do\n" if $width_in eq $width_out;
# die on failure to open @ARGV
$SIG{__WARN__} = sub { die @_ };
my @text = <>;
# convert to tabs using input tab width
$Text::Tabs::tabstop = $width_in;
@text                = unexpand @text;
# print out text converted to output tab width
$Text::Tabs::tabstop = $width_out;
print expand @text;
