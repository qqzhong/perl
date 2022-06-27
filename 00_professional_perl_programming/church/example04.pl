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
### Operators Versus Functions ###
  my $filename = 'dummy.txt';
  print -e ( ${filename} );    # file test '-e', functional style
  print -e ${filename};        # file test '-e', operator style

### Operator Types and Categories ###
  my @array = ( 1, 2, 3, 4, 5 );
  @array[ 1 .. 3 ] = ( 7, 8, 9 );
  print "@array\n";            # produces 1 7 8 9 5

  my $result = 2 * 2 + 3 * 3;  # produces 2*2 plus 3*3 = 4 + 9 = 13
  print("$result\n");
  $result = ( 2 * 2 ) + ( 3 * 3 );    # the same thing, explicitly
  print("$result\n");

  print("Hello"), " World";           # prints "Hello", returns " World"
  print +("Hello"), " World";         # prints "Hello World";

  ### String and List ###
  print "abc" x 3;                    # produces 'abcabcabc'
  my $width   = 43;                                             # the padding width in characters
  my $padding = "\t" x ( $width / 8 ) . " " x ( $width % 8 );
  print $padding, "\n";
  @array = ( 1, 2, 3 ) x 3;                                     # @array contains (1, 2, 3, 1, 2, 3, 1, 2, 3)
  printArray( 'array', @array );

  my @array1 = ( 1, 2, 3 );
  my @array2 = @array1 x 3;                                     # @array2 contains (3, 3, 3)
  printArray( 'array2', @array2 );

  # However, if the array is enclosed in parentheses, we get the desired result:
  @array2 = (@array1) x 3;                                      # @array2 contains (1, 2, 3, 1, 2, 3, 1, 2, 3)
  printArray( 'array2', @array2 );

  print "string" x ( 1, 2, 3 ), "\n";                           # produces "stringstringstring"

  print 3 x 3, "\n";                                            # produces 333
  print 3 * 3, "\n";                                            # produces 9

  bitwise_pl();

  ### Combination Assignment ###
  my $variable = 10;
  $variable += 2, print("$variable\n");                         # prints '12'
  $variable -= 2, print("$variable\n");                         # prints '8'
  $variable *= 2, print("$variable\n");                         # prints '20'
  $variable /= 2, print("$variable\n");                         # prints '5'
  $variable**= 2, print("$variable\n");                         # prints '100'
  $variable %= 2, print("$variable\n");                         # prints '0'

  my $First           = "One ";
  my $First_Addition  = "Two ";
  my $Second_Addition = "Three";
  my $string          = $First;
  print "The string is now: $string \n";
  $string .= $First_Addition;
  print "The string is now: $string \n";
  $string .= $Second_Addition;
  print "The string is now: $string \n";

### Increment and Decrement ###
  my $number = 6;
  print ++$number, "\n";    # preincrement variable, $number becomes 7, produces 7
  print $number++, "\n";    # postincrement variable, $number becomes 7, produces 6
  print --$number, "\n";    # predecrement variable, $number becomes 5, produces 5
  print $number--, "\n";    # postdecrement variable, $number becomes 5, produces 6

  $number = 6.3;
  print ++$number, "\n";    # preincrement variable, $number becomes 7.3, produces 7.3
  print $number++, "\n";    # postincrement variable, $number becomes 8.3, produces 7.3
  $number = 2.8e33;
  print ++$number, "\n";    # no effect, $number remains 2.8e33

  my $antenna_unit = "AE35";
  print ++$antenna_unit, "\n";    # produces 'AE36'
                                  # turn a benefit in a language into a hairstyle
  my $language = "Perk";
  print ++$language, "\n";        # produces 'Perl'
  print ++$language, "\n";        # produces 'Perm'
                                  # make a dated TV series (a bit) more current
  my $serial = "Space1999";
  print ++$serial, "\n";          # produce 'Space2000'

### Comparison ###
  #  Numeric String Operation
  #  != ne Return True if operands are not equal
  #  > gt Return True if left operand is greater than right
  #  == eq Return True if operands are equal
  #  >= ge Return True if left operand is greater or equal to right
  #  < le Return True if left operand is less than right
  #  <= lt Return True if left operand is less than or equal to right
  #  <=> cmp Return -1 if left operand is less than right, 0 if they are equal, and +1
  #  if left operand is greater than right

  #  foreach ($a <=> $b) {
  #  $_ == -1 and do {print "Less"; last;};
  #  $_ == +1 and do {print "More"; last;};
  #  print "Equal";
  #  }

  ### Regular Expression Binding ###
  # look for 'pattern' in $match text
  my $match_text = 'this is pattern';
  print "Found\n" if $match_text =~ /pattern/;
  # perform substitution
  print "Found and Replaced:$match_text\n" if $match_text =~ s/pattern/logrus/;
  $match_text = 'this is not';
  # look for 'pattern' in $match text, print message if absent
  print "Not found" if $match_text !~ /pattern/;

### Comma and Relationship ###
### Reference and Dereference ###
### The Arrow ###

  # look up a hash key
  # $value = $hashref -> {$key};
  # take a slice of an array
  # @slice = $arrayref -> [7..11];
  # get first element of subroutine returning array reference:
  # $result = sub_that_returns_an_arrayref() -> [0];

  # $element = $pixel3d [$x] [$y] [$z];
  # Is actually shorthand for:
  # $element = $pixel3d [$x] -> [$y] -> [$z];

### Range ###
  foreach ( 1 .. 10 ) {
    print "$_\n";    # print 1 to 10
  }
  print "A" .. "E", "\n";    # returns ABCDE
  print reverse( "A" .. "E" ), "\n";    # returns EDCBA

### Ternary ###
### Precedence and Associativity ###
### Precedence and Parentheses ###

  my $name1 = "myfile";
  my $name2 = ".txt";
  if ( -f $name1 . $name2 ) {
    print "The concatenation occurred before -f acted.";
  }

  my $quitting = 0;
  print "Bye! \n", exit if $quitting;
  # turn 'print' into a function, making the arguments explicit
  print("Bye! \n"), exit if $quitting;
  # make the 'print' statement a term in its own right
  ( print "Bye! \n" ), exit if $quitting;

  my ( $value1, $value2 ) = ( 1, 2 );
  # displays sum, returns string
  print( $value1 + $value2, "\n" ), " is the sum of $value1 and $value2 \n";    #bad
  ### add parentheses
  print( ( $value1 + $value2 ), " is the sum of $value1 and $value2 \n" );      #good
  ### disambiguate by adding zero
  print 0 + ( $value1 + $value2 ), " is the sum of $value1 and $value2\n";      #good
  ### disambiguate with unary plus
  print +( $value1 + $value2 ), " is the sum of $value1 and $value2 \n";        #good
  print "The sum of $value1 and $value2 is ", ( $value1 + $value2 );            #good
}

### bitwise operators, or bitwise logical operators ###
sub bitwise {
  # bitwise.pl
  use warnings;
  use strict;
  my $a = 3;
  my $b = 6;
  my $r;
  printf "$a = %03b \n", $a;
  printf "$b = %03b \n", $b;
  $r = $a & $b;
  printf "$a & $b = %03b = %d\n", $r, $r;
  $r = $a | $b;
  printf "$a | $b = %03b = %d\n", $r, $r;
  $r = $a ^ $b;
  printf "$a ^ $b = %03b = %d\n", $r, $r;
  $r = ~$a;
  printf "~$a = %03b = %d\n", $r, $r;

  use POSIX;
  my $mode = POSIX::O_RDWR | POSIX::O_CREAT | POSIX::O_TRUNC;
  print("mode = $mode\n");

  # constrain an inverted bitmask to 16 bits
  # $inverted = ~$mask & (2 ** 16 - 1);

### bitwise string operators ###
  print 'A' | ' ', "\n";    # produces 'a'
  print 'upper' & '_____', "\n";    # produces 'UPPER'
  print 123 | 456,     "\n";        # produces '507'
  print '123' | '456', "\n";        # produces '577'

  # The digit 0 happens to have none of the bits that the other numbers use set,
  # so ORing any digit with 0 produces that digit:
  print '2000' | '0030', "\n";    # produces '2030'
                                  # Note that padding is important here:
  print '2000' | '30',   "\n";    # produces '3000'

  # translate every odd character to lower case
  my $text = 'AbCd';
  $text |= " \0" x ( length($text) / 2 + 1 );
  print("$text\n");
  $text = 'AbCd';
  # translate every even character to upper case
  $text &= "\377_" x ( length($text) / 2 + 1 );
  print("$text\n");
}

sub range_pl {
  # range.pl
  use warnings;
  use strict;
  my $start = 2;
  my $end   = 4;
  while (<>) {
    ( $. == $start ) .. ( $. == $end ) and print "$.: $_";
  }
}

sub http_pl {
  my $header = "";
  my $body   = "";
  while (<>) {
    1 .. /^$/ and $header .= $_;
    /^$/ .. eof() and $body .= $_;
    exit if eof;    # ensure we only pass through one file
  }
}

sub ro1 {
  ### Disabling Functions and Operators ###
  # to disable the system function we can use:;
  # perl -M-ops=system myprogram.pl

  BEGIN {
    no ops qw(system backtick exec fork);
  }

  # perl -M-ops=:default myprogram.pl

  # to disable the open, sysopen, and close functions (as well as binmode and umask)
  # we can switch off the :filesys_open tag:
  # perl -M-ops=:filesys_open myprogram.pl

  # disable the system, backtick, exec, and fork keywords with the :subprocess tag:
  # perl -M-ops=:subprocess myprogram.pl
  BEGIN { no ops qw(:subprocess); }

  ### Overriding Operators ###
  # package MyObject;
  # use overload '+' => &myadd, '-' => &mysub;
}

# Assignment
# Arithmetic
# Shift
# String and List
# Logical
# Bitwise
# Increment and Decrement
# Comparison
# Comma and Relationship
# Reference
# Arrow
# Range
# Ternary

sub example {
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
# chapter04:Chapter 4 Operators
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example04.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
