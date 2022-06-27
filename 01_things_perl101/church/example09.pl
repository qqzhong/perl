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

use Scalar::Util qw(looks_like_number);
use feature "switch";

sub example {
  my $false1 = undef;
  print "undef is false\n" if ( !defined $false1 );
  my $false2 = "";
  print "\"\" is false\n" if ( "" eq $false2 );
  my $false3 = 0;
  print "0 is false\n" if ( 0 == $false3 );
  my $false4 = "0";
  print "\"0\" is false\n" if ( "0" eq $false4 );

  # print "FROBNITZ DETECTED!\n" if $is_frobnitz;
  # die "BAILING ON FROBNITZ!\n" unless $deal_with_frobnitz;

  my $i = 0;
  print $i++ . "\n" while $i < 3;

  # three kinds of styles "for" loop;
  my @array = ( 100, 200, 300 );
  print("# Old style C for loops\n");
  # Old style C for loops
  for ( my $i = 0 ; $i < 3 ; $i++ ) {
    $array[$i] = $i;
    print("${i}\n");
  }
  print("# Iterating loops\n");
  # Iterating loops
  for my $i (@array) {
    print "$i\n";
  }
  print("# Postfix for loops\n");
  # Postfix for loops
  print "$_\n" for @array;

  # do block;
  my $filename = "dummy.txt";
  # open( my $file1, '<', $filename ) or die "Can't open $filename: $!";
  # Can't open dummy.txt: No such file or directory
  open( my $file2, '<', $filename ) or do {
    # close_open_data_source();
    # die "Aborting: Can't open $filename: $!\n";
  };
  # Aborting: Can't open dummy.txt: No such file or directory

  my $condition = 1;
  if ($condition) { print("action();") }
  do { print("action();") } if $condition;

  # given and when;
  my $var = "abc,def,xyz";
  my ( $abc, $def, $xyz, $nothing ) = ();
  given ($var) {
    when (/^abc/) { $abc     = 1 }
    when (/^def/) { $def     = 1 }
    when (/^xyz/) { $xyz     = 1 }
    default       { $nothing = 1 }
  }

  # next/last/continue/redo;

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
# chapter09:flow-control
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example09.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
