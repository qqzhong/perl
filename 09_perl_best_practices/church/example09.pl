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

use Carp;    # alternative warn and die for modules
use List::Util qw( any );
use Readonly;
Readonly my $SPACE => q{ };
Readonly my $COMMA => q{,};

#  If you have a procedure with ten parameters,
#  you probably missed some.
#  --Alan Perlis
sub ro {
  ### Call subroutines with parentheses but without a leading &. ###
  ### Don’t give subroutines the same names as built-in functions. ###
  ### Always unpack @_ first. ###
  ### Use a hash of named arguments for any subroutine that has more than three parameters. ###
  ### Use definedness or existence to test for missing arguments. ###
  ### Resolve any default argument values as soon as @_ is unpacked. ###
  ### Always return scalar in scalar returns. ###
  ### Make list-returning subroutines return the “obvious” value in scalar context. ###
  ### When there is no “obvious” scalar context return value, consider Contextual::Return instead. ###
  ### Don’t use subroutine prototypes. ###
  ### Always return via an explicit return. ###
  ### Use a bare return to return failure. ###

# Your code will be easier to read and understand if the subroutines always use parentheses and the built-in functions always don’t:

  my $line = '1234567890';
  print padded1( $line, 20, 1, $SPACE ), "\n";
  print padded2( { text => $line, cols => 20, centered => 1, filler => $SPACE } ), "\n";
  print padded3( $line, { cols => 20, centered => 1, filler => $SPACE } ), "\n";

  use feature qw(say);
  say('Church');
}

sub padded1 {
  my ( $text, $cols_count, $want_centering ) = @_;
  croak q{Can't pad undefined text} if ( !defined $text );
  croak qq{Can't pad to $cols_count columns} if ( $cols_count <= 0 );
  # Compute the left and right indents required...
  my $gap   = $cols_count - length $text;
  my $left  = $want_centering ? int( $gap / 2 ) : 0;
  my $right = $gap - $left;
  # Insert that many spaces fore and aft...
  return $SPACE x $left . $text . $SPACE x $right;
}

# Trim some text and put a "box" around it...
sub boxed {
  my ($text) = @_;
  $text =~ s{\A \s+ | \s+ \z}{}gxms;
  return "[$text]";
}

sub padded2 {
  my ($arg_ref) = @_;
  my $gap       = $arg_ref->{cols} - length $arg_ref->{text};
  my $left      = $arg_ref->{centered} ? int( $gap / 2 ) : 0;
  my $right     = $gap - $left;
  return $arg_ref->{filler} x $left . $arg_ref->{text} . $arg_ref->{filler} x $right;
}

sub padded3 {
  my ( $text, $arg_ref ) = @_;
  my $gap   = $arg_ref->{cols} - length $text;
  my $left  = $arg_ref->{centered} ? int( $gap / 2 ) : 0;
  my $right = $gap - $left;
  return $arg_ref->{filler} x $left . $text . $arg_ref->{filler} x $right;
}

sub filled {
  Readonly my $FILLED_USAGE = "filled usage:[text] [cols] [filter]\n";

  croak $FILLED_USAGE if @_ != 3;    # All three args must be supplied
  my ( $text, $cols, $filler ) = @_;
  croak $FILLED_USAGE
    if any { !defined $_ }[ $text, $cols, $filler ];
  # [etc.]
}

Readonly my %PAD_DEFAULTS => (
  cols     => 78,
  centered => 0,
  filler   => $SPACE,
  # etc.
);

sub padded4 {
  my ( $text, $arg_ref ) = @_;
  # Unpack optional arguments and set defaults...
  my %arg = ref $arg_ref eq 'HASH' ? ( %{$arg_ref} ) : %PAD_DEFAULTS;
  # Compute left and right spacings...
  my $gap   = $arg{cols} - length $text;
  my $left  = $arg{centered} ? int( $gap / 2 ) : 0;
  my $right = $gap - $left;
  # Prepend and append space...
  return $arg{filler} x $left . $text . $arg{filler} x $right;
}

# Always return scalar in scalar returns.
sub how_many_defined {
  return scalar grep { defined $_ } @_;
}

# Make list-returning subroutines return the “obvious” value in scalar context.
sub defined_samples_in1 {
  my @defined_samples = grep { defined $_ } @_;
  # Return all defined args in list context...
  if (wantarray) {
    return @defined_samples;
  }
  # Otherwise a serialized version in scalar context...
  return join( $COMMA, @defined_samples );
}

use List::Util qw( first );

sub defined_samples_in2 {
  # Return all defined args in list context...
  if (wantarray) {
    return grep { defined $_ } @_;
  }
  # Or, in scalar context, extract the first defined arg...
  return first { defined $_ } @_;
}

sub defined_samples_in3 {
  my @defined_samples = grep { defined $_ } @_;
  # Return all defined args in list context...
  if (wantarray) {
    return @defined_samples;
  }
  # Return all defined args (indirectly) in scalar context...
  return \@defined_samples;
}

sub defined_samples_in4 {
  croak q{Useless use of 'defined_samples_in' in a non-list context} if !wantarray;
  return grep { defined $_ } @_;
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
# chapter09:Chapter 9, Subroutines
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example09.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
