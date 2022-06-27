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

sub ro {
  ### Throw exceptions instead of returning special values or setting flags. ###
  ### Make failed builtins throw exceptions too. ###
  ### Make failures fatal in all contexts. ###
  ### Be careful when testing for failure of the system builtin. ###
  ### Throw exceptions on all failures, including recoverable ones. ###
  ### Have exceptions report from the caller’s location, not from the place where they were thrown. ###
  ### Compose error messages in the recipient’s dialect. ###
  ### Document every error message in the recipient’s dialect. ###
  ### Use exception objects whenever failure data needs to be conveyed to a handler. ###
  ### Use exception objects when error messages may change. ###
  ### Use exception objects when two or more exceptions are related. ###
  ### Catch exception objects in most-derived-first order. ###
  ### Build exception classes automatically. ###
  ### Unpack the exception variable in extended exception handlers. ###

  locate_and_open('dummy.txt');
  open1();
  open2();
  open3();
  open4();
  open5();
  systemic();
  # recoverable();
  errors();
  # compose_error();
}

sub load_header_from { return "header\n"; }
# Find and open a file by name, returning the filehandle
# or throwing an exception on failure...
sub locate_and_open {
  my ($filename) = @_;
  my @DATA_DIRS = ('.');
  # Check acceptable directories in order...
  for my $dir (@DATA_DIRS) {
    my $path = "$dir/$filename";
    # If file exists in an acceptable directory, open and return it...
    if ( -r $path ) {
      open my $fh, '<', $path
        or croak("Located $filename at $path, but could not open");
      return $fh;
    }
  }
  # Fail if all possible locations tried without success...
  croak("Could not locate $filename");
}

sub open1 {
  my @source_files = ('dummy.txt');
  # and later...
  for my $filename (@source_files) {
    my $fh   = locate_and_open($filename);
    my $head = load_header_from($fh);
    print $head;
    close $fh;
  }
}

sub open2 {
  my @source_files = ('dummy.txt');
  for my $filename (@source_files) {
    if ( my $fh = eval { locate_and_open($filename) } ) {
      my $head = load_header_from($fh);
      print $head;
      close $fh;
    } else {
      carp "Couldn't access $filename. Skipping it\n";
    }
  }
}

sub open3 {
  my @directory_path = ('.');
  for my $filename (@directory_path) {
    # Just ignore any source files that don't load...
    eval {
      my $fh   = locate_and_open($filename);
      my $head = load_header_from($fh);
      print $head;
      close $fh;
    }
  }
}

sub open4 {
  use Fatal qw( open close );
  my $filename = 'dummy.txt';
  my $results  = "dummy\n";
  open my $fh, '>', $filename;
  print {$fh} $results;
  close $fh;
}

sub open5 {
  # Load subroutine to find and open a file by name
  # (Unfortunately, we're stuck with using the original version,
  # which returns false on failure.)
  # use Our::Corporate::File::Utilities qw( locate_and_open );
  # So change that unacceptable failure behaviour to throw exceptions instead...
  use Fatal qw( locate_and_open );
  # and later...
  my @source_files = ('.');
  for my $filename (@source_files) {
    my $fh   = locate_and_open($filename);    # Now throws exception on failure
    my $head = load_header_from($fh);
    print $head;
    close $fh;
  }
}

sub systemic {
  use POSIX qw( WIFEXITED );
  my $cmd      = 'date';
  my $OS_ERROR = 'error';
  # And later...
  WIFEXITED( system $cmd)
    or croak "Couldn't run: $cmd ($OS_ERROR)";
}
sub fibonacci { return 1; }
sub nap       { print "@_\n"; }

sub recoverable {
  Readonly my $MAX_TRIES => 10;
  my $EVAL_ERROR  = 'error';
  my $resource    = 0;
  my $resource_id = 0;
TRY:
  for my $try ( 1 .. $MAX_TRIES ) {
    # If resource successfully acquired, we're done...
    eval {
      $resource = acquire_resource($resource_id);
      print("resource=$resource\n");
      last TRY;
    };
    # Report non-recoverable failure if no more tries
    croak($EVAL_ERROR) if $try == $MAX_TRIES;
    # Otherwise, try again after an increasing randomized interval...
    nap( rand fibonacci($try) );
  }
  # do_something_using($resource);
}

sub errors {
  Readonly my $min => 0;
  Readonly my $max => 10;
  my $result = 0;

  croak "Internal error: somehow generated an inconsistent result ($result)"
    if $result < $min || $result > $max;
  return $result;
}

sub compose_error {
  my $filename  = 'dummy.txt';
  my @tag_stack = ( '1', '2' );
  my $context   = 0;
  # And throw an exception explaining what/why/where/whence...
  croak(
    qq{File '$filename' is not valid DAXML.\n},
    qq{Missing "$tag_stack[-1]" tag.\n},
    qq{Problem detected near "$context".\n},
    qq{Failed},
  );
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
# chapter13:Chapter 13, Error Handling
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example13.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
