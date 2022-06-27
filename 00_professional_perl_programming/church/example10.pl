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
  ### 'BEGIN' blocks, 'END' blocks and Other Animals ###

  #    The precise order is:
  #    BEGIN
  #    (compile phase)
  #    CHECK
  #    INIT
  #    (run phase)
  #    END

  ### 'END' Blocks ###
  #    END {
  #    unlink $tempfile;
  #    shutdown $socket, 2;
  #    }

  ### Manipulating Packages ###
  ### Removing a Package ###
  #   my $table = *{'My::Module::'}{'HASH'};
  #   undef %$table;
  #   my $parent = *{'My::'}{'HASH'};
  #   my $success = delete $parent->{'Module::'};

  # use Symbol qw(delete_package);
  # print "Deleted!\n" if delete_package('My::Module');

### Finding a Package Name Programmatically ###
### Autoloading ###
### Autoloading Subroutines ###
  self_aware_sub();
  system('./autoload.pl');

### Using an 'AUTOLOAD' Subroutine as a Substitute ###
  system('./autostat.pl');
  system('./printstat.pl');

### Defining Subroutines On the Fly ###
  system('./autofly.pl');

### Self-Defining Instead of Autoloading Subroutines ###
  system('./autodefine.pl');
  system('./globdefine.pl');

### Autoloading Modules ###
### Using the 'AutoLoader' Module ###
  system('./automoduletest.pl');

  # For example, to autosplit a module from the directory in which it is placed:
  # > perl -MAutoSplit -e 'autosplit "My/AutoModule.pm","./auto"'
  # Again there are slight modifications required for the Windows version of this one line program:
  # > perl -MAutoSplit -e "autosplit\"My/AutoModule.pm\",\"./auto\""

  # > perl -MAutoSplit -e 'autosplit "My/AutoModule.pm","./auto", $keep, $check, $changed'
  # for Windows it is:
  # > perl -MAutoSplit -e "autosplit\"My/AutoModule.pm\",\"./auto\", $keep, $check, $changed"

  # > perl -MAutoSplit -e 'autosplit "My/AutoModule.pm","./auto", 0, 1, 1'
  # Again the equivalent for Windows is:
  # > perl -MAutoSplit -e "autosplit\"My/AutoModule.pm\",\"./auto\", 0, 1, 1"

### Using the 'SelfLoader' Module ###

### Importing and Exporting ###
### Creating Installable Modules ###

  #  Its own unique package name
  #  A version number
  #  Strict mode
  #  Documentation

  # 1)NAME: The package name and brief description
  # 2)SYNOPSIS: Code example of how the module is used
  # 3)DESCRIPTION: A description of what the module does
  # 4)EXPORT: What the module exports
  # 5)SEE ALSO: Any related modules or Perl documentation
  # 6)HISTORY: Optionally, a history of changes

### Creating a Working Directory ###
  # > h2xs -n Installable::Module
  # Makefile.PL
  # test.pl
  # Changes
  # MANIFEST

### Building an Installable Package ###
  #  > perl Makefile.PL
  #  > make dist
### Adding a Test Script ###
### Uploading Modules to CPAN ###
}

sub blocks_pl {
  # blocks.pl
  use warnings;
  use strict;
  $SIG{__DIE__} = sub {
    print "Et tu Brute?\n";
  };
  print "It's alive!\n";
  die "Sudden death!\n";

  BEGIN {
    print "BEGIN\n";
  }

  END {
    print "END\n";
  }
  INIT {
    print "INIT\n";
  }
  CHECK {
    print "CHECK\n";
  }
}

my $fixme = <<'COMMENTED';
sub symbol1_pl {
  # symbol1.pl
  use warnings;
  use Symbol;
  my $fqname = qualify('scalar');
  $$fqname = "Hello World\n";
  print $scalar;    # produces 'Hello World'
}

sub symbol2_pl {
  # symbol2.pl
  use warnings;
  use Symbol;
  my $fqname = qualify( 'scalar', 'My::Module' );
  $$fqname = "Hello World\n";
  print $My::Module::scalar;
}

sub symbol3_pl {
  # symbol3.pl
  use warnings;
  use strict;
  use Symbol;
  my $fqref = qualify_to_ref( 'scalar', 'My::Module' );
  $$fqref = \("Hello World\n");
  print $My::Module::scalar;
}

sub symbol4_pl {
  # symbol4.pl
  use warnings;
  use strict;
  use Symbol;
  my $fqref = qualify_to_ref( 'scalar', 'My::Module' );
  $$fqref = \("Hello World\n");
  print My::Module::get_scalar();

  package My::Module;
  our $scalar;    # provide access to scalar defined above

  sub get_scalar {
    return $scalar;
  }
}
COMMENTED

sub self_aware_sub {
  print "I am in the ", __PACKAGE__, " package.\n";
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
  print " \n    # run time is: $elapsed_time second(s) \n";

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
# chapter10:Chapter 10 Inside Modules and Packages
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example10.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
