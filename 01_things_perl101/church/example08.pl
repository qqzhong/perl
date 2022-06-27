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

sub example {
  my $str1 = "Diggle|Shelley";
  if ( $str1 =~ /Diggle|Shelley/ ) {
    print "We found Diggle or Shelley!\n";
  }

  my $str2 = "this,that,this,that,this,that,this,that,";
  if ( my $n = ( $str2 =~ s/this/that/g ) ) {
    print qq{Replaced $n occurrence(s) of "this"\n};
  }

  # BAD: Not checked, but at least it "works".
  my $str3 = 'Perl 101 rocks.';
  $str3 =~ /(\d+)/;
  print "Number: $1\n";    # Prints "Number: 101";

  # WORSE: Not checked, and the result is not what you'd expect
  my $str4 = "Python|Ruby";
  $str4 =~ /(Python|Ruby)/;
  print "Language: $1\n";    # Prints "Language: 101";

  # GOOD: Check the results
  my $str5 = 'Perl 101 rocks.';
  if ( $str5 =~ /(\d+)/ ) {
    print "Number: $1\n";    # Prints "Number: 101";
  }

  my $str6 = "Python|Ruby";
  if ( $str6 =~ /(Python|Ruby)/ ) {
    print "Language: $1\n";    # Never gets here
  }

  # /i: ignore case
  # /g: many times
  my $var = "match match match";
  my $a   = 0;
  while ( $var =~ /match/g ) { $a++; }
  print "$a\n";    # prints 3

  $a = 0;
  $a++ foreach ( $var =~ /match/g );
  print "$a\n";    # prints 3

  # ^ is head of line and $ is tail of line if use "/m";
  my $str7 = "one\ntwo\nthree";
  my @a    = $str7 =~ /^\w+/g;     # @a = ("one");
  my @b    = $str7 =~ /^\w+/gm;    # @b = ("one","two","three")
  output(@a);
  output(@b);

  my $str8 = "one\ntwo\nthree\n";
  $str8 =~ /^(.{8})/s;
  print $1;                        # prints "one\ntwo\n"

  my $str9 = "abc";
  $str9 =~ /(((a)(b))(c))/;
  print "1: $1 2: $2 3: $3 4: $4 5: $5\n";

  #do not capture if use ?;
  my $str10 = "abc";
  $str10 =~ /(?:a(b)c)/;
  print "$1\n";                    # prints "b"

  # add comments if use /x;
  my ($numx) = $ARGV[0] =~ m/^ \+?        # An optional plus sign, to be discarded
                (              # Capture...
                (?:(?<!\+)-)?  # a negative sign, if there's no plus behind it,
                (?:\d*.)?      # an optional number, followed by a point if a decimal,
                \d+            # then any number of numbers.
                )$/x if ( 0 < @ARGV );
  print "numx = $numx\n" if ( 0 < @ARGV && defined $numx );

  my $num = '3.1415';
  print "ok 1\n" if $num =~ /\Q3.14\E/;
  $num = '3X1415';
  print "ok 2\n" if $num =~ /\Q3.14\E/;
  print "ok 3\n" if $num =~ /3.14/;

  my $str11 = "AbCdE\n";
  $str11 =~ s/(\w)/lc $1/eg;
  print $str11;    # prints "abcde"

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
# chapter08:regexes
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example08.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
