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
  ### Package Variables ###
  ### Defining Package Variables ###
  ### Using 'strict' Variables ###

  ### Declaring Global Package Variables ###
  # $MyPackage::package_variable = "explicitly defined with package";

  ### Declaring Global Package Variables with 'use vars' ###
  # use vars qw($package_variable $another_var @package_array);
  globpack_pl();

### Lexically Declaring Global Package Variables with 'our'###
### Automatic Localization in Perl ###
  autolocal_pl();

### Localizing Package Variables with 'local' ###
  #  local $hero;
  #  local ($zip, @boing, %yatatata);
  #  local @list = (1, 2, 3, 4);
  #  local ($red, $blue, $green, $yellow) = ("red", "blue", "green");

  scope_our_pl();
  printwith( ',', ( 1, 2, 3 ) );
  printwith( ' ', ( 1, 2, 3 ) );

  ### Lexical Variables ###
  ### Declaring Lexical Variables ###
  #  my $scalar; # simple lexical scalar
  #  my $assignedscalar = "value"; # assigned scalar
  #  my @list = (1, 2, 3, 4); # assigned lexical array
  #  my ($red, $blue, $green); # list of scalars
  #  my ($left, $right, $center) = (1, 2, 0); # assigned list of scalars
  #  my ($param1, $param2) = @_; # inside subroutines

  scope_my_pl();
  ### Preserving Lexical Variables Outside Their Scope ###
  persist_pl();

  ### The Symbol Table ###
  ### The 'main' Package ###
  ### The Symbol Table Hierarchy ###
  ### Manipulating the Symbol Table Directly ###
  changeglobal_pl();
  anonsub_pl();

### Accessing the Symbol Table ###
  dumpmain_pl();
  dumpval_pl();
}

sub globpack_pl {
  # globpack.pl
  use warnings;
  use strict;

  sub define_global {
    use vars qw($package_variable);
    $package_variable = "defined in subroutine";
  }
  print $package_variable;    # visible here but not yet defined
  define_global;
  print $package_variable;    # visible here and now defined
}

sub autolocal_pl {
  # autolocal.pl
  use warnings;
  use strict;
  my $var = 42;
  my $last;
  print "Before: $var \n";
  foreach $var ( 1 .. 5 ) {
    print "Inside: $var \n";    # print "Inside: 1", "Inside: 2" ...
    $last = $var;
  }
  print "After: $var \n";       # prints '42'
  print $last;
}

sub scope_our_pl {
  # scope-our.pl
  use warnings;
  use strict;

  package MyPackage;
  my $my_var = "my-var";        # file-global lexical variable
  our $our_var   = "our-var";       # global to be localized with 'our'
  our $local_var = "global-var";    # global to be localized with 'local'
  use vars qw($use_var);            # define 'MyPackage::use_var' which exists
                                    # only in this package
  $use_var = "use-var";
### ERROR: the global variable is not declared
  # $package_variable = "eek";
  package AnotherPackage;
  print "Outside, my_var is '$my_var' \n";          # display 'my-var'
  print "Outside, our_var is '$our_var' \n";        # display 'our-var'
  print "Outside, local_var is '$local_var' \n";    # display 'global-var'
### ERROR: $use_var doesn't exist in this package
  # print "Outside, use_var is '$use_var' \n";
  sub mysub {
    my $my_var = "my_in_mysub";
    our $our_var = "our_in_mysub";
    local $local_var = "local_in_mysub";
### ERROR: global $use_var does not exist in this package
    # local $use_var = "local_use_in_mysub";
    print "In mysub, my_var is '$my_var'\n";          # display 'my_in_mysub'
    print "In mysub, our_var is '$our_var'\n";        # display 'our_in_mysub'
    print "In mysub, local_var is '$local_var'\n";    # display 'local_in_mysub'
    mysub2();
  }

  sub mysub2 {
    print "In mysub2, my_var is '$my_var' \n";          # display 'my-var'
    print "In mysub2, our_var is '$our_var' \n";        # display 'our-var'
    print "In mysub2, local_var is '$local_var' \n";    # display 'local_in_mysub'
  }
  mysub;
  print "Again outside, my_var is '$my_var' \n";          # display 'my-var'
  print "Again outside, our_var is '$our_var' \n";        # display 'our-var'
  print "Again outside, local_var is '$local_var' \n";    # display 'global-var'
}

sub printwith {
  my ( $separator, @stuff ) = @_;
  local $, = $separator;                                  # create temporary $,
  print @stuff;
}

sub scope_my_pl {
  # scope-my.pl
  use warnings;
  use strict;
  my $file_scope = "visible anywhere in the file";
  print $file_scope, "\n";

  sub topsub {
    my $top_scope = "visible in 'topsub'";
    if ( rand > 0.5 ) {
      my $if_scope = "visible inside 'if'";
      # $file_scope, $top_scope, $if_scope ok here
      print "$file_scope, $top_scope, $if_scope \n";
    }
    bottomsub();
    # $file_scope, $top_scope ok here
    print "$file_scope, $top_scope\n";
  }

  sub bottomsub {
    my $bottom_scope = "visible in 'bottomsub'";
    # $file_scope, $bottom_scope ok here
    print "$file_scope, $bottom_scope \n";
  }
  topsub();
  # only $file_scope ok here
  print $file_scope, "\n";
}

sub persist_pl {
  # persist.pl
  use warnings;
  use strict;

  sub definelexical {
    my $lexvar = "the original value";
    return \$lexvar;    # return reference to variable
  }

  sub printlexicalref {
    my $lexvar = ${ $_[0] };    # dereference the reference
    print "The variable still contains $lexvar \n";
  }
  my $ref = definelexical();
  printlexicalref($ref);
}

sub changeglobal_pl {
  # changeglobal.pl
  use warnings;
  use strict;
  our $global = 'before';

  sub changeglobal {
    local *local = *global;
    our $local = 'after';
  }
  print "$global \n";
  changeglobal;
  print "$global \n";
}

sub anonsub_pl {
  # anonsub.pl
  use warnings;
  use strict;
  our $anonsub = sub { print "Hello World\n" };
  *namedsub = \&{$anonsub};
  namedsub();
}

### Accessing the Symbol Table ###
sub dumpmain_pl {
  # dumpmain.pl
  use warnings;
  use strict;
  foreach my $name ( sort keys %{*::} ) {
    next if $name eq 'main';
    print "Symbol '$name' => \n";
    # extract the glob reference
    my $globref = ${*::}{$name};
    print( ref($globref), "\n" ) and next if ( 'CODE' eq ref($globref) );
    # define local package variables through alias
    local *entry = *{$globref};
    # make sure we can access them in 'strict' mode
    our ( $entry, @entry, %entry );
    # extract scalar, array, and hash via alias
    print "\tScalar: $entry \n"   if defined $entry;
    print "\tArray : [@entry] \n" if @entry;
    print "\tHash : {", join( " ", {%entry} ), "} \n" if %entry;
    # check for subroutine and handle via glob
    print "\tSub '${name}' defined \n" if *entry{CODE};
    print "\tHandle '${name}' (", fileno(*entry), ") defined \n"
      if *entry{IO};
  }
}

sub dumpval_pl {
  # dumpval.pl
  use warnings;
  use strict;
  use Dumpvalue;
  # first define some variables
  {
    # no warnings to suppress 'usage' messages
    no warnings;

    package World::Climate;
    our $weather = "Variable";

    package World::Country::Climate;
    our %weather = ( England => 'Cloudy' );

    package World::Country::Currency;
    our %currency = (
      England => 'Sterling',
      France  => 'Franc',
      Germany => 'Mark',
      USA     => 'US Dollar',
    );

    package World::Country::City;
    our @cities = ( 'London', 'Paris', 'Bremen', 'Phoenix' );

    package World::Country::City::Climate;
    our %cities = (
      London  => 'Foggy and Cold',
      Paris   => 'Warm and Breezy',
      Bremen  => 'Intermittent Showers',
      Phoenix => 'Horrifyingly Sunny',
    );

    package World::Country::City::Sights;
    our %sights = (
      London  => ( 'Tower of London', 'British Museum' ),
      Paris   => ( 'Eiffel Tower',    'The Louvre' ),
      Bremen  => ( 'Town Hall',       'Becks Brewery' ),
      Phoenix => ('Arcosanti'),
    );
  }
  my $dumper = new Dumpvalue( globPrint => 1 );
  $dumper->dumpValue( \*World:: );
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
# chapter08:Chapter 8 Scope and Visibility
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example08.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
