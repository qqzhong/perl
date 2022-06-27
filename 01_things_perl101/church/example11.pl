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

sub output {
  print "[";
  foreach my $e (@_) { print "$e,"; }
  print "]\n";
}

sub outputHash {
  my $hRef = shift;
  print "{";
  foreach my $k ( keys %{$hRef} ) { print "$k => ${$hRef}{$k},"; }
  print "}\n";
}

sub volume1 {
  my $height = shift;
  my $width  = shift;
  my $depth  = shift;

  return $height * $width * $depth;
}

sub volume2 {
  my ( $height, $width, $depth ) = @_;

  return $height * $width * $depth;
}

sub volume3 {
  return $_[0] * $_[1] * $_[2];
}

sub incr1 {
  return $_[0] + 1;
}

sub incr2 {
  return ++$_[0];
}

use Params::Validate;
# perl -MCPAN -e shell
# install Params::Validate

sub square($) {
  return $_[0] * $_[0];
}

sub area($$) {
  return $_[0] * $_[1];
}

sub lunch1 {
  my ( @stooges, @sandwiches ) = @_;
  output(@stooges);
  output(@sandwiches);
}

sub lunch2 {
  my $stoogeRef   = shift;
  my $sandwichRef = shift;

  my @stooges    = @{$stoogeRef};
  my @sandwiches = @{$sandwichRef};
  output(@stooges);
  output(@sandwiches);
}

sub example {
  print( "# volume = ", volume1( 1, 2, 3 ), "\n" );
  print( "# volume = ", volume2( 1, 2, 3 ), "\n" );
  print( "# volume = ", volume3( 1, 2, 3 ), "\n" );

  my $foo = 3;
  print incr1($foo) . "\n";    # prints 4
  print "$foo\n";              # prints 3
  $foo = 3;
  print incr2($foo) . "\n";    # prints 4
  print "$foo\n";              # prints 3

  # print( "square(3) = ", square( 1, 2, 3 ), "\n" );    # run-time error
  print( "square(3) = ", square(3), "\n" );
  # print( "area(1,2) = ", area( 1, 2, 3 ), "\n" );      # run-time error
  print( "area(1,2) = ", area( 1, 2 ), "\n" );

  # use WWW::Mechanize;
  # equals
  # BEGIN {
  #     require WWW::Mechanize;
  #     import WWW::Mechanize;
  # }

  my @stooges    = qw( Moe Larry Curly );
  my @sandwiches = qw( tuna ham-n-cheese PBJ );
  lunch1( @stooges, @sandwiches );
  lunch2( \@stooges, \@sandwiches );

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
# chapter11:subroutines
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example11.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
