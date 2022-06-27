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
  ### Enforce a single consistent command-line structure. ###
  ### Adhere to a standard set of conventions in your command-line syntax. ###
  ### Standardize your meta-options. ###
  ### Allow the same filename to be specified for both input and output. ###
  ### Standardize on a single approach to command-line processing ###
  ### Ensure that your interface, run-time messages,and documentation remain consistent. ###
  ### Factor out common command-line interface components into a shared module. ###
}

# Command-Line Structure, Enforce a single consistent command-line structure.
# Command-Line Conventions, Adhere to a standard set of conventions in your command-line syntax.
# Meta-options, Standardize your meta-options.
# In-situ Arguments, Allow the same filename to be specified for both input and output.

sub design {
  my ( $source_file, $destination_file ) = ( 'in.txt', 'out.txt' );
  # Open both filehandles...
  use Fatal qw( open );
  open my $src, '<', $source_file;
  unlink $destination_file;
  open my $dest, '>', $destination_file;
  # Read, process, and output data, line-by-line...
  while ( my $line = <$src> ) {
    print {$dest} transform($line);
  }
}

sub insitu {
  my ( $source_file, $destination_file ) = ( 'in.txt', 'out.txt' );
  # Open both filehandles...
  # use IO::InSitu;
  my ( $src, $dest ) = open_rw( $source_file, $destination_file );
  # Read, process, and output data, line-by-line...
  while ( my $line = <$src> ) {
    print {$dest} transform($line);
  }
}
# Command-Line Processing, Standardize on a single approach to command-line processing
# Interface Consistency, Ensure that your interface, run-time messages,and documentation remain consistent.
# Interapplication Consistency, Factor out common command-line interface components into a shared module.

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
# chapter14:Chapter 14, Command-Line Processing
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example14.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
