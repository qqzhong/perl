#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;
use utf8;
use Time::HiRes qw( time );
use File::Spec;
my $sep = '/';

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s }
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s }
sub trim  { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s }

sub open_filehandle_for_write {
  my $filename = $_[0];
  local *FH;
  use open ':encoding(UTF-8)';
  open( FH, '>', $filename ) || die "Could not open $filename";
  binmode FH, ":encoding(UTF-8)";
  return *FH;
}

sub open_filehandle_for_read {
  my $filename = $_[0];
  local *FH;
  open( FH, $filename ) || die "Could not open $filename";
  return *FH;
}

sub get_abs_path {
  # best code, get file true path.
  my $path_curf = File::Spec->rel2abs(__FILE__);
  # print ("# file in PATH = $path_curf\n");
  my ( $vol, $dirs, $file ) = File::Spec->splitpath($path_curf);
  # print ("# file in Dir = $dirs\n");
  return $dirs;
}

sub printArray {
  my $name = shift;
  print "${name}:[";
  foreach my $e (@_) {
    print "$e,"    if defined $e;
    print "undef," if !defined $e;
  }
  print "]\n";
}

sub printHash {
  my $name = shift;
  my $hRef = shift;
  print "${name}:{";
  foreach my $k ( keys %{$hRef} ) { print "$k => ${$hRef}{$k},"; }
  print "}\n";
}

sub ro {
  ### Use interpolating string delimiters only for strings that actually interpolate. ###
  ### Don't use "" or '' for an empty string. ###
  ### Don't write one-character strings in visually ambiguous ways. ###
  ### Use named character escapes instead of numeric escapes. ###
  ### Use named constants, but don't use constant. ###
  ### Don't pad decimal numbers with leading zeros. ###
  ### Use underscores to improve the readability of long numbers. ###
  ### Lay out multiline strings over multiple lines. ###
  ### Use a heredoc when a multiline string exceeds two lines. ###
  ### Use a "theredoc" when a heredoc would compromise your indentation. ###
  ### Make every heredoc terminator a single uppercase identifier with a standard prefix. ###
  ### When introducing a heredoc, quote the terminator. ###
  ### Don't use barewords. ###
  ### Reserve => for pairs. ###
  ### Don't use commas to sequence statements. ###
  ### Don't mix high- and low-precedence booleans. ###
  ### Parenthesize every raw list. ###
  ### Use table-lookup to test for membership in lists of strings; use any( ) for membership of lists of anything else. ###

  my $title         = q[Perl Best Practices];
  my $publisher     = q[O'Reilly];               #'
  my $end_of_block  = q[}];
  my $closing_delim = q['}];                     #'
  my $citation      = qq[$title ($publisher)];

  # $error_msg = q{}; # Empty string
  # $separator = q{ }; # Single space

  use constant SPEED_OF_LIGHT => 299_792_458;
  # SPEED_OF_LIGHT = 0;
  print( "SPEED_OF_LIGHT = " . SPEED_OF_LIGHT . "\n" );

  use Readonly;
  Readonly my $absolute_zero => -273.15;
  # $absolute_zero = 0; # Modification of a read-only value attempted at.
  print("absolute_zero = ${absolute_zero}\n");

  Readonly my $minimal => 4.99;
  Readonly my $GRIPE1  => <<'END_GRIPE1';
$minimal for maximal work
END_GRIPE1
  print $GRIPE1;    # Prints: $minimal for maximal work

  Readonly my $GRIPE2 => <<"END_GRIPE2";
$minimal for maximal work
END_GRIPE2
  print $GRIPE2;    # Prints: 4.99 an hour for maximal work

  use List::Util qw(any);
  if ( any { $_ ge 200 }[ 100, 200, 300 ] ) {
    print("there's a value greater than 200\n");
  }
}

sub example {
  ro();
  my @array = ( 1, 2, 3 );
  printArray( 'array', @array );
  my %hash = ( one => 1, two => 2, three => 3 );
  printHash( 'hash', \%hash );
  sleep 0.6;
}

# -------------------------------- main --------------------------------
sub main() {
  # my $startTime = Time::HiRes::gettimeofday();
  # my $beginT    = time();
  example();
  my $elapsed_time = time() - $^T;
  # $^T just like $start_time=time() put it very beginning of perl script.
  print "\n# run time is: $elapsed_time second(s) \n";

  # my $endT = time();
  # printf( "%.4f\n", $endT - $beginT );
  # my $stopTime = Time::HiRes::gettimeofday();
  # printf( "%.4f\n", $stopTime - $startTime );
}
# -------------------------------- exit --------------------------------
main();
exit 0;
# sudo apt install -y perltidy
# http://perltidy.sourceforge.net/tutorial.html
# chapter04:Chapter 4, Values and Expressions
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example04.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
