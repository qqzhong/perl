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

sub ro {
  # Create a reference with the \ operator
  # my $sref = \$scalar;
  # my $aref = \@array;
  # my $href = \%hash;
  # my $cref = \&subroutine;

  # Dereference a reference;
  # my $other_scalar = ${$sref};
  # my @other_array  = @{$aref};
  # my %other_hash   = %{$href};
  # &{$cref} # Call the referent.

  # my $stooge = $aref->[1];
  # my $stooge = $href->{Curly};

  # References to anonymous subroutines;
  my $casefix = sub { return ucfirst lc $_[0] };
  my $color   = $casefix->("rED");
  print "Color: $color\n";    # prints Red
}

sub example {
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
# chapter18:references
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example18.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
