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
  ### Expressions, Statements, and Blocks ###
  ### Declarations ###
  {
    use warnings;    # use pragmatic module
    use strict;      # use pragmatic module
  }

  BEGIN {
    print "This is a compile-time statement.\n";
  }

### Expressions and Simple Statements ###
### Blocks and Compound Statements ###

### Naked Blocks ###
  time_pl();

### Defining the Main Program as a Block ###
  blockmain_pl();

  ### Blocks as Loops ###
  # while_pl();
  # badblockloop_pl();
  # blockloop_pl();
  # blockwhile_pl();

  ### The 'do' Block ###
  my @words = do {
    my @text = ( "is", "he", "last" );
    sort @text;
  };
  printArray( '@words', @words );
  my $c = do { my $a = 3, my $b = 6 };    # a block, $c = 6
  { my $a = 3; my $b = 6 }                # has a semicolon, therefore a block
                                          # a hash definition, $c = {3 => 6}, which we can test with 'print keys %{$c}'
  my $hRef = { $a = 3, $b = 6 };
  printHash( '$hRef', $hRef );

  # do {} while or until;
  # do { chomp($line = <>); $input. = $line } until $line =~/^stop/;

  ### Special Blocks ###
  begend_pl();

  ### Conditional Statements ###
  # Value        True/False
  # 1            True
  # -1           True
  # "abc"        True
  # 0            False
  # "0"          False
  # ""           False
  # " "          True
  # "00"         True
  # "0E0"        True (this is returned by some Perl libraries)
  # "0 but true" True (ditto)
  # ()           False (empty list)
  # undef        False
  my $var = '';
  if ( defined $var ) {
    print "$var is defined\n";
  }
  $var = '0 but true';
  if ( defined($var) && $var ) {
    print "true \n";
  }

  ### 'if', 'else', and 'elsif' ###
  #  print "Equal" if $a eq $b;
  #  print (STDERR "Illegal Value"), return "Error" if $not_valid;
  #  close FILE, print ("Done"), exit if $no_more_lines;
  #  return if $a ne $b;

  # first 'if else' tests whether $var is defined
  if ( defined $var ) {
    # if $var is defined, the second 'if else' tests whether $var is true
    if ($var) {
      print "true \n";
    } else {
      print "false \n";
    }
  } else {
    print "undefined \n";
  }
  my ( $a, $b ) = ( 0, 0 );
  if ( $a eq $b ) {
    print "Equal";
  } elsif ( $a gt $b ) {
    print "Greater";
  } else {
    print "Less";
  }

### unless ###
  # unless file filename is successfully opened then return a failure message
  unless_pl();

### Writing Conditions with Logical Operators ###
  # $result = try_first() or try_second() or try_third ();
  # open (FILE, $filename) or die "Cannot open file: $!";
  # unless (open FILE, $filename) { die "Cannot open file: $!"; }
  # open (FILE, $filename) or do { print LOG "error";die "Cannot open file: $!"; };

### The Ternary Operator ###
  plural_if_pl();
  plural_ternary_pl();
  comparison_pl();
  plural_message_pl();
  fix_pl();
}

sub time_pl {
  # time.pl
  use warnings;
  # a bare block definition
  {
    # define six scalars in new block scope:
    my ( $sec, $min, $hour, $day, $month, $year ) = localtime();
    # variables exist and can be used inside block
    print "The time is: $hour: $min. $sec \n";
    $month++;
    $year += 1900;
    print "The date is: $year/ $month/ $day \n";
    print "$sec seconds \n";
    # end of block - variable definitions cease to exist
  }
  # produces 'uninitialized value' warning - $sec does not exist here
  # print "$sec seconds \n";
}

sub blockmain_pl {
  # blockmain.pl
  # declarations first
  use strict;
  use warnings;
  # initialization code, global scope
  my $global_variable = "All the World can see Me";
  use constant MY_GLOBAL_CONSTANT => "Global Constant";
  # here is the main program code
MAIN: {
    # variable defined in the main program scope, but not global
    my $main_variable = "Not visible outside main block";
    print_variables($main_variable);
  }
  # no-one here but us subroutines...
  sub print_variables {
    print $global_variable, "\n", MY_GLOBAL_CONSTANT, "\n";
    # print $main_variable, "\n"; #error!
    print $_[0], "\n";    # passed from main block, ok now
  }
}

sub while_pl {
  # while.pl
  use warnings;
  use strict;
  my $n = 0;
  print "With a while loop:\n";
  while ( ++$n < 4 ) { print "Hello $n \n"; }
  print "With a foreach loop:\n";
  foreach my $n ( 1 .. 3 ) { print "Hello $n \n"; }
  print "With a bare block and redo: \n";
  $n = 1;
  {
    print "Hello $n \n";
    last if ( ++$n > 3 );
    redo;
  }
}

sub badblockloop_pl {
  # badblockloop.pl
  use warnings;
  use strict;
  if ( defined( my $line = <> ) ) {
    last if $line =~ /quit/;
    print "You entered: $line";
    $line = <>;
    redo;
  }
  print "Bye! \n";
}

sub blockloop_pl {
  # blockloop.pl
  use warnings;
  use strict;
  if ( defined( my $line = <> ) ) {
    {    # <- note the extra block
      last if $line =~ /quit/;
      print "You entered: $line";
      $line = <>;
      redo;
    }
  }
  print "Bye! \n";
}

sub blockwhile_pl {
  # blockwhile.pl
  use warnings;
  use strict;
  while ( my $line = <> ) {
    last if $line =~ /quit/;
    print "You entered: $line";
  }
  print "Bye! \n";
}

sub begend_pl {
  # begend.pl
  use warnings;
  use strict;

  END {
    print "Exiting... \n";
  }
  print "Running... \n";

  BEGIN {
    print "Compiling... \n";
  }
}

sub unless_pl {
  local *FILE;
  my $filename = 'dummy.txt';
  unless ( open FILE, $filename ) {
    return "Failed to open $filename: $!";
  }

  return "Failed to open $filename: $!" unless ( open FILE, $filename );
  if ( not open FILE, $filename ) {
    return "Failed to open $filename: $!";
  }

  unless ( open FILE, $filename ) {
    return "Failed to open $filename: $!";
  } else {
    my @lines = <FILE>;
    foreach ( 0 .. $#lines ) {
      print "This is a line \n";
    }
    close FILE;
  }
}

sub plural_if_pl {
  # plural_if.pl
  use warnings;
  use strict;
  my @words = split( '\s+', <> );    # read some text and split on whitespace
  my $count = scalar(@words);
  print "There ";
  if ( $count == 1 ) {
    print "is";
  } else {
    print "are";
  }
  print " $count word";
  unless ( $count == 1 ) {
    print "s";
  }
  print " in the text \n";
}

sub plural_ternary_pl {
  # plural_ternary.pl
  use warnings;
  use strict;
  my @words = split( '\s+', <> );    # read some text and split on whitespace
  my $words = scalar(@words);
  print "There ", ( $words == 1 ) ? "is" : "are", " $words word", ( $words == 1 ) ? "" : "s", "in the text \n";
}

sub comparison_pl {
  # comparison.pl
  use warnings;
  use strict;
  my @words = split( '\s+', <> );
  die "Enter two words \n" unless scalar(@words) == 2;
  my $result = $words[0] cmp $words[1];
  print "The first word is ", $result ? $result > 0 ? "greater than" : "less than" : "equal to ", " the second \n";
}

sub plural_message_pl {
  # plural_message.pl
  use warnings;
  use strict;
  my @words   = split( '\s+', <> );
  my $words   = scalar(@words);
  my $message = "There " . ( $words == 1 ) ? "is" : "are" . " $words word" . ( $words == 1 ) ? "" : "s" . " in the text \n";
  print $message;
}

sub fix_pl {
  # fix.pl
  use warnings;
  use strict;
  my $word   = "mit";
  my $fix    = "re";
  my $before = int(<>);    # no warnings in case we enter no numeric text
  ( $before ? substr( $word, 0, 0 ) : substr( $word, length($word), 0 ) ) = $fix;
  print $word, "\n";
}

sub ro1 {
  ### Switches and Multi-Branched Conditions ###
  my $value = 1;
  if ( $value == 1 ) {
    print "First Place\n";
  } elsif ( $value == 2 ) {
    print "Second Place\n";
  } elsif ( $value == 3 ) {
    print "Third Place\n";
  } else {
    print "Try Again\n";
  }

SWITCH: {
    if ( $value == 1 ) { print "First Place\n" }
    if ( $value == 2 ) { print "Second Place\n" }
    if ( $value == 3 ) { print "Third Place\n" }
    if ( $value > 3 )  { print "Try Again\n" }
  }
SWITCH: {
    $value == 1 and print "First Place\n";
    $value == 2 and print "Second Place\n";
    $value == 3 and print "Third Place\n";
    $value > 3  and print "Try Again\n";
  }

SWITCH: {
    $value == 1 and print("First Place\n"),  last;
    $value == 2 and print("Second Place\n"), last;
    $value == 3 and print("Third Place\n"),  last;
    print "Try Again\n";    # default case
  }

SWITCH: {
    $value == 1 and print("First Place\n"),  last SWITCH;
    $value == 2 and print("Second Place\n"), last SWITCH;
    $value == 3 and print("Third Place\n"),  last SWITCH;
    print "Try Again\n";    # default case
  }

SWITCH: {
    $value == 1 and do {
      print "First Place\n";
      last;
    };
    $value == 2 and do {
      print "Second Place\n";
      last;
    };
    $value == 3 and do {
      print "Third Place\n";
      last;
    };
    print "Try Again\n";
  }

  # use regular expression matching:
SWITCH: {
    $value =~ /^1$/ and print("First Place\n"),  last;
    $value =~ /^2$/ and print("Second Place\n"), last;
    $value =~ /^3$/ and print("Third Place\n"),  last;
    print "Try Again\n";
  }

### Returning Values from Multi-Branched Conditions ###
  print do {
         $value == 1 && "First Place\n"
      || $value == 2 && "Second Place\n"
      || $value == 3 && "Third Place\n"
      || "Try again\n";
  }, "\n";

  print placing1($value), "\n";
  print placing2($value), "\n";
}

sub placing1 {
  $_[0] == 1 and return "First Place\n";
  $_[0] == 2 and return "Second Place\n";
  $_[0] == 3 and return "Third Place\n";
  return "Try Again\n";
}

# using the ternary operator:
sub placing2 {
  return
      $_[0] == 1 ? "First place\n"
    : $_[0] == 2 ? "Second place\n"
    : $_[0] == 3 ? "Third place\n"
    :              "Try Again\n";
}

sub ro2 {
  ### Loops and Looping ###
  ### Writing C-style Loops with 'for' ###

  for ( my $n = 0 ; $n < 10 ; $n++ ) {
    print $n, "\n";
    sleep 0.1;
  }
  print "Liftoff! \n";
  for ( my $n = 9 ; $n >= 0 ; $n-- ) {
    print $n, "\n";
    sleep 0.1;
  }
  print "Liftoff! \n";

  for ( my $n = 0 ; $n < 10 ; $n++ ) {
    print $n, ' is ', ( $n % 2 ) ? 'odd' : 'even';
  }

  local *FILE;
  open( FILE, 'dummy.txt' );
  for ( ; eof(FILE) ; ) {
    print <FILE>;
  }
  close(FILE);

  my $n = 0;
  while ( $n < 10 ) {
    print $n, ' is ', ( $n % 2 ) ? 'odd' : 'even';
  } continue {
    $n++;
  }

  ### Writing Better Loops with 'foreach' ###
  my @array = ( 1, 2, 3 );
  for ( my $n = 0 ; $n < $#array ; $n++ ) {
    print $array [$n], "\n";
  }
  my $element;
  foreach $element (@array) {
    print $element, "\n";
  }

  foreach my $element (@array) {
    print $element, "\n";
  }
  # $element does not exist here
  befaft_pl();

  foreach $element ( 0 .. $#array ) {
    # print "Element $element is @array[$element] \n";
    print "Element $element is $array[$element] \n";
  }
  foreach (@array) {
    print "$_ \n";
  }

### Using 'foreach' with Multi-Branched Conditions ###
  my $value = 1;
  foreach ($value) {
    /^1$/ and print("First Place\n"),  last;
    /^2$/ and print("Second Place\n"), last;
    /^3$/ and print("Third Place\n"),  last;
    print "Try Again\n";
  }
  foreach ($value) {
    my $message =
         /^1$/ && "First Place"
      || /^2$/ && "Second Place"
      || /^3$/ && "Third Place"
      || "Try Again";
    print "$message \n";
  }
  foreach ($value) {
    my $message =
        /^1$/ ? "First Place"
      : /^2$/ ? "Second Place"
      : /^3$/ ? "Third Place"
      :         "Try Again";
    print "$message \n";
  }

### Variable Aliasing in 'foreach' Loops ###
  capitalize_pl();

  @array = ( 'a' .. 'z' );
  foreach ( my @tmparray = @array ) {
    $_ =~ tr/a-z/A-Z/;
    print;
  }
  print("\n");
  printArray( '@array', @array );

### Conditional Loops : 'while', 'until', and 'do' ###
  count10_pl();

  my $filename = 'dummy.txt';
  open FILE, $filename;
  while ( my $line = <FILE> ) {
    print $line;
  }
  close FILE;
  open FILEHANDLE, $filename;
  until ( eof(FILEHANDLE) ) {
    my $line = <FILEHANDLE>;
    print $line;
  }

### Variable Aliasing with 'while' ###
  open FH, $filename;
  while (<FH>) {
    print "$.: $_";
  }
  # Or more tersely:
  print "$.: $_" while <FH>;

### Looping over Lists and Arrays with 'while' ###
  while ( $element = shift @array ) {
    print $element, "\n";
  }
  # @array is empty here
  startexp_pl();

### Looping on Self-Modifying Arrays ###
  # oscillator_pl();
  # upanddown_pl();

### Looping over Hashes with 'while' ###
  my %hash = ( one => 1, two => 2 );
  while ( my ( $key, $value ) = each(%hash) ) {
    print "$key => $value\n";
  }

### 'do...while' and 'do...until' ###
  # do_quit();
  # this works, but is confusing - don't do it.
  # do { print; } foreach (@array);

### Controlling Loop Execution ###
  # config_pl();
  last_pl();
  # backslash_pl();
### The 'continue' Clause ###
  $n = 0;
  while ( $n < 10 ) {
    next if ( $n % 2 );
    print $n, "\n";
  } continue {
    # 'next' comes here
    $n++;
  }
  # 'last' comes here
  for ( $n = 0 ; $n < 10 ; $n++ ) {
    next if ( $n % 2 );
    print $n, "\n";
  }

### Controlling Nested Loops ###
  nested_loop1();
  nested_loop2();
  nested_loop3();

### The Trouble with 'do' ###
  even1_pl();
  even2_pl();
  even3_pl();

### The 'goto' Statement ###
  goto1_pl();
  goto2_pl();
}

sub befaft_pl {
  # befaft.pl
  use warnings;
  use strict;
  my $var = 42;
  print "Before: $var \n";
  foreach $var ( 1 .. 5 ) {
    print "Inside: $var \n";
  }
  print "After: $var \n";    # prints '42', not '5'
}

sub capitalize_pl {
  # capitalize.pl
  use warnings;
  use strict;
  my @array = ( "onE", "two", "THREE", "fOUR", "FiVe" );
  foreach (@array) {
    # lc turns the word into lowercase, ucfirst then capitalizes the first letter
    $_ = ucfirst lc;         # lc uses $_ by default with no argument
  }
  print join( ',', @array ), "\n";
}

sub count10_pl {
  # count10.pl
  use warnings;
  use strict;
  # count from 1 to 10 (note the post-increment in the condition)
  my $n = 0;
  while ( $n++ < 10 ) {
    print $n, "\n";
  }
}

sub startexp_pl {
  # startexp.pl
  use warnings;
  use strict;
  # define a selection of strings one of which is 'start'
  my @lines = ( "this", "that", "the other", "start", "the data", "we want" );
  # discard lines until we see the 'start' marker
  while ( my $line = shift @lines ) {
    last if $line eq 'start';
  }
  # print out the remaining elements using interpolation ($")
  print "@lines";
}

sub oscillator_pl {
  # oscillator.pl
  use warnings;
  use strict;
  my $max   = 20;
  my @array = ( 1 .. $max - 1 );
  while ( my $element = shift @array ) {
    push( @array, $max - $element );
    # sleep 1;    # delay the print for one second to see the output
    print '*' x $element, "\n";    # multiply single '*' to get a bar of '*'s
  }
}

sub upanddown_pl {
  # upanddown.pl
  use warnings;
  use strict;
  my $max   = 6;
  my @array = ( 1 .. $max );
  while ( my $element = shift @array ) {
    push( @array, $max - $element );
    print $element, " : ", join( ",", @array ), "\n";
  }
}

sub do_quit {
  my $input;
  do {
    $input = <>;
    print "You typed: $input \n";
  } while ( $input !~ /^quit/ );

  do {
    $input = <>;
    print "You typed: $input \n";
  } until $input =~ /^quit/;
}

sub config_pl {
  # config.pl
  use warnings;
  use strict;
  my %config = ();
  while (<>) {
    chomp;    #strip linefeed
    next if /^\s*$/;     #skip to the next iteration on empty lines
    next if /^\s*\#/;    #skip to the next iteration on comments
    my ( $param, $value ) = split( "=", $_, 2 );    #split on first '='
    unless ($value) {
      print("No value for parameter '$_' \n");
      next;
    }
    $config{$param} = $value;
  }
  foreach ( sort keys %config ) {
    print "$_ => $config{$_} \n";
  }
}

sub last_pl {
  # last.pl
  use warnings;
  use strict;
  my @array = ( "One", "Two", "Three", undef, "Five", "Six" );
  # copy array up to the first undefined element
  my @newarray = ();
  foreach my $element (@array) {
    last unless defined($element);
    push @newarray, $element;
  }
  foreach (@newarray) {
    print $_. " \n";    # prints One, Two, Three
  }
}

sub backslash_pl {
  # backslash.pl
  use warnings;
  use strict;
  my @lines = ();
  while (<>) {
    chomp;
    if (s/\\$//) {      # check for and remove a trailing backslash character
      my $line = <>;
      $_ .= $line, redo;    # goes to the 'chomp' above
    }
    push @lines, $_;
  }
  foreach ( 0 .. $#lines ) {
    print "$_ : $lines[$_] \n";
  }
}

sub even1_pl {
  # even1.pl
  use warnings;
  use strict;
  # print out even numbers with a do...while loop
  my $n = 0;
  do {
    {
      next if ( $n % 2 );
      print $n, "\n";
    }
  } while ( $n++ < 10 );
}

sub even2_pl {
  # even2.pl
  use warnings;
  use strict;
  # print out even numbers with a do...while loop
  my $n = 0;
DO_LOOP: {
    do {
      {
        next if ( $n % 2 );
        print $n, "\n";
        # ...do other stuff
        last DO_LOOP if $n == 10;
      }
    } while ( ++$n );
  }
}

sub even3_pl {
  my $n = 0;
  while ( ++$n <= 10 ) {
    next if ( $n % 2 );
    print $n, "\n";
    # do other stuff
  }
}

sub goto1_pl {
  my @input_lines = ( "line 1\n", "\n", "line 2\n", "line 3\n", );
  my ( $lines, $empty, $comment, $code ) = ( 0, 0, 0, 0 );
  while (<@input_lines>) {
    /^$/ and $empty++,   goto CONTINUE;
    /^#/ and $comment++, goto CONTINUE;
    $code++, goto CONTINUE;
  CONTINUE:
    $lines++;
  }
  print("$empty,$comment,$code,$lines\n");
}

sub goto2_pl {
  my @input_lines = ( "line 1\n", "\n", "line 2\n", "line 3\n", );
  my ( $empty, $comment, $code, $lines ) = ( 0, 0, 0, 0 );
  while (<@input_lines>) {
    /^$/ and $empty++,   next;
    /^#/ and $comment++, next;
    $code++;
  } continue {
    $lines++;
  }
  print("$empty,$comment,$code,$lines\n");
}

sub goto_select {
  my $selection  = int( 4 * rand );                     # $selection is a random integer
  my @selections = ( "ZERO", "ONE", "TWO", "THREE" );
  goto $selections[$selection];
  {
  ZERO:
    print "None";
    next;
  ONE:
    print "One";
    next;
  TWO:
    print "Two";
    next;
  THREE:
    print "Three";
    next;
  }
  print "...done \n";
}

sub nested_loop1 {
  my @input_lines = ( "line 1\n", "\n", "line 2\n", "line 3\n", );
  my @lines       = ();
LINE: foreach (<@@input_lines>) {
    chomp;
    next LINE if /^$/;    # skip blank lines
    push @lines, $_;
  }
}

sub nested_loop2 {
  my @array = ( [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] );
OUTER: foreach my $outer (@array) {
  INNER: foreach my $inner ( @{$outer} ) {
      next OUTER unless defined $inner;
      print("$inner\n");
    }
    # 'last' or 'last INNER' would come here
  }
}

sub nested_loop3 {
  my @input_lines = ( "line 1\n", "\n", "line 2\n", "line 3\n", );
LINE: foreach my $line (<@input_lines>) {
    chomp($line);
  ITEM: foreach ( split /, /, $line ) {
      last LINE if /^_END_/;     # abort both loops on token
      next LINE if /^_NEXT_/;    # skip remaining items on token
      next ITEM if /^\s*$/;      # skip empty columns
                                 # process item
      print "Got: $_ \n";
    }
  }
}

sub ro3 {
  ### 'maps' and 'greps' ###
  my @numbers = ( 80, 101, 114, 108 );
  my @characters;
  foreach (@numbers) {
    push @characters, chr $_;
  }
  # print @characters;
  printArray( '@characters', @characters );

  # With map we can do it like this:
  @numbers    = ( 80, 101, 114, 108 );
  @characters = map ( chr $_, @numbers );
  printArray( '@characters', @characters );
  # Or, equivalently:
  @characters = map { chr $_ } @numbers;
  printArray( '@characters', @characters );

  print join( '-', map { chr $_ } @numbers ), "\n";    # displays 'P-e-r-l'

  my @input    = ( 'a', 'b', 'c', '1', '2', '3' );
  my @numerics = ();
  while (<@input>) {
    push @numerics, $_ if /^\d+/;
  }
  # print "@numerics\n";
  printArray( '@numerics', @numerics );
  @numerics = map { /^\d+/ ? $_ : () } <@input>;
  printArray( '@numerics', @numerics );
  @numerics = grep { /^\d+/ } <@input>;
  printArray( '@numerics', @numerics );
  @numerics = grep {
    if (s/\d+//) {
      $_ = "Got: $_";
    }
  } <@input>;
  printArray( '@numerics', @numerics );
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
# chapter06:Chapter 6 Structure, Flow, and Control
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example06.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
