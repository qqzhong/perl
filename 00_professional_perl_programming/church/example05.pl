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
  ### Lists and Arrays ###
  # define a six element array from a six element list
  my @array = ( 1, 2, 3, 4, 5, 6 );
  printArray( 'array', @array );

  # print the value of the fifth element (index 4, counting from 0)
  print "The fifth element is $array[4] \n";
  print "The fifth element is ", ( 1, 2, 3, 4, 5, 6 )[4], "\n";    # produces 5
  print "The first element is $array[0] \n";
  print "The last element is $array[-1] \n";
  print "The third to fifth elements: @array[2..4] \n";
  print "The first two and last two elements: @array[0, 1, -2, -1] \n";

  # replace array with first three elements, in triplicate
  @array = @array[ 0 .. 2, 0 .. 2, 0 .. 2 ];
  # pick two elements at random:
  my @random = @array[ rand scalar(@array), rand scalar(@array) ];
  printArray( 'random', @random );

  my @strings = ( 'one', 'two', 'three', 'four', 'five' );
  printArray( 'strings', @strings );
  @strings = qw(one two three four five);
  printArray( 'strings', @strings );
  @strings = qw(
    one
    two
    three
    four
    five
  );
  printArray( 'strings', @strings );

  my ( $one, $two, $three ) = ( 1, 2, 3 );    # $one is now 1, $two 2 and $three 3
  print("$one,$two,$three\n");

### Manipulating Arrays ###
### Modifying the Contents of an Array ###
  $array[4] = "The Fifth Element";
  printArray( 'array', @array );
  @array[ 3 .. 5, 7, -1 ] = ( "4th", "5th", "6th", "8th", "Last" );
  printArray( 'array', @array );

  @array = ( 1, 2, 3, 4, 5, 6 );
  @array[ 2 .. 4 ] = @array[ 0 .. 2 ];
  print "@array \n";
  @array = ( 1, 2, 1, 2, 3, 6 );
  printArray( 'array', @array );

  # assign first three elements to @array_a, and the rest to @array_b
  my @array_a = ();
  my @array_b = ();
  @array_a[ 0 .. 2 ], @array_b = @array;
  printArray( 'array_a', @array_a );
  printArray( 'array_b', @array_b );

  splice0_pl();
  splice1_pl();
  splice2_pl();
  splice3_pl();
  splice4_pl();
}

### splice0 ###
sub splice0_pl {
  my @array_new   = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 );
  my $from        = 5;
  my $quantity    = 3;
  my @replacement = ('x') x $quantity;
  splice @array_new, $from, $quantity, @replacement;
  printArray( 'array_new', @array_new );
}

### splice1 ###
sub splice1_pl {
  # splice1.pl
  use warnings;
  use strict;
  my @array = ( 'a', 'b', 'c', 'd', 'e', 'f' );
  # replace third element with three new elements
  my $removed = splice @array, 2, 1, ( 1, 2, 3 );
  print "@array \n";      # produces 'a b 1 2 3 d e f'
  print "$removed \n";    # produces 'c'
}

### splice2 ###
sub splice2_pl {
  # splice2.pl
  use warnings;
  use strict;
  my @array = ( 'a', 'b', 'c', 'd', 'e', 'f' );
  # replace three elements with a different three
  my @removed = splice @array, 2, 3, ( 1, 2, 3 );
  print "@array\n";       # produces 'a b 1 2 3 f'
  print "@removed\n";     # produces 'c d e'
}

### splice3 ###
sub splice3_pl {
  # splice3.pl
  use warnings;
  use strict;
  my @array = ( 'a', 'b', 'c', 'd', 'e', 'f' );
  # remove elements 2, 3 and 4
  my @removed = splice @array, 2, 3;
  print "@array\n";       # produces 'a b f'
  print "@removed\n";     # produces 'c d e'
}

### splice4 ###
sub splice4_pl {
  # splice4.pl
  use warnings;
  use strict;
  my @array = ( 'a', 'b', 'c', 'd', 'e', 'f' );
  # remove last three elements
  my @last_3_elements = splice @array, -3;
  print "@array\n";              # produces 'a b c'
  print "@last_3_elements\n";    # produces 'd e f'
}

sub ro1 {
### Counting an Array ###
  my $last_element = ( 7, 8, 9 );    # last_element becomes 3
  print("last_element = $last_element\n");

  my @array   = ('') x 8;
  my $highest = $#array;
  print("highest should be 7 ?= $highest\n");
  byindex_pl();

### Adding Elements to an Array ###
  add_pl();
  @array = ( 'a', 'b', 'c', 'd', 'e', 'f' );
  print "@array \n";                 # produces 'a b 1 2 3 d e f'
  $array[6] = "g";
  print "@array \n";                 # produces 'a b 1 2 3 d e f g'

  $array[ scalar(@array) ] = "This extends the array by one element";
  print "@array \n";
  push @array, "This extends the array by one element more simply";
  print "@array \n";

  unshift @array, "This becomes the zeroth element";
  print "@array \n";

  # These are equivalent;
  # push @array, @more;
  # splice @array, @array,0,@more;
  # These are equivalent;
  # unshift @array, @more;
  # splice @array, 0, 0, @more;

  ### Resizing and Truncating an Array ###
  # $#array = 999; # extend @array to 1000 elements
  # $#array = 3; # remove @elements 4+ from array
  # more efficient way:
  # @array = @array[0..3];

  remove_pl();

  #  # These are equivalent;
  #  pop @array;
  #  splice(@array, -1);
  #  # These are equivalent;
  #  shift @array;
  #  splice(@array, 0, 1);

  my @numbers = ( 0, 1, 2 );
  print( 'length = ' . $#numbers . "\n" );
  printArray( '@numbers', @numbers );
  # read last element and then truncate array by one - that's a 'pop'
  $last_element = $numbers[$#numbers];
  print( 'length = ' . ( $#numbers-- ) . "\n" );
  print("last_element = ${last_element}\n");
  printArray( '@numbers', @numbers );

  # Extending this principle, here is how we can do a multiple pop operation:
  #  @last_20_elements = $array[-20..-1];
  #  $#array-=20;

  # To truly remove elements from an array:
  # @removed = splice( @array, $start, $quantity );
  # to remove elements 2 to 5 (four elements in total) from an array we would use:
  # @removed = splice( @array, 2, 4 );

  # here is how we can move elements from the end of the list to the
  # beginning, using a splice and an unshift.
  # unshift @array, splice(@array, -3, 3);

  # in the reverse direction:
  # push @array, splice(@array, 0, 3);
}

sub byindex_pl {
  # byindex.pl
  use warnings;
  use strict;
  my @array = ( "First", "Second" );
  foreach ( 0 .. $#array ) {
    print "Element number $_ contains $array[$_] \n";
  }
}

### Adding Elements to an Array ###
sub add_pl {
  # add.pl
  use warnings;
  use strict;
  my @array = ( 'a', 'b', 'c', 'd', 'e', 'f' );
  print "@array \n";    # produces 'a b 1 2 3 d e f'
  $array[6] = "g";
  print "@array \n";    # produces 'a b 1 2 3 d e f g'
}

### Removing Elements from an Array ###
sub remove_pl {
  # remove.pl
  use warnings;
  use strict;
  my @array = ( 1, 2, 3, 4, 5, 6 );
  push @array, '7';     # add '7' to the end
  print "@array\n";     # array is now (1, 2, 3, 4, 5, 6, 7)
  my $last = pop @array;    # retrieve '7' and return array to six elements
  print "$last\n";          # print 7
  unshift @array, -1, 0;
  print "@array\n";         # array is now (-1, 0, 1, 2, 3, 4, 5, 6)
  shift @array;             # remove the first element of the array
  shift @array;             # remove the first element of the array
  print "@array\n";         # array is now again (1, 2, 3, 4, 5, 6)
}

sub reversed { $b cmp $a }
# @reversed = sort reversed @words;
sub numerically { $a * 1.0 <=> $b * 1.0 or $a cmp $b }
# @number_order = sort numerically @words;
sub backwards ($$) { $_[0] cmp $_[1] }

sub ro2 {
  ### Removing All Elements from an Array ###
  my @array = ( 0, 1, 2 );
  undef @array;             # destroy @array
  @array = ();              # destroy @array
                            # @array = @array[-100..-1]; # truncate @array to its last one hundred lines
                            # This is simply another way of saying:
                            # splice(@array, 0, $#array-100);

  ### Sorting and Reversing Lists and Arrays ###
  @array = ( 0, 1, 2 );
  printArray( '@array', @array );
  # reverse the elements of an array
  @array = reverse @array;
  printArray( 'reverse', @array );
  # reverse elements of a list
  my @ymd = reverse( (localtime)[ 3 .. 5 ] );    # return in year/month/day order
  printArray( '@ymd', @ymd );

  my @words = ( 'here', 'are', 'some', 'words' );
  printArray( '@words1', @words );
  my @alphabetical = sort @words;
  print "@words", "\n";                          # produces 'are here some words'
  printArray( '@alphabetical', @alphabetical );

  @alphabetical = sort { $a cmp $b } @words;
  printArray( '@alphabetical', @alphabetical );

######
  #  @ignoring_case = sort { lc($a) cmp lc($b) } @words;
  #  @reversed      = sort { $b cmp $a } @words;
  #  @numerically   = sort { $a <=> $b } @numbers;
  #  @alphanumeric  = sort { int($a) <=> int($b) or $a cmp $b } @mixed;
######

  my @reversed = sort reversed @words;
  printArray( '@reversed', @reversed );
  # force interpretation of $a and $b as floating point numbers
  my @floats       = ( 9.9, 3.3, 6.6 );
  my @number_order = sort numerically @floats;
  printArray( '@number_order', @number_order );

################################
  # use Order;
  # @reversed = sort Order::reversed @words;
  # printArray( '@reversed', @reversed );
################################

  ### Changing the Starting Index Value ###
  #$[     = 1;
  @array = ( 11, 12, 13, 14, 15, 16 );
  print '$array[3] = ', $array[3], "\n";    # produces 13 (not 14)

  ### Converting Lists and Arrays into Scalars ###
  # Taking References
  # $arrayref = \@array;

  my $copyofarray = [@array];
  printArray( '$copyofarray', @{$copyofarray} );

  ### Converting Lists into Formatted Strings ###
  # join values into comma-separated-value string
  my $string = join ',', @array;
  print("string = $string\n");
  # concatenate values together
  $string = join '', @array;
  print("string = $string\n");

  # get current date and time into array
  my @date = (localtime)[ 5, 4, 3, 2, 1, 0 ];    # Y, M, D, h, m, s
  $date[0] += 1900;                              # fix year
                                                 # generate time string using sprintf
  my $datestring = sprintf "%4d/%02d/%02d %2d:%02d:%02d", @date;
  print("datestring = $datestring\n");

  my $code = 65;
  my $char = pack 'C', $code;                    # $char = 'A' if $code = 65
  print("char = $char\n");

  my @codes = ( 80, 101, 114, 108 );
  my $word  = pack 'C*', @codes;
  print $word, "\n";                             # produces 'Perl'

  my @words2        = ( 'Practical', 'extraction', 'reporting', 'language' );
  my $first_letters = pack 'a' x @words2, @words2;
  print $first_letters, "\n";                    # guess...

  # perl -e 'foreach (unpack('c6', 'church')) {print $_,",";}'
  my @integers        = ( 99, 104, 117, 114, 99, 104 );
  my $stored_integers = pack( 'N' x @integers ), @integers;    #FIXME
  print("stored_integers = $stored_integers\n");

}

### Hashes ###
sub ro3 {
  # using variables to supply hash keys
  my ( $mouse, $cat, $dog ) = ( 'mouse', 'cat', 'dog' );
  # my ( $mouse, $cat, $dog ) => ( 'Souris', 'Chat', 'Chien' );
  my %hash = ( $mouse => 'Jerry', $cat => 'Tom', $dog => 'Spike' );
  printHash( 'hash', \%hash );
  # using quotes to use non-trivial strings as keys (with and without
  # interpolation)
  %hash = ( 'Exg Rate' => 1.656, '%age commission' => 2, "The mouse" => 'Jerry' );
  printHash( 'hash', \%hash );

  %hash = qw(
    Mouse Jerry
    Cat Tom
    Dog Spike
  );
  printHash( 'hash', \%hash );

  print "The mouse is ", $hash{'Mouse'}, "\n";
  my @catandmouse = @hash{ 'Cat', 'Mouse' };
  printArray( '@catandmouse', @catandmouse );

  my @aabz_values = @hash{ 'AA' .. 'BZ' };
  # printArray( '@aabz_values', @aabz_values );

  my @allkeys = keys %hash;
  printArray( '@allkeys', @allkeys );

  print "The keys are:", join( ',', sort keys %hash ), "\n";
  # dump out contents of a hash
  foreach ( sort keys %hash ) {
    print "$_ => $hash{$_} \n";
  }
}

sub ro4 {
  ### Manipulating Hashe ###
  # Adding and Modifying Hash Values
  my %hash = ( 'mouse' => 'Jerry', 'cat' => 'Tom', 'dog' => 'Spike' );
  $hash{'Cat'}  = 'Sylvester';
  $hash{'Bird'} = 'Tweety';
  printHash( 'hash', \%hash );

  @hash{ 'Cat', 'Mouse' } = ( 'Sylvester', 'Speedy Gonzales' );
  printHash( 'hash', \%hash );

  # add new pairs;
  my @allkeys   = ( 'one', 'two', 'three' );
  my @allvalues = ( 1,     2,     3 );
  @hash{@allkeys} = @allvalues;
  printHash( 'hash', \%hash );

  # my %lettercodes={};#bad
  my %lettercodes = ();    #good
  @lettercodes{ 'A' .. 'Z' } = 1 .. 26;
  printHash( '%lettercodes', \%lettercodes );
  print("sorted:{");
  foreach ( sort { $a cmp $b } keys %lettercodes ) {
    print("$_=>$lettercodes{$_} ");
  }
  print("}\n");

  #  @hash{'Cat', 'Mouse'} = ('Sylvester', 'Speedy Gonzales');
  #  Is equivalent to:
  #  $hash{'Cat'} = 'Sylvester';
  #  $hash{'Mouse'} = 'Speedy Gonzales';

  hash_pl();

### Removing Hash Keys and Values ###
  $hash{'Bird'} = 'on the fly';
  undef $hash{'Bird'};     # 'Bird' still exists as a key
  delete $hash{'Bird'};    # 'Bird' removed

### Converting Lists and Arrays into Hashes ###
  my @array = ( 1, 2, 3, 4, 5, 6 );
  %hash = @array;
  printHash( '%hash', \%hash );
  %hash = reverse %hash;
  printHash( '%hash', \%hash );

### Reversing Hashes ###
  reverse_pl();
  %hash = ( 'Key1' => 'Value1', 'Key2' => 'Value2' );
  %hash = reverse %hash;
  printHash( '%hash', \%hash );

### Accessing and Iterating Over Hashes ###
  iterate_pl();

### Sorting and Indexing ###
  %hash = ();                      #good
  @hash{ 'A' .. 'Z' } = 1 .. 26;
  # print list of sorted values
  foreach ( sort values %hash ) {
    print "Got $_ \n";
  }

  # sort a hash by values
  foreach ( sort { $hash{$a} cmp $hash{$b} } keys %hash ) {
    print "$hash{$_} <= $_ \n";
  }

  index_pl();

### Named Arguments ###
  arguments_pl();
}

sub hash_pl {
  # hash.pl
  use warnings;
  use strict;
  # define a default set of hash keys and values
  my %default_animals = ( Cat => 'Tom', Mouse => 'Jerry' );
  # get another set of keys and values
  my %input_animals = ( Cat => 'Ginger', Mouse => 'Jerry' );
  # combining keys and values of supplied hash with those in default hash overrides
  # default
  my %animals = ( %default_animals, %input_animals );
  print "$animals{Cat}\n";    # prints 'Ginger'
  printHash( '%animals', \%animals );
}

sub reverse_pl {
  # reverse.pl
  use warnings;
  use strict;
  my %hash = ( 'Key1' => 'Value1', 'Key2' => 'Value2' );
  print "$hash{Key1}\n";      # print 'Value1'
  foreach ( keys %hash ) {
    # invert key-value pair
    $hash{ $hash{$_} } = $_;
    # remove original key
    delete $hash{$_};
  }
  print "$hash{Value1}\n";    # print 'Key1'
}

sub iterate_pl {
  # iterate.pl
  use warnings;
  use strict;
  my %hash = ( 'Key1' => 'Value1', 'Key2' => 'Value2' );
  # dump of hash
  foreach ( keys %hash ) {
    print "$_ => $hash{$_} \n";
  }

  # sorted dump of hash
  foreach ( sort keys %hash ) {
    print "$_ => $hash{$_} \n";
  }

  # print list of sorted values
  foreach ( sort values %hash ) {
    print "Got: $_ \n";
  }

  # increment all hash values by one
  foreach ( @hash{ keys %hash } ) {
    $_++;
  }

  while ( my ( $key, $value ) = each %hash ) {
    print "$key => $value \n";
    $hash{$key}++;
  }
}

sub index_pl {
  # indexhash.pl
  use warnings;
  use strict;
  # create a hash with integrated index
  my %hash = (
    Mouse => { Index => 0, Value => 'Jerry' },
    Cat   => { Index => 1, Value => 'Tom' },
    Dog   => { Index => 2, Value => 'Spike' }
  );
  # sort a hash by integrated index
  foreach ( sort { $hash{$a}{'Index'} cmp $hash{$b}{'Index'} } keys %hash ) {
    print "Index=$hash{$_}{'Index'}, $hash{$_}{'Value'} <= $_ \n";
  }
}

### Named Arguments ###
sub arguments_pl {
  # arguments.pl
  use warnings;
  use strict;
  # list form takes mouse, cat, dog as arguments, fixed order.
  animate( 'Jerry', 'Tom', 'Spike' );
  # hash form takes animals in any order using '-' prefix to identify type,
  # also allows other animal types
  animate( -Cat => 'Sylvester', -Bird => 'Tweety', -Mouse => 'Speedy Gonzales' );
}
# and the subroutine...
sub animate {
  my %animals;
  # check first element of @_ for leading minus...
  if ( $_[0] !~ /^-/ ) {
    # it's a regular argument list, use fixed order
    @animals{ '-Mouse', '-Cat', '-Dog' } = @_;
  } else {
    # it's named argument list, just assign it.
    %animals = @_;
  }
  # rest of subroutine...
  foreach ( keys %animals ) {
    print "$_ => $animals{$_} \n";
  }
}

sub ro5 {
  ### Converting Hashes into Scalars ###
  convert_pl();

  # count the keys of a hash
  # $elements = scalar(keys %hash);

  # $hashref = {@array};
  # $arrayref = [%hash];

  ### Converting Hashes into Arrays ###
  #  @array = %hash;
  #  @keys = keys %hash;
  #  @values = values %hash;
  my %hash  = ( 'one' => 1, 'two' => 2 );
  my @array = ();
  foreach ( keys %hash ) {
    push @array, { $_ => $hash{$_} };    #push single hash
  }
  foreach my $e (@array) {
    foreach ( keys %{$e} ) {
      print("$_=>${$e}{$_}\n");
    }
    print "element = ", scalar( keys %{$e} ), "\n";
  }

  ### The Special Hash '%ENV' ###
  # perl -we 'foreach (sort keys %ENV) { print "$_ => $ENV{$_}\n"}'
  # perl -e "foreach (sort keys %ENV) { print qq($_ => $ENV{$_}\n); }"

  ### Configuring Programs via '%ENV' ###
  my $default_scriptdir = "/usr/local/myapp/scripts";
  my $scriptdir         = $ENV{MY_SCRIPTDIR} ? $ENV{MY_SCRIPTDIR} : $default_scriptdir;

  my %conf = ();
  foreach ( keys %ENV ) {
    # regular expressions are covered in Chapter 11
    /^QT_(.*)/ and $conf{$1} = $ENV{$_};
  }
  printHash( '%conf', \%conf );

  my %defaults = (
    SCRIPTDIR => '/usr/local/myapp/scripts',    # other defaults...
  );
  foreach ( keys %defaults ) {
    $conf{$_} = ( defined $ENV{"QT_$_"} ) ? $ENV{"QT_$_"} : $defaults{$_};
  }
  printHash( '%conf', \%conf );

  ### Handling Tainted Input from '%ENV' ###
  config_pl();
}

sub convert_pl {
  # convert.pl
  use warnings;
  use strict;
  my %hash = ( one => 1, two => 2, three => 3, four => 4, five => 5 );
  # check the hash has data
  if (%hash) {
    # find out how well the hash is being stored
    print scalar(%hash), "\n";    # produces '4/8'
  }

  # count the keys of a hash
  my $elements = scalar( keys %hash );
  print("elements = $elements\n");

  my @array   = ( 'one', 1, 'two', 2, 'three', 3, 'four', 4, 'five', 5 );
  my $hashref = {@array};
  printHash( '$hashref', $hashref );
  my $arrayref = [%hash];
  printArray( '$arrayref', @{$arrayref} );
}

sub config_pl {
  # config.pl
  use warnings;
  use strict;
  use Env qw($PATH @PATH);
  $sep = $Config::Config{'path_sep'};
  # add current directory if not already present
  unless ( $PATH =~ /(^|$sep)\.($sep|$)/ ) {
    push @PATH, '.';
  }
}

my $scalar_church_variable = 'scalar_variable';
my @array_church_variable  = ( 29, 55, 77 );
my %hash_church_variable   = ( k1 => 29, k2 => 55, k3 => 77 );

sub subroutine_variable {
  printArray( '@_', @_ );
  return "subroutine_variable";
}

sub ro6 {
  ### References ###
  ### Hard References ###
  ### Creating References ###

  # references to values
  my $numberref = \42;
  print("42 = ${$numberref}\n");
  my $messageref = \("Do not Drink The Wine!\n");
  print("message = ${$messageref}\n");
  my @listofrefs = \( 1, 4, 9, 16, 25 );
  foreach (@listofrefs) {
    print("list = ${$_}\n");
  }
  print("\n");

  # references to variables
  my $number    = 295577;
  my $scalarref = \$number;
  print("295577 = ${$scalarref}\n");
  my @array    = ( 0, 1, 2 );
  my $arrayref = \@array;
  printArray( '$arrayref', @{$arrayref} );
  my %hash    = ( one => 1, two => 2 );
  my $hashref = \%hash;
  printHash( '$hashref', $hashref );

  # $globref = \*typeglob; # typeglobs are introduced later in the chapter
  # reference to anonymous subroutine
  my $subref = sub { return "This is an anonymous subroutine" };
  print( "return = ", &$subref,    "\n" );
  print( "return = ", $subref->(), "\n" );
  my $call1 = &$subref;
  my $call2 = $subref->();
  print( "return = ", $call1, "\n" );
  print( "return = ", $call2, "\n" );
  # reference to named subroutine
  my $namedsubref = \&namedsubroutine;
  print( "return = ", &$namedsubref,    "\n" );
  print( "return = ", $namedsubref->(), "\n" );

  # @reflist = \(1, 2, 3);
  # This is identical to, but shorter than :
  # @reflist = (\1, \2, \3);

  # The [...] and {...} constructors also create a reference to an array or hash.
  # create a copy of their contents and return a reference to it, not a reference to the original.
  copyandref();

  ### Comparing References ###
  ref1_pl();
  ref2_pl();
  ### Dereferencing ###
  #  $value = $$ref;
  #  @array = @$arrayref;
  #  %hash = %$hashref;
  #  *glob = *$globref;
  my $ref = { a => 1, b => 2, c => 3 };
  print %$ref, "\n";    # produces a1b2c3 (dependent on internal ordering of hash)
                        #print @$ref;    # run-time error 'Not an ARRAY reference ...'
  $ref = [%$ref];       # convert '$ref' from hash to array reference
                        #print %$ref;    # run-time error 'Can't coerce array into hash ...'
  print @$ref, "\n";    # produces a1b2c3 (dependent on order of hash)

### Working with References ###
  @array = ( 1, [ 2, 3, 4 ], 5 );    #bingo
                                     #printArray( '@array', @array );#bad
  foreach (@array) {
    printArray( 'ref', @{$_} ) if ( 'ARRAY' eq ref($_) );
    print "$_," if ( 'ARRAY' ne ref($_) );
  }

### Finding the Type of a Reference ###
  $ref = \[ 1, 2, 3 ];
  print "The reference type of $ref is '", ref($ref), "' \n";

################################################################
  #  SCALAR A scalar reference
  #  ARRAY An array reference
  #  HASH A hash reference
  #  CODE A reference to an anonymous subroutine
  #  GLOB A reference to a typeglob
  #  IO (or IO::Handle) A Filehandle reference
  #  REF A reference to another reference
  #  LVALUE A reference to an assignable value that isn't a SCALAR,
  #  ARRAY or HASH (such as, the return value from substr)
################################################################

### Finding the Type of a Blessed Reference ###
  # perl reftype.pl CGI
  # grep -r "sub new" /usr/lib/x86_64-linux-gnu/perl/5.30/
  # reftype_pl('XXX');

### Symbolic References ###
  symbolic_ref_pl();

### "Package::variable" ###
  symbolic_references();
  # use strict; # strict 'vars', 'subs' and 'refs'
}

sub symbolic_references {
  # Unlike hard references, symbolic references do not have a type;
  # they are just strings after all.
  no strict 'refs';
  my $symref             = "main::scalar_church_variable";
  my $scalarDereferenced = $$symref;
  print("scalarDereferenced = $scalarDereferenced\n");
  $symref = "main::array_church_variable";
  my @arrayDereferenced = @$symref;
  printArray( '@arrayDereferenced', @arrayDereferenced );
  $symref = "main::hash_church_variable";
  my %hashDereferenced = %$symref;
  printHash( '%hashDereferenced', \%hashDereferenced );
  $symref = "main::subroutine_variable";
  my @args = ( 'a', 'r', 'g', 's' );
  print "And call a subroutine, returning ", &$symref(@args), ".\n";
}

sub copyandref {
  my @array        = ( 1, 2, 3 );
  my $samearrayref = \@array;
  printArray( '$samearrayref', @{$samearrayref} );
  my $copyarrayref = [@array];
  $copyarrayref->[0] = 11;
  $copyarrayref->[1] = 12;
  $copyarrayref->[2] = 13;
  printArray( '$copyarrayref', @{$copyarrayref} );
  printArray( '@array',        @array );

  # $samehashref = \%hash;
  # $copyhashref = {%hash};
}

# Creating a named subroutine
sub namedsubroutine {
  return "GeeksforGeeks";
}

sub ref1_pl {
  # ref1.pl
  use warnings;
  use strict;
  my $text = "This is a value";
  my $ref1 = \$text;
  my $ref2 = \$text;
  print $ref1 == $ref2, "\n";    # produces '1'
  $$ref1 = 'New value';
  print $$ref2, "\n";            # produces 'New value'
}

sub ref2_pl {
  # ref2.pl
  use warnings;
  use strict;
  my $text1 = "This is a value";
  my $text2 = "This is a value";
  my $ref1  = \$text1;
  my $ref2  = \$text2;
  print $ref1 == $ref2, "\n";    # produces ''
  $$ref1 = 'New value';
  print $$ref2, "\n";            # produces 'New value'
}

sub reftype_pl {
  # reftype.pl
  use warnings;
  use strict;
  use attributes qw(reftype);
  die "Usage: $0 <object module> ...\n" unless @ARGV;
  foreach (@ARGV) {
    my $filename = $_;
    $filename =~ s|::|/|g;
    require "$filename.pm";
    my $obj = new $_;
    print "Object class ", ref($obj), " uses underlying data type ", reftype($obj), "\n";
  }
}

sub symbolic_ref_pl {
  # symbolic_ref.pl
  use warnings;
  use strict;
  no strict 'refs';
  our @array = ( 1, 2, 3 );    # only package variables allowed
  my $symref = 'array';
  my $total  = $#$symref;
  $total++;
  print "$symref has $total elements \n";

  foreach (@$symref) {
    print "Got: $_ \n";
  }
}

sub ro7 {
  ### Complex Data Structures ###
  my @outer = ();
  my @inner = ( 3, 4 );
  # @outer = (1, 2, @inner, 5, 6);
  @outer = ( 1, 2, [@inner], 5, 6 );    # using square brackets
  foreach (@outer) {
    printArray( 'ref', @{$_} ) if ( 'ARRAY' eq ref($_) );
    print "$_," if ( 'ARRAY' ne ref($_) );
  }
  print("\n");
  # printArray( '@outer', @outer );
  @outer = ( 1, 2, \@inner, 5, 6 );     # using a backslash
  foreach (@outer) {
    printArray( 'ref', @{$_} ) if ( 'ARRAY' eq ref($_) );
    print "$_," if ( 'ARRAY' ne ref($_) );
  }
  print("\n");
  # printArray( '@outer', @outer );

### Lists of Lists and Multidimensional Arrays ###
  my @array = ( [ "One", "Two", "Three" ], [ "Red", "Yellow", "Blue" ], [ "Left", "Middle", "Right" ], );
  print $array[0][2], "\n";             # displays third element of first row - 'Three'
  print $array[2][1], "\n";             # displays second element of third row - 'Middle'
  print $array[0]->[2], "\n";

  # a scalar array reference:
  my $second_row = $array[1];
  # dereference this reference to get an array:
  my @second_row = @{ $array[1] };

  my $arrayref = [ [ "One", "Two", "Three" ], [ "Red", "Yellow", "Blue" ], [ "Left", "Middle", "Right" ], ];
  print $$arrayref[0][2], "\n";
  print $arrayref->[0][2], "\n";        # using -> is clearer

  $second_row = $$arrayref[1];
  $second_row = $arrayref->[1];
  print $second_row[2], "\n";
  print $second_row->[2], "\n";         # using -> is clearer

### Hashes of Hashes and Other Animals ###
  my %identities = (
    JohnSmith => {
      Name    => { First => "John",        Last => "Smith" },
      Phone   => { Home  => "123 4567890", Work => undef },
      Address => {
        Street  => "13 Acacia Avenue",
        City    => "Arcadia City",
        Country => "El Dorado",
      }
    },
    AlanSmithee => {
      Name  => { First => "Alan", Last => "Smithee" },
      Phone => { Work  => "not applicable" },
    }
  );

  my $alans_first_name = $identities{'AlanSmithee'}{'Name'}{'First'};
  print("alans_first_name = $alans_first_name\n");

  # Since nesting data structures is just a case of storing references,
  # we can also create lists of hashes, hashes of lists, and anything in between:
  lists_pl();
}

sub lists_pl {
  # lists.pl
  use warnings;
  use strict;
  my ( @list_of_hashes, %hash_of_lists, %mixed_bag, $my_object );
  my @my_list = ( 1, 2, 3, 4, 5 );
  @list_of_hashes = (
    { Monday => 1,        Tuesday => 2,        Wednesday => 3, Thrusday => 4, Friday => 5 },
    { Red    => 0xff0000, Green   => 0x00ff00, Blue      => 0x0000ff },
  );

  print "Tuesday is the $list_of_hashes[0]{Tuesday}nd day of the week.", "\n";
  %hash_of_lists = (
    List_1 => [ 1,     2,        3 ],
    List_2 => [ "Red", "Yellow", "Blue" ],
  );
  print "The second element of List_1 is: $hash_of_lists{List_1}[1]", "\n";
  %mixed_bag = (
    Scalar1 => 3,
    Scalar2 => "Hello World",
    List1   => [ 1, 2, 3 ],
    Hash1   => { A => 'Horses', C => 'Miles' },
    List2   => [ 'Eenie', 'Meenie', [ 'Meenie1', 'Meenie2' ], 'Mini', 'Mo' ],
    Scalar3 => $my_object,
    Hash2   => {
      Time => [gmtime],
      Date => scalar(gmtime),
    },
    List3 => @my_list[ 0 .. 2 ],
  );
  print "Eenie Meenie Mini $mixed_bag{List2}[4]";
}

### Adding to and Modifying Complex Data Structures ###
sub ro8 {
  # Right - adds a reference
  my @data = (
    [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],
    [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],
    [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],
  );
  my @third_row = $data[2];
  my @array     = ();
  $array[2] = \@third_row;    # backslash operator creates reference to array
  push @array, [ "Up", "Level", "Down" ];    # explicit reference
  push @array, \( "Large", "Medium", "Small" );    # backslashed reference
                                                   # ERROR: this is probably not what we want
  $array[2] = ( 8, 9, 10 );                        # $array[2] becomes 10, the 8 and 9 are discarded
  push @array, @third_row;                         # contents of @third_row added to @array

  # Right
  # $array[2][1]  = 9;                               # replace an individual element
  # $array[2][12] = 42;                              # grow the list by adding an element
  # @{ $array[2] } = ( 8, 9, 10 );                   # replace all the elements
  # @{ $array[2] }[ 1 .. 2 ] = ( 9, 10 );            # replace elements 2 and 3, keeping 1
  # ERROR: Wrong
  # $array[2][ 1 .. 2 ] = ( 9, 10 );                 # cannot take a slice of a list reference

### Creating Complex Data Structures Programmatically ###
  complex1_pl();
  complex2_pl();
  complex3_pl();
  complex4_pl();
  complex5_pl();
  complex6_pl();

### Traversing Complex Data Structures ###
  simple1_pl();
  simple2_pl();
  simple3_pl();
  print_struct_pl();

  # $> perl -d -e 1
  # $>   DB<1> $hashref={a=>1,b=>2,h=>{c=>3,d=>4},e=>[6,7,8]}
  # $>   DB<2> x $hashref

  datadumper_pl();
}

sub complex1_pl {
  # complex1.pl
  use warnings;
  use strict;
  my ( @outer, @inner );
  foreach my $element ( 1 .. 3 ) {
    @inner = ( "one", "two" );
    $outer[$element] = @inner;
  }
  print '@outer is ', "@outer \n";
}

sub complex2_pl {
  # complex2.pl
  use warnings;
  use strict;
  my ( @outer, @inner );
  foreach my $element ( 1 .. 3 ) {
    @inner = ( "one", "two" );
    push @outer, @inner;
  }
  print '@outer is ', "@outer \n";
}

sub complex3_pl {
  # complex3.pl
  use warnings;
  use strict;
  my ( @outer, @inner );
  foreach my $element ( 1 .. 3 ) {
    @inner = ( "one", "two" );
    push @outer, [@inner];    # push reference to copy of @inner
  }
  print '@outer is ', "@outer \n";
}

sub complex4_pl {
  # complex4.pl
  use warnings;
  use strict;
  my ( @outer, @inner );
  foreach my $element ( 1 .. 3 ) {
    @inner = ( "one", "two" );
    push @outer, \@inner;     # push reference to @inner
  }
  print '@outer is ', "@outer \n";
}

sub complex5_pl {
  # complex5.pl
  use warnings;
  use strict;
  my ( @outer, $inner_ref );
  foreach my $element ( 1 .. 3 ) {
    $inner_ref = [ "one", "two" ];
    push @outer, $inner_ref;    # push scalar reference
  }
  print '@outer is ', "@outer \n";
}

sub complex6_pl {
  # complex6.pl
  use warnings;
  use strict;
  my @outer;
  foreach my $element ( 1 .. 3 ) {
    my @inner = ( "one", "two" );
    push @outer, \@inner;       # push reference to @inner
  }
  print '@outer is ', "@outer \n";
}

sub simple1_pl {
  # simple1.pl
  use warnings;
  use strict;
  my @outer = ( [ 'a1', 'a2', 'a3' ], [ 'b1', 'b2', 'b3' ], [ 'c1', 'c2', 'c3' ] );
  foreach my $outer_el (@outer) {
    foreach ( @{$outer_el} ) {
      print "$_\n";
    }
    print "\n";
  }
}

sub simple2_pl {
  # simple2.pl
  use warnings;
  use strict;
  my %outer = (
    A => { a1 => 1, a2 => 2, a3 => 3 },
    B => { b1 => 4, b2 => 5, b3 => 6 },
    C => { c1 => 7, c2 => 8, c3 => 9 }
  );
  foreach my $outer_key ( keys %outer ) {
    print "$outer_key => \n";
    foreach ( keys %{ $outer{$outer_key} } ) {
      print "\t$_ => $outer{$outer_key} {$_} \n";
    }
    print "\n";
  }
}

sub simple3_pl {
  # simple3.pl
  use warnings;
  use strict;
  my @outer;
  @outer[ 1, 2, 5 ] = ( [ 'First', 'Row' ], [ 'Second', 'Row' ], [ 'Last', 'Row' ] );
  for my $outer_elc ( 0 .. $#outer ) {
    if ( $outer[$outer_elc] ) {
      my $inner_elcs = $#{ $outer[$outer_elc] };
      print "$outer_elc : ", $inner_elcs + 1, " elements \n";
      for my $inner_elc ( 0 .. $inner_elcs ) {
        print "\t$inner_elc : $outer[$outer_elc][$inner_elc] \n";
      }
    } else {
      print "Row $outer_elc undefined\n";
    }
  }
}

sub print_struct_pl {
  # print_struct.pl
  use warnings;
  use strict;
  my $mixed = [ 'scalar', [ 'a', 'list', [ 'of', 'many' ], 'values' ], { And => { 'AHash' => 'Of Hashes' } }, \('scalar ref') ];
  print_structure($mixed);

  sub print_structure {
    my ( $data, $depth ) = @_;
    $depth = 0 unless defined $depth;    # for initial call
    foreach ( ref $data ) {
      /^$/ and print( $data, "\n" ), next;
      /^SCALAR/ and print( '-> ', $$data, "\n" ), next;
      /^HASH/ and do {
        print "\n";
        foreach my $key ( keys %{$data} ) {
          print "\t" x $depth, "$key => ";
          print_structure( $data->{$key}, $depth + 1 );
        }
        next;
      };
      /^ARRAY/ and do {
        print "\n";
        for my $elc ( 0 .. $#{$data} ) {
          print "\t" x $depth, "[$elc] : ";
          print_structure( $data->[$elc], $depth + 1 );
        }
        next;
      };
      # it is something else - an object, filehandle or typeglob
      print "?$data?";
    }
  }
}

sub datadumper_pl {
  # datadumper.pl
  use warnings;
  use strict;
  use Data::Dumper;
  my $hashref = { a => 1, b => 2, h => { c => 3, d => 4 }, e => [ 6, 7, 8 ] };
  print Dumper($hashref);
}

sub ro9 {
  ### Typeglobs ###

  #  scalar - a reference to a scalar
  #  array - a reference to an array
  #  hash - a reference to a hash
  #  code - a code reference to a subroutine
  #  handle - a file or directory handle
  #  format - a format definition

### Defining Typeglobs ###
  my $message = "some text";
  print "$message\n";
  local *missive;
  *missive = $message;
  print "missive=", *missive, "\n";    #FIXME=>FIXED

  my $gref;
  *gref = \$message;
  # print "$message, ${$gref}\n";

### Manipulating Typeglobs ###
  #  *glob = \$scalar; # create $glob as alias for $scalar
  #  *glob = \@array; # create @glob as alias for @array
  #  *glob = \%hash; # create %glob as alias for %hash

### Accessing Typeglobs ###
  my $scalarref = *glob{SCALAR};
  my $arrayref  = *glob{ARRAY};
  my $hashref   = *glob{HASH};
  my $subref    = *glob{CODE};
  my $fhref     = *glob{IO};
  my $globref   = *glob{GLOB};

  print STDOUT "This goes to standard output\n";
  #print *STDOUT "The same thing, only indirectly\n";#error

### The Undefined Value ###
  my $a = undef;    # assign undefined value to $a
  my $b;            # assign undefined value to $b implicitly
  $a = 1;           # define $a
  print defined($a), "\n";    # produces '1'
  undef $a;                   # undefine $a
  print defined($a), "\n";    # produces '0'

  undef_pl('dummy.txt');
  ### Tests of Existence ###
  print "It is defined!\n" if defined $b;

  my %hash = ( 'A Key' => 'A Value', 'Another Key' => 'Another Value' );
  print "It exists!\n" if exists $hash{'A Key'};
  exists_pl();

### Using the Undefined Value ###
  # If warnings are not enabled, undef simply evaluates to an empty string.
  frequency_pl();

  ### Using 'undef' as a Function ###
  # The following two statements are therefore equivalent:
  # undef @array;
  # @array = ();
  %hash = ( 'key' => 'v1', 'two' => 2 );
  undef $hash{'key'};    # undefine value of key 'key'
  my $value  = $hash{'key'};         # $value is now 'undef'
  my @array1 = ( 1, 2, 3, 4, 5 );    # define a five element array1
  @array1[ 1 .. 3 ] = undef;         # @array1 contains (1, undef, undef, undef, 5)
  printArray( '@array1', @array1 );

  my @array2 = ( 1, 2, 3, 4, 5 );    # define a five element array2
  delete @array2[ 1 .. 3 ];          # no more second, third, and fourth elements
  printArray( '@array2', @array2 );
}

sub undef_pl {
  # undef.pl
  use warnings;
  use strict;
  # get a filename
  # my $file = $ARGV[0] or die "Usage $0 <result file> \n";
  my $file = shift;
  # process and return result
  my $result = get_results($file);
  # test result
  if ($result) {
    print "Result of computation on '$file' is $result \n";
  } elsif ( defined $result ) {
    print "No results found in file \n";
  } else {
    print "Error - could not open file: $! \n";
  }
  # and the subroutine...
}

sub get_results {
  # return 'undef' to indicate error
  open RESULTS, $_[0] or return undef;
  # compute result (simple sum)
  my $file_result = 0;
  while (<RESULTS>) {
    $file_result += $_;
  }
  # return result, 0 if file empty
  return $file_result;
}

sub exists_pl {
  # exists.pl
  use strict;
  use warnings;
  my %hash = ( 'Key1' => 'Value1', 'Key2' => 'Value2' );
  my $key  = 'Key1';
  # the first if tests for the presence of the key 'Key1'
  # the second if checks whether the key 'Key1' is defined
  if ( exists $hash{$key} ) {
    if ( defined $hash{$key} ) {
      print "$key exists and is defined as $hash{$key} \n";
    } else {
      print "$key exists but is not defined \n";
    }
  } else {
    print "$key does not exist\n";
  }
}

sub frequency_pl {
  # frequency.pl
  use warnings;
  use strict;
  my $text  = "the quick brown fox jumps over the lazy dog";
  my %count = frequency($text);
  print "'$text' contains: \n";
  foreach ( sort keys %count ) {
    print "\t", $count{$_}, " '$_", ( $count{$_} == 1 ) ? "'" : "'s", "\n";
  }
}

sub frequency {
  my $text = join( '', @_ );
  my %letters;
  foreach ( split //, $text ) {
    $letters{$_}++;
  }
  return %letters;
}

sub ro10 {
### Constants ###
  my $PI = 0;
  # define constant
  *PI = \3.1415926;
  print("PI = $PI\n");
  $PI = 0;    #FIXME
  print("PI = $PI\n");

### Declaring Scalar Constants with the 'constant' Pragma ###
  use constant PI => 3.1415926;
  print("PI = $PI\n");
  # PI = 0;# works
  print( "PI = " . PI . "\n" );
  # use constant PI => 4 * atan2(1, 1);

### Declaring List and Hash Constants ###
  use constant WEEKDAYS => ( 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday' );
  # print "The third day is", WEEKDAYS[2], "\n"; #ERROR: syntax error
  print "The third day is", (WEEKDAYS)[2], "\n";    #works ok
                                                    # (WEEKDAYS)[2] = 'Lundi';
  print "The third day is", (WEEKDAYS)[2], "\n";    #works ok

  use constant WEEKABBR => (
    Monday    => 'Mon',
    Tuesday   => 'Tue',
    Wednesday => 'Wed',
    Thu       => 'Thursday',
    Fri       => 'Friday'
  );
  my %abbr = WEEKABBR;
  my $day  = 'Wednesday';
  print "The abbreviation for $day is ", $abbr{$day}, "\n";

### Constant References ###
  use constant WEEKDAYS2 => [ 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday' ];
  print "The third day is ", (WEEKDAYS2)->[2], "\n";
  WEEKDAYS2->[0] = 'Lundi';    #this is perfectly legal, but the value is not changed.
  print "The third day is ", (WEEKDAYS2)->[2], "\n";

### Listing and Checking for the Existence of Constants ###
  unless ( exists $constant::declared{'MY_CONSTANT'} ) {
    use constant MY_CONSTANT => "My value";
  }

  use constant declared => ( one => 1, two => 2 );
  foreach ( keys %constant::declared ) {
    print "Constant $_ is defined as '$constant::declared{$_}'\n";
  }
}

sub example {
  ro9();
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
# chapter05:Chapter 5 Non-Scalar Data Types
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example05.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
