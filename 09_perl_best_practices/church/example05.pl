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
  ### Avoid using non-lexical variables. ###
  ### Don't use package variables in your own development. ###
  ### If you're forced to modify a package variable, localize it. ###
  ### Initialize any variable you localize. ###
  ### use English for the less familiar punctuation variables. ###
  ### If you're forced to modify a punctuation variable, localize it. ###
  ### Don't use the regex match variables. ###
  ### Beware of any modification via $_. ###
  ### Use negative indices when counting from the end of an array. ###
  ### Take advantage of hash and array slicing. ###
  ### Use a tabular layout for slices. ###
  ### Factor large key or index lists out of their slices. ###

  #  use YAML;
  #  print("YAML::Indent = $YAML::Indent\n");
  #  local $YAML::Indent = 4;    # Indent is 4 until control exits current scope
  #  print("YAML::Indent = $YAML::Indent\n");

  #  obvious. Take another look at the localization of the five variables:
  #  local $OUTPUT_AUTOFLUSH = 1;
  #  local $SUBSCRIPT_SEPARATOR = qq{\0};
  #  local $LIST_SEPARATOR = q{, };
  #  local $OUTPUT_FIELD_SEPARATOR = q{, };
  #  local $OUTPUT_RECORD_SEPARATOR = qq{\n};
  #  and compare it with the non-English version:
  #  local $| = 1; # Autoflush output
  #  local $" = qq{\0}; # Hash subscript sep
  #  local $; = q{, }; # List separator
  #  local $, = q{, }; # Output field sep
  #  local $\ = qq{\n}; # Output record sep

  my %active = ( 'top' => 1, 'prev' => 2, 'backup' => 3 );
  my @frames = ('') x 3;
  @frames[ -1, -2, -3 ] = @active{ 'top', 'prev', 'backup' };
  printHash( '%active', \%active );
  printArray( '@frames', @frames );
  @frames[ -3 .. -1 ] = @active{ 'top', 'prev', 'backup' };
  printArray( '@frames', @frames );

  use Readonly;
  Readonly my %CORRESPONDING => (
    # Key of Index of
    # %active... @frames...
    'top'       => -1,
    'prev'      => -2,
    'backup'    => -3,
    'emergency' => -4,
    'spare'     => -5,
    'rainy day' => -6,
    'alternate' => -7,
    'default'   => -8,
  );

  %active = (
    'top'       => 1,
    'prev'      => 2,
    'backup'    => 3,
    'emergency' => 4,
    'spare'     => 5,
    'rainy day' => 6,
    'alternate' => 7,
    'default'   => 8,
  );
  @frames = ('') x scalar(%active);
  @frames[ values %CORRESPONDING ] = @active{ keys %CORRESPONDING };
  printArray( '@frames', @frames );
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
# chapter05:Chapter 5, Variables
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example05.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
