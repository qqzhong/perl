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
  ### Use grammatical templates when forming identifiers. ###
  ### Name booleans after their associated test. ###
  ### Mark variables that store references with a _ref suffix. ###
  ### Name arrays in the plural and hashes in the singular. ###
  ### Use underscores to separate words in multiword identifiers. ###
  ### Distinguish different program components by case. ###
  ### Abbreviate idents by prefx. ###
  ### Abbreviate only when the meaning remains unambiguous. ###
  ### Avoid using inherently ambiguous words in names. ###
  ### Prefix “for internal use only” subroutines with an underscore. ###

  # $term_val # terminal value or termination valid?
  # = $temp # temperature or temporary?
  #   * $dev; # device or deviation?

  # Other commonly used words to avoid include:
  # • “left” (the direction vs what remains)
  # • “right” (the other direction vs being correct vs. an entitlement)
  # • “no” (the negative vs the abbreviation for number)
  # • “abstract” (theoretical vs a précis vs to summarize)
  # • “contract” (make smaller vs a legal agreement)
  # • “record” (an extreme outcome vs a data aggregation vs to log)
  # • “second” (the ordinal position vs the unit of time)
  # • “close” (near vs to shut)
  # • “bases” (more than one base vs more than one basis)
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
# chapter03:Chapter 3, Naming Conventions
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example03.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
