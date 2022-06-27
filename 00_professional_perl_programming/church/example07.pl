#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;
#use diagnostics;
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
  ### There are two types of subroutine, named and anonymous. ###
  ### Declaring and Calling Subroutines ###
  ### Anonymous Subroutines and Subroutine References ###

  # anonymous subroutine: return a code reference to the subroutine definition.
  my $subref = sub { print "Hello anonymous subroutine\n"; };

  # call an anonymous subroutine
  &$subref;
  &$subref("a parameter");

  $subref->();
  $subref->("a parameter");

  callsub_pl();

  # define anonymous subroutines for different sort types:
  #my $numericsort = sub {$a <=> $b};
  #my $stringsort = sub {$a cmp $b };
  #my $reversenumericsort = sub {$b <=> $a};
  # now select a sort method
  #my $sortsubref = $numericsort;
  sortsub_pl();
### Strict Subroutines and the 'use strict subs' Pragma ###

  #  no strict 'subs';
  #  no strict q(subs);
  #  no strict qw(subs);

### Predeclaring Subroutines ###
  debug1("This is a debug message");    # ERROR: no parentheses
                                        #...rest of program...

  sub debug1 {
    print STDERR @_, "\n";
  }

  # predeclare subroutine 'debug'
  sub debug2;
  debug2 "This is a debug message";     # no error
                                        #...rest of program...

  sub debug2 {
    print STDERR @_, "\n";
  }

### Overriding Built-in Functions ###
  srandcall_pl();

  #  use mysrand; # import 'mysrand'
  #  use mysrand qw(mysrand); # import and predeclare mysrand;
  #  use mysrand qw(srand); # override 'srand'
}

sub callsub_pl {
  # callsub.pl
  use warnings;
  use strict;

  sub _do_list {
    my ( $subref, @in ) = @_;
    my @out;
    map { push @out, &$subref($_) } @in;
    return @out;
  }

  sub add_one {
    return $_[0] + 1;
  }
  $, = ",";
  print _do_list( \&add_one, 1, 2, 3 ), "\n";    # prints 2, 3, 4
}

sub sortsub_pl {
  # sortsub.pl
  use warnings;
  use strict;
  # a list to sort
  my @list = ( 3, 4, 2, 5, 6, 9, 1 );
  # directly with a block
  print sort { $a cmp $b } @list, "\n";
  # with a named subroutine
  sub sortsub {
    return $a cmp $b;
  }
  print sort sortsub @list, "\n";
  # with an anonymous subroutine
  my $sortsubref = sub { return $a cmp $b; };
  print sort $sortsubref @list, "\n";
}

sub srandcall_pl {
  # srandcall.pl
  use warnings;
  use strict;
  use subs qw(srand);

  sub srand {
    if ( $] >= 5.004 and not @_ ) {
      warn "Unqualified call to srand redundant in Perl $]";
    } else {
      # call the real srand via the CORE package
      CORE::srand @_;
    }
  }
}

sub ro1 {
  ### The Subroutine Stack ###

  # 0)package: the package of the caller;
  # 1)filename: the source file of the caller;
  # 2)line: the line number in the source file;
  # 3)subroutine: the subroutine that was called (that is, us). If we execute code inside an eval;
  # 4)statement then this is set to eval;
  # 5)hasargs: this is true if parameters were passed (@_ was defined);
  # 6)wantarray: the value of wantarray inside the caller, see 'Returning Values' later in;
  # 7)the chapter;
  # 8)evaltext: the text inside the eval that caused the subroutine to be called, if the subroutine;
  # 9)was called by eval;
  #10)is_require: true if a require or use caused the eval;
  #11)hints: compilation details, internal use only;
  #12)bitmask: compilation details, internal use only;

  mysub1('dummy');
  my @caller_info = caller 0;    # or caller(0), if we prefer
  printArray( '@caller_info', @caller_info );

  # get the name of the calling subroutine, if there was one
  # my $callingsub = ( caller 1 )[3];
  # print("name = $callingsub\n"); # main::example

  my ( $pkg, $file, $line, $callingsub ) = caller 1;
  print("$pkg, $file, $line, $callingsub\n");

  mysub2('dummy');

### Recursion ###
  fib1_pl();
  fib2_pl();
  fib3_pl();

### Checking for Subroutines and Defining Subroutines ###
### On the Fly ###

  # if (defined &capitalize) {
  #   capitalize(@countries);
  # }

  # $bean->jump('left') if $bean->can('jump');

### Passing Parameters ###
### Passing Lists and Hashes ###
### Converting Scalar Subroutines into List Processors ###
  my @countries = ( "england", "scotland", "wales" );
  capitalize3(@countries);    # produces ("England", "Scotland", "Wales")
  print("\n");

### Passing '@_' Directly into Subroutines ###
  # &mysubroutine; # inherit @_ from parent

### Named Parameters ###
  print "volume=", volume4( height => 1, width => 4, length => 9 ), "\n";

  # define some default parameters
  my %default = ( -height => 1, -width => 4, -length => 9 );
  # use default
  print volume5(%default), "\n";
  # override default
  print volume5( %default, -length => 16 ), "\n";
  print volume5( %default, -width => 6, -length => 10 ), "\n";
  # specify additional parameters
  print volume5( %default, -color => "red", -density => "13.4" ), "\n";

### Prototypes ###

  #  sub mysub (PROTOTYPE); # subroutine declaration
  #  sub mysub (PROTOTYPE) {...} # subroutine definition
  #  $subref = sub (PROTOTYPE) {...} # anonymous subroutine

### Defining the Number of Parameters and Their Scope ###
  print volume6( 1, 4, 9 ), "\n";    # displays 1 * 4 * 9 == 36
  my @size = ( 1, 4, 9 );
  print volume6(@size), "\n";

### Prototyping Code References ###
  my @words = ( "ehT", "terceS", "egasseM" );
  sub do_list(&@);                   # predeclare subroutine;
  do_list { print reverse( $_[0] =~ /./g ), "\n" if ( defined $_[0] ); } @words;

### Subroutines as Scalar Operators ###
  @countries = ( "england", "scotland", "wales" );
  capitalize5(@countries);
  printArray( '@countries', @countries );

### Requiring Variables Rather than Values ###
  varproto_pl();

  sub pushcapitalize (\@@);
  @countries = ();
  my @places = ( 'place0', 'place1', 'place2' );
  pushcapitalize @countries, "england";
  printArray( '@countries', @countries );
  pushcapitalize @countries, "scotland", "wales";
  printArray( '@countries', @countries );
  pushcapitalize @countries, @places;    # no flattening here!
  printArray( '@countries', @countries );

  my $countries_ref = \@countries;
  pushcapitalize @{$countries_ref}, "england";
  printArray( '@countries', @countries );

  # my $hash_ref = { 'one' => 1, 'two' => 2 };
  my %hash     = ( 'one' => 1, 'two' => 2 );
  my $hash_ref = \%hash;
  printHash( '$hash_ref', $hash_ref );
  flip( %{$hash_ref} );                  # FIXME
  printHash( '$hash_ref', $hash_ref );

### Optional Parameters ###
  my $result = 0;
  volume7( 1, 4, 9, \$result );          # $result ends up holding 36
  print("result=$result\n");

### Disabling Prototypes ###
  # capitalize6(@countries);      # ERROR: not a scalar variable
  # capitalize6( $countries[0] );    # pass only the first element
  # &capitalize6 @countries;    # disable the prototype

### capitalize as a anonymous subroutine ###
  #my $capitalize_sub = sub (\$) { $_[0] = ucfirst( lc $_[0] ); };

  # an anonymous 'sort' subroutine - use as 'sort $in_reverse @list'
  # anonymous_sort();

### Returning Values from Subroutines ###
### Returning the Undefined Value ###
  findfiles_pl();

### Determining and Responding to the Calling Context ###
  ### Handling Void Context ###
  ### Handling Context: an Example ###
  listfile_pl();
}

sub mysub1 {
  my ( $pkg, $file, $line ) = caller;
  die "Called with no parameters at $file line $line" unless @_;
  print("$pkg, $file, $line\n");
}

# die with a better error message
sub mysub2 {
  my ( $pkg, $file, $line ) = caller;
  die "Called from ", ( caller(1) )[3], " with no parameters at $file line $line
\n" unless @_;
  print("$pkg, $file, $line\n");
}

sub fib1_pl {
  # fib1.pl
  use warnings;
  use strict;

  sub fibonacci1 {
    my ( $count, $aref ) = @_;
    unless ($aref) {
      # first call - initialize
      $aref = [ 1, 1 ];
      $count -= scalar( @{$aref} );
    }
    $aref = [ 1, 1 ] unless $aref;
    if ( $count-- ) {
      my $next = $aref->[-1] + $aref->[-2];
      push @{$aref}, $next;
      return fibonacci1( $count, $aref );
    } else {
      return wantarray ? @{$aref} : $aref->[-1];
    }
  }
  # calculate 10th element of standard Fibonacci sequence
  print scalar( fibonacci1(10) ), "\n";
  # calculate 10th element beyond sequence starting 2, 4
  print scalar( fibonacci1( 10, [ 2, 4 ] ) ), "\n";
  # return first ten elements of standard Fibonacci sequence
  my @sequence = fibonacci1(10);
  print "Sequence: @sequence \n";
}

sub fib2_pl {
  #!/usr/bin/perl
  # fib2.pl
  use warnings;
  use strict;

  sub fibonacci2 {
    my ( $count, $internal ) = @_;
    if ( $count <= 2 ) {
      # we know the answer already
      return $internal ? [ 1, 1 ] : 1;
    } else {
      # call ourselves to determine previous two elements
      my $result = fibonacci2( $count - 1, 'internal' );
      # now we can calculate our element
      my $next = $result->[-1] + $result->[-2];
      if ($internal) {
        push @{$result}, $next;
        return $result;
      } else {
        return $next;
      }
    }
  }
  foreach ( 1 .. 20 ) {
    print "Element $_ is ", fibonacci2($_), "\n";
  }
}

sub fib3_pl {
  #!/usr/bin/perl
  # fib3.pl
  use warnings;
  use strict;

  sub fibonacci3 {
    my ( $count, $aref ) = @_;
    unless ($aref) {
      # first call - initialize
      $aref = [ 1, 1 ];
      $count -= scalar( @{$aref} );
    }
    if ( $count-- ) {
      my $next = $aref->[-1] + $aref->[-2];
      push @{$aref}, $next;
      @_ = ( $count, $aref );
      goto &fibonacci3;
    } else {
      return wantarray ? @{$aref} : $aref->[-1];
    }
  }
  # calculate 1000th element of standard Fibonacci sequence
  print scalar( fibonacci3(1000) ), "\n";
}

sub volume1 {
  my ( $height, $width, $length ) = @_;
  return $height * $width * $length;
}

sub volume2 {
  my $height = shift;
  my $width  = shift;
  my $length = shift;
  return $height * $width * $length;
}

sub volume3 {
  return $_[0] * $_[1] * $_[2];
}

#strip the line separator '$/' from the end of each passed string:
sub mychomp {
  foreach (@_) {
    s|$/$||;
  }
}

sub capitalize1 {
  $_[0] = ucfirst( lc $_[0] );
  print "$_[0]";
}

sub capitalize2 {
  foreach (@_) {
    $_ = ucfirst lc;    # lc uses $_ if argument is omitted
    print "$_[0]";
  }
}

sub capitalize3 {
  map { $_ = ucfirst lc } @_;
  print "$_[0]";
}

sub capitalize4 {
  map { $_ = ucfirst lc } @_;
  print "@_[0, 1, 2]";
}

sub volume4 {
  my %param = @_;
  return $param{'height'} * $param{'width'} * $param{'length'};
}

sub volume5 {
  my %param;
  if ( $_[0] =~ /^-/ ) {    # if the first argument starts '-', assume named
                            # arguments
    while (@_) {
      my ( $key, $value ) = ( shift, shift );
      # check all names are legal ones
      die "Invalid name '$key'"
        if $key !~ /^-(height|width|length|color|density)$/;
      $key =~ s/^-//;       #remove leading minus
      $param{$key} = $value;
    }
  } else {
    # no '-' on first argument - assume list arguments
    $param{'height'} = shift;
    $param{'width'}  = shift;
    $param{'length'} = shift;
  }
  foreach ( 'height', 'width', 'length' ) {
    unless ( defined $param{$_} ) {
      warn "Undefined $_, assuming 1";
      $param{$_} = 1;
    }
  }
  return $param{'height'} * $param{'width'} * $param{'length'};
}

# https://metacpan.org/pod/Data::Alias
sub volalias_pl {
  # volalias.pl
  use warnings;
  use strict;
  no strict 'vars';
  # use Alias;
  # subroutine using 'alias'
  sub volume {
    # alias @_;
    return $height * $width * $length;
  }
  # a call to the subroutine
  print volume( height => 1, length => 9, color => 'red', width => 4 );
  # aliased variables visible here
  print " = $height x $width x $length \n";
}

sub attr_pl {
  # attr.pl
  use warnings;
  use strict;
  {

    package Testing;
    # use Alias;
    no strict 'vars';    # to avoid declaring vars

    sub new {
      return bless {
        count   => [ 3, 2, 1 ],
        message => 'Liftoff!',
        },
        shift;
    }

    sub change {
      # define @count and $message locally
      attr(shift);
      # this relies on 'shift' being a hash reference
      @count   = ( 1, 2, 3 );
      $message = 'Testing, Testing';
    }
  }

  my $object = new Testing;
  print "Before: ", $object->{'message'}, "\n";
  $object->change;
  print "After : ", $object->{'message'}, "\n";
  print $Testing::message, "\n";    # warning - 'attr' vars do not persist
  close Testing::count;

}

sub volume6 ($$$) {
  return $_[0] * $_[1] * $_[2];
}

sub join_pl {
  # join.pl
  use warnings;

  sub wrapjoin ($$$@) {
    my ( $join, $left, $right, @strings ) = @_;
    foreach (@strings) {
      $_ = $left . $_ . $right;
    }
    return join $join, @strings;
  }
  print wrapjoin( "\n", "[", "]", "One", "Two", "Three" );
}

sub do_list (&@) {
  my ( $subref, @in ) = @_;
  my @out;
  foreach (@in) {
    push @out, &$subref($_);
  }
  return @out;
}

sub capitalize5 ($) {
  $_[0] = ucfirst( lc $_[0] );
}

sub varproto_pl {
  #!/usr/bin/perl
  # varproto.pl
  use warnings;
  use strict;

  sub capitalize (\$) {
    ${ $_[0] } = ucfirst( lc ${ $_[0] } );
  }
  my $country = "england";
  capitalize $country;
  print $country, "\n";
  # capitalize "scotland"; # ERROR: compile-time syntax error!
}

### Requiring Variables Rather than Values ###
sub pushcapitalize (\@@) {
  # push @{shift}, capitalize5(@_);
  my $aRef   = shift;
  my $second = shift;
  push @{$aRef}, capitalize5($second);
}

sub flip (\%) {
  # my @hash = %{$_[0]};
  # %{$_[0]} = reverse @hash;
  my $hRef = {@_};
  printHash( '$hRef', $hRef );
  my @hash = %{$hRef};
  %{$hRef} = reverse @hash;
  printHash( '$hRef', $hRef );
}

sub mass ($$$;$) {
  return volume(@_) * ( defined( $_[3] ) ? $_[3] : 1 );
}

sub volume7 ($$$;\$) {
  my $volume = $_[0] * $_[1] * $_[2];
  ${ $_[3] } = $volume if defined $_[3];
}

### Disabling Prototypes ###
sub capitalize6 (\$) {
  $_[0] = ucfirst( lc $_[0] );
  print("capitalize6: $_[0]\n");
}

### Returning Values from Subroutines ###
sub implicit_return1 {
  my $string = "implicit return value";
}

sub implicit_return2 {
  "implicit return value";
}

sub explicit_return {
  return "explicit return value";
}

# sub anonymous_sort {
#   my $in_reverse = sub ($$) {
#     return $_[1] <=> $_[0];
#     }
#     my @list = ( 7, 8, 9, 6, 5, 4 );
#   sort $in_reverse @list;
#   printArray( '@list', @list );
# }

### Returning the Undefined Value ###
sub findfiles_pl {
  # findfiles.pl
  use warnings;
  use strict;

  sub list_files {
    my $path = shift;
    return undef unless defined $path;    # return an empty list if no path
    return join( ',', glob "$path/*" );   # return comma separated string
  }

  my $files = list_files( $ARGV[0] );
  if ( defined $files ) {
    if ($files) {
      print "Found: $files \n";
    } else {
      print "No files found \n";
    }
  } else {
    print "No path specified\n";
  }
}

sub improved_list_files {
  my $path = shift;
  return wantarray ? () : undef unless defined $path;
  my @files = glob "$path/ *";
  return wantarray ? @files : \@files;
}

sub improved_findfiles_pl {
  # list context
  my @files = improved_list_files( $ARGV[0] );
  die "No path defined or no files found" unless @files;
  print "Found: @files \n";
  # scalar context
  my $files = improved_list_files( $ARGV[0] );
  die "No path defined! \n" unless defined $files;
  die "No files found! \n"  unless $files;
  print "Found: @{$files} \n";
}

### Handling Void Context ###
### Handling Context: an Example ###
sub listfile_pl {
  # listfile.pl
  use warnings;
  use strict;

  sub nested_list_files {
    # die "Function called in void context" unless defined wantarray;
    my $path = shift;
    return wantarray ? () : undef unless defined $path;
    chomp $path;    # remove trailing linefeed, if present
    $path .= '/*' unless $path =~ /\*/;    # add wildcard if missing
    my @files = glob $path;
    return wantarray ? @files : \@files;
  }
  print "Enter Path: ";
  my $path = <>;
  # call subroutine in list context
  print "Get files as list:\n";
  my @files = nested_list_files($path);
  foreach ( sort @files ) {
    print "\t$_\n";
  }
  # call subroutine in scalar context
  print "Get files as scalar:\n";
  my $files = nested_list_files($path);
  foreach ( sort @{$files} ) {
    print "\t$_ \n";
  }
  # to get a count we must now do so explicitly with $#...
  # note that 'scalar would not work, it forces scalar context.
  my $count = $#{ nested_list_files($path) } + 1;
  print "Count: $count files\n";
  # call subroutine void context - generates an error
  nested_list_files($path);
}

sub make_counter ($) {
  my $count = shift;
  return sub { return $count++; }
}

sub ro2 {
  ### Closures ###
  sub make_counter ($);
  my $tick1 = make_counter(0);      #counts from zero
  my $tick2 = make_counter(100);    #counts from 100
  $, = ",";
  print &$tick1, &$tick2, &$tick1, &$tick2, "\n";    # displays 0, 100, 1, 101

  closure_pl();

  ### Assignable Subroutines ###
  my $mystring = "this is some text";
  substr( $mystring, 0, 7 ) = "Replaced";
  print $mystring, "\n";                             # produces "Replaced some text";

  assignable_pl();
  lvalue_pl();

### Attribute Lists ###
### Defining Attributes on Subroutines ###
  #  sub mysubroutine : attr1 : attr2 { # standard subroutine
  #  #... body of subroutine ...
  #  }
  #  sub mysubroutine : attr1 attr2; # subroutine declaration

### Accessing Attributes ###
  # use attributes qw(get reftype); # import 'get' and 'reftype' subroutines
  # sub mysubroutine : locked method {}
  # my @attrlist = get \&mysubroutine; # contains ('locked', 'method')

### Special Attributes ###
### Package Attributes ###
}

sub closure_pl {
  # closure.pl
  use warnings;
  use strict;

  sub nested_make_counter ($) {
    my $count = @_ ? shift : 0;
    return sub {
      $count = $_[0] if @_;
      return $count++;
    }
  }
  my $counter = nested_make_counter(0);
  foreach ( 1 .. 10 ) {
    print &$counter, "\n";
  }
  print "\n";          # displays 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  $counter->(1000);    #reset the counter
  foreach ( 1 .. 3 ) {
    print &$counter, "\n";
  }
  print "\n";          # displays 1000, 1001, 1002
}

sub assignable_pl {
  # assignable.pl
  use warnings;
  use strict;
  my $scalar = "Original String";

  sub assignablesub : lvalue {
    $scalar;
  }
  print $scalar, "\n";
  assignablesub = "Replacement String";
  print $scalar, "\n";
}

sub lvalue_pl {
  my @array = ( 1, 2, 3 );

  sub set_element (\@$) : lvalue {
    @{ $_[0] }[ $_[1] ];    # return element of passed array
                            # @{$_[0]} is the array
                            # [$_[1]] is the $_[1]th element of that array
  }
  set_element( @array, 2 ) = 5;
  printArray( '@array', @array );
}

sub example {
  ro2();
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
# chapter07:Chapter 7 Subroutines
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example07.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
