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
  ### Don’t recompute sort keys inside a sort. ###
  ### Use reverse to reverse a list. ###
  ### Use scalar reverse to reverse a scalar. ###
  ### Use unpack to extract fixed-width fields. ###
  ### Use split to extract simple variable-width fields. ###
  ### Use Text::CSV_XS to extract complex variable-width fields. ###
  ### Avoid string eval. ###
  ### Consider building your sorting routines with Sort::Maker. ###
  ### Use 4-arg substr instead of lvalue substr. ###
  ### Make appropriate use of lvalue values. ###
  ### Use glob, not <...>. ###
  ### Avoid a raw select for non-integer sleeps. ###
  ### Always use a block with a map and grep. ###
  ### Use the “non-builtin builtins”. ###

  # lightoff();

  my $actual_email_address  = 'church@xyz.com';
  my $visible_email_address = scalar reverse $actual_email_address;
  print("$visible_email_address\n");

  # sorter_test2();#FIXME

  use Time::HiRes qw( sleep );
  sleep 0.5;    # now sleeps half a second
  use Time::HiRes qw( usleep );
  usleep 500_001;    # now sleeps just over half a second

}

sub lightoff {
  use Readonly;
  Readonly my $MIN      => 0;
  Readonly my $MAX      => 10;
  Readonly my $INTERVAL => 1;
  for my $remaining ( reverse $MIN .. $MAX ) {
    print "T minus $remaining, and counting...\n";
    sleep $INTERVAL;
  }
}

sub extract {
  my @sales       = ();
  my @input_lines = ( 'X123-S000001324700000199', 'SFG-AT000000010200009099', 'Y811-Q000010030000000033', );

  # Specify order and lengths of fields...
  Readonly my %RECORD_LAYOUT => (
    # Ident Sales Price
    Unspaced => ' A6 A10 A8',              # Legacy layout
    Spaced   => ' @0 A6 @8 A10 @20 A8',    # Standard layout
    ID_last  => '@21 A6 @0 A10 @12 A8',    # New, more convenient layout
  );
  # Select record layout...
  my $layout_name = 'ID_last';             # get_layout($filename);
                                           # Grab each line/record...
  while ( my $record = <@input_lines> ) {  # $sales_data
                                           # Extract all fields...
    my ( $ident, $sales, $price ) = unpack $RECORD_LAYOUT{$layout_name}, $record;
    # Append each record, translating ID codes and
    # normalizing sales (which are stored in 1000s)...
    push @sales,
      {
      ident => translate_ID($ident),
      sales => $sales * 1000,
      price => $price,
      };
  }
}

sub make_sorter1 {
  my ( $subname, $key_code ) = @_;
  my $package = caller();
  # Create and compile the source of a new subroutine in the caller's namespace
  eval qq{
# Go to the caller's namespace...
package $package;
# Define a subroutine of the specified name...
sub $subname {
	# That subroutine does a Schwartzian transform...
return map { \$_->[0] } # 3. Return original value
sort { \$a->[1] cmp \$b->[1] } # 2. Compare keys
map { my (\$key) = do {$key_code}; # 1. Extract keys as asked,
[\$_, \$key]; # and cache with values
}
\@_; # 0. Sort full arg list
}
};
  # Confirm that the eval worked...
  use English qw( -no_match_vars );
  croak $EVAL_ERROR if $EVAL_ERROR;
  return;
}

sub sorter_test1 {
  my @names = ( 'ID:003,Church', 'ID:001,Turing', 'ID:002,Larry', );
  # and then...
  make_sorter1( sort_sha => q{ sha512($_) } );       # sorts by SHA-512 of each value
  make_sorter1( sort_ids => q{ /ID:(\d+)/xms } );    # sorts by ID field from each value
  make_sorter1( sort_len => q{ length } );           # sorts by length of each value
                                                     # and later...
  my @names_shortest_first = sort_len(@names);
  my @names_digested_first = sort_sha(@names);
  my @names_identity_first = sort_ids(@names);
  printArray( '@names_shortest_first', @names_shortest_first );
  printArray( '@names_digested_first', @names_digested_first );
  printArray( '@names_identity_first', @names_identity_first );
}
# sudo perl -MCPAN -e shell
# install Sub::Install

# Generate a new sorting routine whose name is the string in $sub_name
# and which sorts on keys extracted by the subroutine referred to by $key_sub_ref
sub make_sorter2 {
  my ( $sub_name, $key_sub_ref ) = @_;
  # Create a new anonymous subroutine that implements the sort...
  my $sort_sub_ref = sub {
    # Sort using the Schwartzian transform...
    return map { $_->[0] }                # 3. Return original value
      sort     { $a->[1] cmp $b->[1] }    # 2. Compare keys
      map { [ $_, $key_sub_ref->() ] }    # 1. Extract key, cache with value
      @_;                                 # 0. Perform sort on full arg list
  };

  # Install the new anonymous sub into the caller's namespace
  # use Sub::Installer;
  # caller->install_sub( $sub_name, $sort_sub_ref );
  return;
}

sub sorter_test2 {
  my @names = ( 'ID:003,Church', 'ID:001,Turing', 'ID:002,Larry', );
  # and then...

  my $sorter = undef;
  use Sort::Maker;
  # Create sort subroutines (ST flag enables Schwartzian transform)...
  $sorter = make_sorter2( name => 'sort_sha', code => sub { sha512($_) }, ST => 1 );
  die "make_sorter: $@" unless $sorter;
  $sorter = make_sorter2( name => 'sort_ids', code => sub { /ID:(\d+)/xms }, ST => 1 );
  die "make_sorter: $@" unless $sorter;
  $sorter = make_sorter2( name => 'sort_len', code => sub { length }, ST => 1 );
  die "make_sorter: $@" unless $sorter;

  # and later...
  my @names_shortest_first = sort_len(@names);
  my @names_digested_first = sort_sha(@names);
  my @names_identity_first = sort_ids(@names);
  printArray( '@names_shortest_first', @names_shortest_first );
  printArray( '@names_digested_first', @names_digested_first );
  printArray( '@names_identity_first', @names_identity_first );
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
# chapter08:Chapter 8, Built-in Functions
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example08.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
