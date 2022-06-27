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
  ### Make object orientation a choice, not a default. ###
  ### Choose object orientation using appropriate criteria. ###
  ### Don’t use pseudohashes. ###
  ### Don’t use restricted hashes. ###
  ### Always use fully encapsulated objects. ###
  ### Give every constructor the same standard name. ###
  ### Don’t let a constructor clone objects. ###
  ### Always provide a destructor for every inside-out class. ###
  ### When creating methods, follow the general guidelines for subroutines. ###
  ### Provide separate read and write accessors. ###
  ### Don’t use lvalue accessors. ###
  ### Don’t use the indirect object syntax. ###
  ### Provide an optimal interface, rather than a minimal one. ###
  ### Overload only the isomorphic operators of algebraic classes. ###
  ### Always consider overloading the boolean, numeric, and string coercions of objects. ###
}

# Using OO, Make object orientation a choice, not a default.
# Criteria, Choose object orientation using appropriate criteria.
# Pseudohashes, Don’t use pseudohashes.
# Restricted Hashes, Don’t use restricted hashes.
# Encapsulation, Always use fully encapsulated objects.
# Constructors, Give every constructor the same standard name.
# Cloning, Don’t let a constructor clone objects.
# Destructors, Always provide a destructor for every inside-out class.
# Methods, When creating methods, follow the general guidelines for subroutines.
# Accessors, Provide separate read and write accessors.
# Lvalue Accessors, Don’t use lvalue accessors.
# Indirect Objects, Don’t use the indirect object syntax.
# Class Interfaces, Provide an optimal interface, rather than a minimal one.
# Operator Overloading, Overload only the isomorphic operators of algebraic classes.
# Coercions, Always consider overloading the boolean, numeric, and string coercions of objects.

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
# chapter15:Chapter 15, Objects
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example15.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
