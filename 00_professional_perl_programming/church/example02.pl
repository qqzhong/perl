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
### Values and Variables ###
  # three basic data types: scalars, arrays, and hashes.
  my %hash = ( Mouse => 'Jerry', Cat => 'Tom', Dog => 'Spike' );
  printHash( 'hash', \%hash );

### Special Variables ###
  foreach (@INC) { print $_, "\n" }
  # /etc/perl
  # /usr/local/lib/x86_64-linux-gnu/perl/5.30.0
  # /usr/local/share/perl/5.30.0
  # /usr/lib/x86_64-linux-gnu/perl5/5.30
  # /usr/share/perl5
  # /usr/lib/x86_64-linux-gnu/perl/5.30
  # /usr/share/perl/5.30
  # /usr/local/lib/site_perl
  # /usr/lib/x86_64-linux-gnu/perl-base

  print $ENV{PATH};

  interpolate1_pl();
  interpolate2_pl();

### Context ###
### Scalar and List Context ###
  my $variable = ( 'a', 'list', 'of', 'strings' );
  print("\n $variable \n");    # returns 'strings'

  my $variableRef = [ 'a', 'list', 'of', 'strings' ];
  printArray( '$variableRef', @{$variableRef} );

  my %permissions = ( read => 4, write => 2, execute => 1 );
  printHash( '%permissions', \%permissions );
  # novalue_pl();

### Void Context ###
  void_pl();
### Blocks ###
  block_pl();
### Control Constructs ###
  if1_pl();
  ifelse_pl();
  foreach1_pl();
  foreach2_pl();
  last_pl();

### Subroutines ###
  # call the subroutine with $input as its argument
  print( "factorial_pl(5)=", factorial_pl(5), "\n" );

### Functions ###
### Scoping ###
  scope1_pl();
  scope2_pl();

}

sub interpolate1_pl {
  # interpolate1.pl
  use warnings;
  my $Friday = "sunny";
  print "It is $Friday \n";
}

sub interpolate2_pl {
  # interpolate2.pl
  use warnings;
  my $Friday = "sunny";
  print "It is \$Friday \n";
}

### Scalar and List Context ###
sub novalue_pl {
  # novalue.pl
  use warnings;
  my %hash = "One value";
  print "$hash{'One value'}\n";
}

### Void Context ###
sub void_pl {
  # void.pl
  use warnings;
  "Out of Context Problem";    #oops, forgot the 'print'
}

### Blocks ###
sub block_pl {
  # block.pl
  use warnings;
  {
    print "This is a first level block. \n";
    {
      print " This is a second level block. \n";
    }
  }
}

### Control Constructs ###
sub if1_pl {
  # if1.pl
  use warnings;
  my $input = <>;
  if ( $input >= 5 ) {
    print "The input number is equal to or greater than 5 \n";
  }
}

sub ifelse_pl {
  # ifelse.pl
  use warnings;
  my $input = <>;
  if ( $input >= 5 ) {
    print "The input number is equal to or greater than 5 \n";
  } else {
    print "The input number is less than 5 \n";
  }
}

sub foreach1_pl {
  # foreach1.pl
  use warnings;
  my @array = ( "one", "two", "three", "four" );
  foreach my $iterator (@array) {
    print "The value of the iterator is now $iterator \n";
  }
}

sub foreach2_pl {
  # foreach2.pl
  use warnings;
  my @array = ( "one", "two", "three", "four" );
  foreach (@array) {
    print "The value of the iterator is now $_ \n";
  }
}

### Loop Modifiers ###
sub next_pl {
  # next.pl
  use warnings;
  my @array = ( "one", "two", "three", "four" );
  foreach my $iterator (@array) {
    if ( $iterator eq "three" ) {
      next;
    }
    print "The value of the iterator is now $iterator \n";
  }
}

sub last_pl {
  # last.pl
  use warnings;
  my @array = ( "one", "two", "three", "four" );
  foreach my $iterator (@array) {
    if ( $iterator eq "three" ) {
      last;
    }
    print "The value of the iterator is now $iterator \n";
  }
}

### Subroutines ###
sub my_sub {
  print "Hi \n";
}

# The subroutine
sub factorial_pl {
  # # factorial.pl
  my $input  = shift;
  my $step   = 1;
  my $result = 1;
  while ( $step <= $input ) {
    $result = $result * $step;
    $step++;    # this is equivalent to '$step = $step + 1';
  }
  # if $input is zero then $result is also zero
  if ( $input == 0 ) {
    $result = 0;
  }
  return $result;
}

### Functions ###
### Scoping ###
sub scope1_pl {
  # scope1.pl
  use warnings;
  my $scalar        = "global";
  my $Second_Global = "Another Global";
  print "Outside the block, \$scalar is a $scalar variable \n";
  {
    my $scalar       = "lexical";
    my $other_scalar = "I am also lexical";
    print "Inside the block, \$scalar\ is a $scalar variable \n";
  }
  print "Outside the block, \$scalar is that same $scalar variable \n";
  print "\$Second_Global is $Second_Global \n";
}

sub scope2_pl {
  # scope1.pl
  use warnings;
  use strict;
  our $scalar = "global";
  my $Second_Global = "Another Global";
  print "Outside the block, \$scalar is a $scalar variable \n";
  {
    my $scalar       = "lexical";
    my $other_scalar = "I am also lexical";
    print "Inside the block, \$scalar\ is a $scalar variable \n";
  }
  print "Outside the block, \$scalar is that same $scalar variable \n";
  print "Outside the block, \$Second_Global is $Second_Global \n";
}

sub example {
  # ro();
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
# chapter02:Chapter 2 Basic Concepts
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example02.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
