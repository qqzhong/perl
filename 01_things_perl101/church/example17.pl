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

# best practices
sub ro {
  my @foo = ( 1, 2, 3 );
  for ( my $i = 0 ; $i <= $#foo ; $i++ ) {    # BAD
    print( $foo[$i], "\n" );
  }

  foreach (@foo) {                            # BETTER
    print( $_, "\n" );
  }

  for ( my $i = <STDIN> ; $i ; $i = <STDIN> ) {    # BAD
    print("${i}\n");
  }

  while ( my $i = <STDIN> ) {                      # BETTER
    print("${i}\n");
  }

  # Creating a reference to a Perl Anonymous array；
  my $array = [ 'one', 'two', 'three' ];
  foreach ( @{$array} ) { print("$_\n"); }

  my $hash = { one => 1, two => 2, three => 3 };
  outputHash($hash);

  # Perl lets you specify your own delimiters for:
  # Single quotes: 'text' => q/text/
  # Double quotes: "text" => qq/text/
  # Regular expressions: qr/text/
  # There is no other way to specify a regular expression match like this in Perl outside of a match or substitution operation.
  # Words: ("text", "text") => qw(text text);
  # Backticks: `text` => qx/text/
  # Regex match (m//), Regex substitute (s///), and translate (tr///, y///) work the same way
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
# chapter17:constructs
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example17.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
