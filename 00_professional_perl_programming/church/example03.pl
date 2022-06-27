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
### Value Conversion and Caching ###
  my $number = 3141;
  my $text   = $number . ' is a thousand PIs';
  my $pi     = $number / 1000;
  print("number = $number\n");
  print("text = $text\n");
  print("pi = $pi\n");

  print "2 to the power of 100:1 against and falling: ", 2**100, "\n";

### Converting Integers into Strings ###
  printf '%d/%d/%d', 2000, 7, 4;    # displays "2000/7/4"
  print("\n");
  printf '%d/%2d/%2d', 2000, 7, 4;    # displays "2000/ 7/ 4"
  print("\n");
  printf '%d/%02d/%02d', 2000, 7, 4;    # displays "2000/07/04"
  print("\n");

### Handling Different Number Bases ###
  my $bintext = sprintf '0b%b', 83;     # produces '0b1010011'
  my $octtext = sprintf '0%o',  83;     # produces '0123'
  my $hextext = sprintf '0x%x', 83;     # produces '0x53'
  print("$bintext,$octtext,$hextext\n");
  print( "errata:", sprintf( '0x%bx', 83 ), "\n" );

  my $bin32text = unpack( "B32", pack( "N", $number ) );
  my $bin16text = unpack( "B16", pack( "n", $number ) );
  my $sbin16text = substr( $bin16text, index( $bin16text, '1' ) );
  # 00000000000000000000110001000101,0000110001000101,110001000101
  printf( "%32s\n", $bin32text );
  printf( "%32s\n", $bin16text );
  printf( "%32s\n", $sbin16text );

### Floating-Point Numbers ###
  #  123.45 # fixed point
  #  -1.2345e2 # scientific, lowercase, negative
  #  +1.2345E2 # scientific, uppercase, explicitly positive

  #  0.000034 # fixed point
  #  -3.4e-4 # scientific, lowercase, negative
  #  +3.4E-4 # scientific, uppercase, explicitly positive

### Converting Floats into Integers ###
  $number = 4.05 / 0.05;
  print "$number \n";    # returns 81, correct
  print int($number), "\n";    # returns 80, incorrect!
  if ( $number != 81 ) {
    print "\$number is not equal to 81 \n";
  }

  if ( sprintf( "%d", $number ) eq "81" ) {
    print "\$number is not equal to 81 \n";
  } else {
    print "\$number is equal to 81 \n";
  }

### Converting Floats into Strings ###
  my @floats = (
    4.3e12,    # The answer is 4300000000000
    4.3e-3,    # The answer is 0.0043
    4.3e99,    # The answer is 4.3e99
  );
  foreach my $floatnum (@floats) {
    printf '%e' . "\n", $floatnum;    # force conversion to fixed decimal format
    printf '%f' . "\n", $floatnum;    # force conversion to mantissa/exponent format
    printf '%g' . "\n", $floatnum;    # use fixed if accurately possible, otherwise
  }

  printf '%6.5f' . "\n",   3.14159;    # display a minimum width of 6 with 3
                                       # decimal places; produces ' 3.142'
  printf '% 7.5f' . "\n",  3.14159;    # pad with leading space if positive,
                                       # produces ' 3.142'
  printf '%+7.5f' . "\n",  3.14159;    # prefix a '+' sign if positive,
                                       # produces ' +3.142'
  printf '%07.5f' . "\n",  3.14159;    # prefix with leading zeros,
                                       # produces '003.142'
  printf '% 07.5f' . "\n", 3.14159;    # pad with a leading space, then leading zeros,
                                       # produces ' 03.142'
  printf '%+07.5f' . "\n", 3.14159;    # pad with a leading +, then leading zeros,
                                       # produces '+03.142'

### The 'use integer' Pragma ###
  {
    # 64bit,produces '18446744073709551615 18446744073709551615';
    print ~0, ' ', -1 << 0, "\n";      # 32bit,produces '4294967295 4294967295';
    use integer;
    print ~0, ' ', -1 << 0, "\n";      # produces '-1 -1'
  }

### Mathematical Functions ###
  {
    print abs(-6.3), "\n";             # absolute value, produces 6.3
    print sqrt(6.3), "\n";             # square root, produces 2.50998007960223
    print exp(6.3), "\n";              # raise 'e' to the power of, produces 544.571910125929
    print log(6.3), "\n";              # natural (base 'e') logarithm, produces 1.84054963339749
  }

  {
    my $n    = 2;
    my $base = 10;
    print log($n) / log($base), "\n";    # calculate and print log(10)2
  }
  {
    use POSIX qw(log10);
    my $n    = 2;
    my $base = 10;
    print log10($n), "\n";               # calculate and print log(10)2
  }

  {
    my $n = 0.523598766667;              # pi/6;
    print atan2( $n, sqrt( 1 - $n**2 ) ), "\n";    # asin (inverse sine)
    print atan2( sqrt( 1 - $n**2 ), $n ), "\n";    # acos (inverse cosine)
    print sin($n) / cos($n), "\n";                 # tan
  }

### Strings ###
  ### Quotes and Quoting ###
  {

    #  Quote type         Operator  Result
    #  single quotes      q         literal string
    #  double quotes      qq        interpolated string
    #  n/a                qr        regular expressions string
    #  n/a                qw        list of words
    #  backticks (``)     qx        execute external program
    my $qs1          = 'Literal Text';                               # is equivalent to q(Literal Text)
    my $interpolated = 0;
    my @text         = ( 1, 2, 3 );
    my $qs2          = "$interpolated @text";                        # is equivalent to qq($interpolated @text)
    my $qs3          = `date`;                                       # is equivalent to qx(./external -command)
    my $text         = q/a string with 'quotes' is 'ok' inside q/;
    print "$qs1\n";
    print "$qs2\n";
    print "$qs3\n";
    print "$text\n";

    # the quotey way
    my @array = ( 'a', 'lot', 'of', 'quotes', 'is', 'not', 'very', 'legible' );
    printArray( '@array', @array );
    # much more legible using 'qw'
    @array = qw(a lot of quotes is not very legible);
    printArray( '@array', @array );

    my @oops = qw(a, comma, separated, list, of, words);
    print "[";
    foreach (@oops) { print "\"$_\","; }
    print "]\n";
  };

### 'Here' Documents ###
  {
    my $string = <<_END_OF_TEXT_;
Some text
Split onto multiple lines
Is clearly defined
_END_OF_TEXT_
    print($string);

    # the end token may contain spaces if it is quoted
    print <<"print to here";
This is
some text
print to here
    # this does not interpolate
    print <<'_END_OF_TEXT_'
This %is @not %interpolated
_END_OF_TEXT_
  }

  # a foreach loop on one line
  foreach ( split "\n", <<LINES) { print "Got $_ \n"; }
Line 1
Line 2
Line 3
LINES

  heredoc_pl();

  print format_pl( 'me@myself.net', 'you@yourself.org', "Wishing you were here", "...instead of me!", "Regards, Me" );
  print( return_a_here_document1(), "\n" );
  print( return_a_here_document2(), "\n" );

### Bareword Strings and Version Numbers ###
  # 'require 5.6.0' is another way to do this:
  die "Your Perl $^V is too old! Get a new one! \n" if $^V lt v5.6.0;
  # die "Your Perl $^V is too old! Get a new one! \n" if $^V lt v6.6.6;

  my $version = v5.30.0;    # now it is a version string
  print( "perl is ", $version, "\n" );
}

sub heredoc_pl {
  # heredoc.pl
  use warnings;
  use strict;
  # a foreach loop split across the 'here' document
  foreach ( split "\n", <<LINES) {
Line 1
Line 2
Line 3
LINES
    print "Got: $_ \n";
  }
}

# subroutines will be explained fully in Chapter 7
sub format_pl {
  # formate.pl
  my ( $me, $to_addr, $subject, $body_of_message, $signature ) = @_;
  return <<_EMAIL_;
To: $to_addr
From: $me;
Subject: $subject
$body_of_message
--
$signature
_EMAIL_
}
# works;
sub return_a_here_document1 {
  return <<DOCUMENT;
This document definition cannot be indented
if we want to avoid indenting
the resulting document too
DOCUMENT
}
# works;
sub return_a_here_document2 {
  return <<'	DOCUMENT';
This document is indented, but the
end token is also indented, so it parses OK
	DOCUMENT
}

### Converting Strings into Numbers ###
### Converting Strings into Lists and Hashes ###
sub ro1 {
  my $csv   = "one, two, three, four, five, six";
  my @list1 = split ',', $csv;
  my @list2 = split /, /, $csv;
  my @list3 = split /\s*, \s*/, $csv;
  printArray( 'list1', @list1 );
  printArray( 'list2', @list2 );
  printArray( 'list3', @list3 );

  my $pipesv = "one | two | three | four | five | six";
  print split( '|',  $pipesv ), "\n";    # prints one | two | three | four | five | six
  print split( '\|', $pipesv ), "\n";    # prints one two three four five six
  my $hashdef = "Mouse=>Jerry, Cat=>Tom, Dog=>Spike";
  my %hash    = split /, |=>/, $hashdef;
  printHash( 'hash', \%hash );
  # return (part of) delimiters
  my @list = split /\s*(, |=>)\s*/, $hashdef;
  printArray( 'list', @list );
  # @list contains 'Mouse', '=>', 'Jerry', ',' , 'Cat', ...
  # suppress return of delimiters, handle whitespace, assign resulting
  # list to hash
  %hash = split /\s*(?:, |=>)\s*/, $hashdef;
  printHash( 'hash', \%hash );

  my $configline = "equation=y = x ** 2 + c";
  # split on first = only
  my ( $key, $value ) = split( /=/, $configline, 2 );
  print "$key is '$value'\n";    # produces "equation is 'y = x ** 2 + c'"

}

sub readconfig_pl {
  # readconfig.pl
  use warnings;
  use strict;
  my %config;
  # read lines from files specified on command line or (if none)
  # standard input
  while (<>) {
    my ( $key, $value ) = split /=/;    # split on $_
    $config{$key} = $value if $key and $value;
  }
  print "Configured: ", join( ', ', keys %config ), "\n";
}

sub split_pl {
  # split.pl
  use warnings;
  use strict;
  my @words;
  # read lines from files specified on command line or (if none)
  # standard input
  while (<>) {
    # split lines into words and store
    push @words, split;
  }
  print "Found ", scalar(@words), " words in input \n";
}

### Functions For Manipulating Strings ###
sub ro2 {
### Line Terminator Termination ###
  #  while (<>) {
  #    chop;
  #    print "$_ \n";
  #  }

  #  while (<>) {
  #    my $string = substr $_, 0, -1;
  #    print $string;
  #  }

  # remove all trailing newlines from input, if present
  # @lines = <>;
  # chomp(@lines);

### Characters and Character Codes ###
  print ord('A'), "\n";    # returns 65
  print chr(65), "\n";     # returns 'A'
### Length and Position ###
  print length('123'), "\n";

  # https://perldoc.perl.org/functions/index
  # index STR,SUBSTR,POSITION
  # index STR,SUBSTR
  print index( 'I am looking for the soul mate.', "look for", 30 ), "\n";    # not found, produces -1
  print index( 'startswith sth.',                 "start",    0 ),  "\n";
  print rindex( 'startswith sth.', "start", 0 ), "\n";
  print index( 'sth. endswith', "with", 0 ), "\n";
  print rindex( 'sth. endswith', "with", 0 ), "\n";

### Substrings and Vectors ###
  # return characters from position 3 to 7 from $string
  print substr( "1234567890", 3, 4 ), "\n";                                  # produces 4567
  print substr( "1234567890", 3 ), "\n";                                     # produces 4567890
  print substr( "1234567890", -7, 2 ), "\n";                                 # produces 45
  print substr( "1234567890", -7 ), "\n";                                    # produces 4567890
  print substr( "1234567890", -7, -2 ), "\n";                                # produces 45678

  my $string = "1234567890";
  print substr( $string, 3, 4, "abc" ), ',', $string, "\n";
  # produces '4567'
  # $string becomes '123abc890'
  $string = "1234567890";
  print substr( $string, 3, 4 ) = "abc", ' ,', $string, "\n";
  # produces 'abc8'
  # $string becomes '123abc890'

### Upper and Lower Case ###
  print uc('upper'), "\n";    # produces 'UPPER'
  print lc('LOWER'), "\n";    # produces 'lower'
  print ucfirst('daniel'), "\n";    # produces 'Daniel';
  print lcfirst('Polish'), "\n";    # produces 'polish';

### Pattern Matching and Transliteration ###
  my $matchtext = '"some text"';
  my $matched   = $matchtext =~ /some text/i;
  print("matched = $matched\n");
  my $text = "red green blue";
  $text =~ s/\bgreen\b/yellow/g;
  print $text, "\n";                # produces 'red yellow blue'

  my $hexstring = 'afChurch.ZHONG';
  $hexstring =~ tr/a-f/A-F/;
  print("Transliteration = $hexstring\n");

### Password Encryption ###
  my $plaintext  = '12345678';
  my @characters = ( 0 .. 9, 'a' .. 'z', 'A' .. 'Z', '.', '/' );
  my $salt       = @characters[ rand 64, rand 64 ];
  my $encrypted  = crypt( $plaintext, $salt );
  print("crypt( $plaintext, $salt ) = $encrypted\n");
  # die "Wrong!" unless $encrypted eq $salt;

### Low Level String Conversions ###
  my $integer10 = 100;
  print pack( 'i', $integer10 ), "\n";
  print pack( 'i', 1819436368 ), "\n";    # produces the string 'Perl'

  my @integers = ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 );
  print pack( 'i4', @integers[ 0 .. 3 ] ), "\n";
  print pack( 'i*', @integers ), "\n";
  print pack( 'i4xZ10', @integers[ 0 .. 3 ], "abcdefghijklmonop" ), "\n";
  # We can also add spaces for clarity
  print pack( 'i4 x Z10', @integers[ 0 .. 3 ], "abcdefghijklmonop" ), "\n";
  my ( $int1, $int2, $int3, $int4, $str ) = unpack 'i4xZ10', $string;
  print pack( 'c', 65 ), "\n";
  print unpack( 'c', 'A' ), "\n";

  my @ords = unpack 'c*', 'church';
  printArray( 'ords', @ords );

  {
    # Similarly, here is how we can use x (which skips over or ignores, for unpack) and a (read as-is) to
    # extract a substring somewhat in the manner of substr:
    my ( $position, $slength ) = ( 1, 3 );
    print unpack( "x$position a$slength", 'church' ), "\n";
  }

  ### Vector Strings ###
  # perl -e 'foreach (unpack('c6', 'church')) {print $_, ".";}';
  my $bitstr     = chr(99) . chr(104) . chr(117) . chr(114) . chr(99) . chr(104);
  my $twobitflag = vec( $bitstr, 5, 2 );                                            # 5th 2-bit element is bits 10 to 12
  print("twobitflag = $twobitflag\n");

  # example, here is how we can define the string Perl from a 32-bit integer value:
  # assign a string by character code
  my $perl = chr(0x50) . chr(0x65) . chr(0x72) . chr(0x6c);    # $str = "Perl";
  print("$perl\n");
  # the same thing more efficiently with a 32-bit value and 'vec'
  vec( $perl, 0, 32 ) = 0x50_65_72_6c;
  print("$perl\n");
  # extract a character as 8 bits:
  print vec( $perl, 2, 8 ), "\n";                              # produces 114 which is the ASCII value of 'r'

  # return flag at offset, 4 bits
  # return vec $_[0], $_[1], 4;
  print vec( $bitstr, 2, 4 ), ",$bitstr\n";

  # set flag at offset, 4 bits
  # vec $_[0], $_[1], 4;

  ### String Formatting ###
  printf "v%vd\n",  $^V;             # print Perl's version
  printf "%v08b\n", 'aeiou';         # print letters as 8 bit binary digits
                                     # separated by points
  printf "%*v8o\n", '-', 'aeiou';    # print letters as octal numbers
                                     # separated by minus signs
}

### String Formatting ###
sub ro3 {
  # use the 'localtime' function to read the year, month and day
  my ( $year, $month, $day ) = (localtime)[ 5, 4, 3 ];
  $year  += 1900;
  $month += 1;
  my $date = sprintf '%4u/%02u/%02u', $year, $month, $day;
  print("date = $date\n");
}

sub example {
  ro3();
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
# chapter03:Chapter 3 Scalars
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example03.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
