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
  ### Use block if, not postfix if. ###
  ### Reserve postfix if for flow-of-control statements. ###
  ### Don't use postfix unless, for, while, or until. ###
  ### Don't use unless or until at all. ###
  ### Don't Fail Not to Use Chained Negatives ###
  ### Avoid C-style for statements. ###
  ### Avoid subscripting arrays or hashes within loops. ###
  ### Never subscript more than once in a loop. ###
  ### Use named lexicals as explicit for loop iterators. ###
  ### Always declare a for loop iterator variable with my. ###
  ### Use map instead of for when generating new lists from old. ###
  ### Use grep and first instead of for when searching for values in a list. ###
  ### Use for instead of map when transforming a list in place. ###
  ### Use a subroutine call to factor out complex list transformations. ###
  ### Never modify $_ in a list function. ###
  ### Avoid cascading an if. ###
  ### Use table look-up in preference to cascaded equality tests. ###
  ### When producing a value, use tabular ternaries. ###
  ### Dont use do...while loops. ###
  ### Reject as many iterations as possible, as early as possible. ###
  ### Dont contort loop structures just to consolidate control. ###
  ### Use for and redo instead of an irregularly counted while. ###
  ### Label every loop that is exited explicitly, and use the label with every next, last, or redo. ###

  # Specifically, you cant use the next, last, or redo commands within a do...while.

  my @result = ( 1 .. 20 );
RESULT:
  for my $n ( 4 .. 11 ) {
    next RESULT if ( 0 ne $n % 2 );
    print $result[$n], "\n";
  }

  #  Celsius to Kelvin: K = C + 273.15
  #  Kelvin to Celcius: C = K - 273.15
  #  Fahrenheit to Celcius: C = (F-32) (5/9)
  #  Celsius to Fahrenheit: F = C(9/5) + 32
  #  Fahrenheit to Kelvin: K = (F-32) (5/9) + 273.15
  #  Kelvin to Fahrenheit: F = (K-273.15) (9/5) + 32
  sub C_to_F { my $t = shift; return $t * 9 / 5 + 32; }
  sub F_to_K { my $t = shift; return 5 * ( $t - 32 ) / 9 + 273.15; }
  my @temperature_measurements = ( 0, 35, 75, 100 );
  printArray( 'Celsius', @temperature_measurements );
  @temperature_measurements = map { C_to_F($_) } @temperature_measurements;
  printArray( 'Fahrenheit', @temperature_measurements );
  @temperature_measurements = map { F_to_K($_) } @temperature_measurements;
  printArray( 'Kelvin', @temperature_measurements );

  my @names  = ( '', 'Sir Church', 'PhD Church', 'Church.ZHONG' );
  my @salute = map { ternary1($_); } @names;
  printArray( '@salute', @salute );
  @salute = map { ternary1($_); } @names;
  printArray( '@salute', @salute );

  print( "big = ", big(), "\n" );
}

use Readonly;
Readonly my $EMPTY_STR => q{};

sub ternary1 {
  my $name = shift;
  my $salute;
  if ( $name eq $EMPTY_STR ) {
    $salute = 'Dear Customer';
  } elsif ( $name =~ m/\A ((?:Sir|Dame) \s+ \S+)/xms ) {
    $salute = "Dear $1";
  } elsif ( $name =~ m/([^\n]*), \s+ Ph[.]?D \z/xms ) {
    $salute = "Dear Dr $1";
  } else {
    $salute = "Dear $name";
  }
  return $salute;
}

sub ternary2 {
  my $name = shift;
  # Name format... # Salutation...
  my $salute =
      $name eq $EMPTY_STR                       ? 'Dear Customer'
    : $name =~ m/ \A((?:Sir|Dame) \s+ \S+) /xms ? "Dear $1"
    : $name =~ m/ (.*), \s+ Ph[.]?D \z /xms     ? "Dear Dr $1"
    :                                             "Dear $name";
  return $salute;
}

sub big {
  Readonly my $MAX_TRIES   => 9;
  Readonly my $MIN_BIG_INT => 295577;
  Readonly my $INTEGER     => qr/\A [+-]? \d+ \n? \z/xms;
  my $int = 0;
INPUT:
  for my $attempt ( 1 .. $MAX_TRIES ) {
    print 'Enter a big integer: ';
    $int = <>;
    last INPUT if not defined $int;
    redo INPUT if $int eq "\n";
    next INPUT if $int !~ $INTEGER;
    chomp $int;
    last INPUT if $int >= $MIN_BIG_INT;
  }
  return $int;
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
# chapter06:Chapter 6, Control Structures
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example06.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
