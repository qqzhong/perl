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
  ### Modules and Packages ###
  ### Loading Code Using 'do', 'require', and 'use' ###
  # do '/home/perl/loadme.pl';

  # include the modern and trendy Getopt::Std library
  # (i.e. PATH/Getopt/Std.pm)
  # require Getopt::Std;

  # include Getopt::Std at compile time
  # use Getopt::Std;

  # BEGIN {
  #   require Getopt::Std;
  # }

### 'import' Lists ###

  # importing a list of symbols with a comma separated list:
  # use Module ('sub1', 'sub2', '$scalar', '@list', ':tagname');
  # it is more legible to use 'qw':
  # use Module qw(sub1 sub2 $scalar @list :tagname);
  # a single symbol can be specified as a simple string:
  # use Module 'sub1';

### Suppressing Default Imports ###
  # use Module; # import default symbols
  # use Module(); # suppress all imports

### Disabling Features with 'no' ###

  # no Module qw(symbol1 symbol2 :tagname);
  # This is equivalent to:
  # BEGIN {
  # require Module;
  # unimport('symbol1', 'symbol2', ':tagname');
  # }

### Testing for Module Versions and the Version of Perl ###
  # require 5.6.0;
  # use 5.6.0;
  # require v5.6.0;

### Pragmatic Modules ###
### How Pragmatic Modules Work ###

### Scope of Pragmatic Modules ###
  pragmascope_pl();

### The Special Hash '%INC' ###
  inc_pl();

### The Special Array '@INC' ###
  printArray( '@INC', @INC );

  ### Modifying '@INC' directly ###
  # perl -I/home/httpd/perl/lib -e 'print join"\n",@INC';

  # add directory to end of @INC
  # push @INC, "/home/httpd/perl/lib";
  # add current directory to start of @INC using the 'getcwd'
  # function of the 'Cwd' module
  # use Cwd;
  # unshift @INC, getcwd();

  # add directory to start of @INC at compile time
  # BEGIN {
  # unshift @INC, '/home/httpd/perl/lib';
  # }

  ### Modifying @INC with the 'lib' Pragma ###
  # use lib '/home/httpd/perl/lib';
  # no lib 'home/httpd/perl/lib';

  # we can restore the original value of @INC as built in to Perl with the statement:
  # @INC = @lib::ORIG_INC;

  ### Locating Libraries Relative to the Script ###
  #  Variable Path information
  # $Bin The path to the directory from which the script was run
  # $Dir An alias for $Bin
  # $Script The name of the script
  # $RealBin The real path to the directory from which the script was run, with all symbolic links resolved
  # $RealDir An alias for $RealBin
  # $RealScript The real name of the script, with all symbolic links resolved.

### Checking for the Availability of a Module ###

  # if ($INC{'Module1'}) {
  #   use some functions from Module1
  # } elsif ($INC{'Module2'}) {
  #   use some functions from Module2
  # }

  # warn "GD module not available" unless eval {require GD; 1};

  #  BEGIN {
  #  foreach ('GD', 'CGI', 'Apache::Session') {
  #  warn "$_ not available" unless eval "use $_; 1";
  #  }
  #  }

### Finding Out What Modules are Installed ###
  # use ExtUtils::Installed;
  # my $inst = ExtUtils::Installed->new();
  # list all installed modules;
  # print join "\n", $inst->modules();
  installedfiles_pl();

### Postponing Module Loading Until Use ###
  # use autouse 'Module' => qw(sub1 sub2 Module::sub3);
}

sub pragmascope_pl {
  # pragmascope.pl
  use warnings;
  use strict;
  # a subroutine to be called by name
  sub my_sub {
    print @_;
  }
  # a subroutine to call other subroutines by name
  sub call_a_sub {
    # allow symbolic references inside this subroutine only
    no strict 'refs';
    my $sub = shift;
    # call subroutine by name - a symbolic reference
    &$sub(@_);
  }
  # all strict rules in effect here
  call_a_sub( 'my_sub', "Hello pragmatic world \n" );
}

sub inc_pl {
  # INC.pl
  use strict;
  print "\%INC contains: \n";
  foreach ( keys %INC ) {
    print " $INC{$_}\n";
  }
  require File::Copy;
  do '/home/perl/include.pl';
  print "\n\%INC now contains: \n";
  foreach ( keys %INC ) {
    print " $INC{$_}\n";
  }
}

sub installedfiles_pl {
  # installedfiles.pl
  use warnings;
  use strict;
  use ExtUtils::Installed;
  my $inst = new ExtUtils::Installed;
  foreach my $package ( $inst->modules ) {
    my $valid   = $inst->validate($package) ? "Failed" : "OK";
    my $version = $inst->version($package);
    $version = 'UNDEFINED' unless defined $version;
    print "\n\n--- $package v$version [$valid] ---\n\n";
    if ( my @source = $inst->files( $package, 'prog' ) ) {
      print "\t", join "\n\t", @source;
    }
    if ( my @docs = $inst->files( $package, 'doc' ) ) {
      print "\n\n\t", join "\n\t", @docs;
    }
  }
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
# chapter09:Chapter 9 Using Modules
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example09.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
