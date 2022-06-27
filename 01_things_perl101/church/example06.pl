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
  # Perl 5
  my @stooges1 = qw( Larry Curly Moe Iggy );
  # or
  my @stooges2 = qw(
    Larry
    Curly
    Moe
    Iggy
  );
  output(@stooges1);
  output(@stooges2);

  # Possible attempt to separate words with commas
  my @bad_array = qw( $100,000 );    # Perl 5
  output(@stooges2);

  print "$stooges1[1]\n";            # Curly
  print "$stooges1[-1]\n";           # Iggy

  my $stooge1_count = scalar @stooges1;    # 4
  print "$stooge1_count\n";
  my $stooge2_count = @stooges2;           # 4
  print "$stooge2_count\n";

  my $moe_length = length $stooges1[ @stooges1 / 2 ];
  # length $stooges[2];
  # length 'Moe';
  # 3;
  print "$moe_length\n";

  my @array100 = ();
  $array100[100] = 'x';    # all others are 'undef';

  my @sandwich       = ( 'PB', 'J' );
  my @other_sandwich = ( 'B',  'L', 'T' );
  my @ingredients = ( @other_sandwich, @sandwich );
  output(@ingredients);

  #shift, unshift, push, pop
  my @letters = 'a' .. 'z';    # 26 letters
  output(@letters);

  # a, e, i, o, u...
  my @vowels = @letters[ 0, 4, 8, 14, 20 ];
  output(@vowels);

  # And sometimes "y"
  push( @vowels, $letters[-2] ) if rand > .5;
  output(@vowels);

  # WRONG: Returns a 1-element list, or 1 in scalar context
  # my $z = @a[-1];

  # RIGHT: Returns a single scalar element
  # my $z = $a[-1];

  # Replace vowels with uppercase versions
  @letters[ 0, 4, 8, 14, 20 ] = qw( A E I O U );
  print "Replace vowels with uppercase versions\n";
  output(@letters);
  # Swap first and last elements
  @letters[ 0, -1 ] = @letters[ -1, 0 ];
  print "Swap first and last elements\n";
  output(@letters);

  # splice
  # my @a = qw(Steve Stu Stan);
  # $a[1] = ['Stewart', 'Zane'];
  # @a  = ('Steve', ARRAY(0x841214c), 'Stan')
  # Memory address to an array reference

  # my @a = qw(Steve Stu Stan);
  # my @b = qw(Stewart Zane);
  # $a[1] = @b;
  # @a  = ('Steve', 2, 'Stan')
  # Returns a scalar reference, the length of @b

  my @a = qw(Steve Stu Stan);
  splice @a, 1, 1, 'Stewart', 'Zane';
  # @a = ('Steve', 'Stewart', 'Zane', 'Stan')
  # This is just what we wanted

  # map : call foreach and return
  my @numbers     = ( 1, 2, 3, 4, 5 );
  my %numbersHash = map { $_ => $_ * 9 } @numbers;
  # %hash   = ( 1 => 9, 2 => 18, 3 => 27, 4 => 36, 5 => 45 )

  my @colors = ( 'ReD', 'bLue', 'GrEEN' );
  # note the nested 'map' functions
  my @fixed_colors = map( ucfirst, map( lc, @colors ) );
  # @fixed_colors  = ( 'Red', 'Blue', 'Green' )
  output(@fixed_colors);

  # use $_ to modify all of source;
  map { $_ = ucfirst lc $_ } @colors;
  # @colors = ( 'Red', 'Blue', 'Green' )
  output(@colors);

  # grep : call foreach and return
  my @x9_numbers = grep { $_ * 9 } @numbers;
  # @x9_numbers  = ( 1, 2, 3, 4, 5 );
  output(@x9_numbers);

  # use $_ to modify all of source;
  @x9_numbers = grep { $_ *= 9 } @numbers;
  # @numbers      = ( 0, 9, 18, 27, 36, 45 );
  # @x9_numbers  = ( 9, 18, 27, 36, 45 );
  output(@numbers);
  output(@x9_numbers);

  my @people = ( 'John Doe', 'Jane Doe', 'Joe Sixpack', 'John Q. Public', );
  my @does   = grep { $_ =~ /\bDoe$/ } @people;
  # my @does = grep { /\bDoe$/ } @people; # short
  # @does  = ('John Doe', 'Jane Doe');
  output(@does);
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
# chapter06:arrays
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example06.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
