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
use Carp;
use Readonly;
use IO::Prompt;

sub ro {
  ### Wherever possible, dereference with arrows. ###
  ### Where prefix dereferencing is unavoidable, put braces around the reference. ###
  ### Never use symbolic references. ###
  ### Use weaken to prevent circular data structures from leaking memory. ###

  # ${scalarRef}
  # @{arrayRef}
  # %{hashRef}

  #symbolic();
  my %customer = ( 'accounts' => [ 626261, 626262, 626263 ] );
  new_account( \%customer, '8888', 'admin' );
}

sub symbolic {
  # Create table of help texts and default text...
  Readonly my %HELP => (
    CD => 'change directory',
    LS => 'list directory',
    RM => 'delete file',
  );
  Readonly my $NO_HELP => 'No help available';
  # Request and read in next topic...
  while ( my $topic = prompt 'help> ' ) {
    # Look up requested topic in help table and display it...
    if ( exists $HELP{ uc $topic } ) {
      print $HELP{ uc $topic }, "\n";
    }
    # Otherwise, be helpless...
    else {
      print "$NO_HELP\n";
    }
  }
}

use Scalar::Util qw( weaken );
sub generate_account_num    { return 0; }
sub generate_initial_passwd { return 'test123456'; }
# Create a new bank account...
sub new_account {
  my ( $customer, $id, $type ) = @_;
  # Account details are stored in anonymous hashes...
  my $new_account = {
    customer => $customer,
    id       => generate_account_num(),
    type     => $type,
    user_id  => $id,
    passwd   => generate_initial_passwd(),
  };
  # The new account is then added to the customer's list of accounts...
  push @{ $customer->{accounts} }, $new_account;
  # Make the backlink in the customer's newest account
  # invisible to the garbage collector...
  weaken $customer->{accounts}[-1]{customer};
  return $new_account;
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
# chapter11:Chapter 11, References
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example11.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
