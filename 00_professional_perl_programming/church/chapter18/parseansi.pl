#!/usr/bin/perl
# parseansi.pl
use warnings;
use strict;
use Pod::Text::Color;
my $parser = new Pod::Text::Color(
  width    => 56,
  loose    => 1,
  sentence => 1,
);
if (@ARGV) {
  $parser->parse_from_file( $_, '-' ) foreach @ARGV;
} else {
  $parser->parse_from_filehandle( \*STDIN );
}
