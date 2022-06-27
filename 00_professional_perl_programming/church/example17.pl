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
### Pragmatic Debugging Support ###

  # use strict vars – variables must be declared with my or our or written explicitly as package variables.
  # use strict subs – barewords are not allowed because of their possible conflict with subroutine names.
  # use strict refs – symbolic references are prohibited.

### Creating Debug Logs ###
  # DEBUG=1 perl myscript.pl 2> error.log
  # DEBUG=1 DEBUG_LOG="error.log" perl myscript.pl

  # set DEBUG=1; perl myscript.pl 2> error.log
  # set DEBUG=1; set DEBUG_LOG="error.log"; perl myscript.pl

### Starting the Debugger ###
  # perl -d mybuggyscript.pl
  # perl -Twd mybuggyscript.pl
  # perl -dwe 1;
  # perl -d:DProf rapidoffensiveunit.pl
  # perl -d config.pl

### Debugging the Perl Interpreter ###

  # 1 p Tokenizing and parsing
  # 2 s Stack snapshots
  # 4 l Context (loop) stack processing
  # 8 t Trace execution
  # 16 o Method and overloading resolution
  # 32 c String/numeric conversions
  # 64 P Print preprocessor command for -P
  # 128 m Memory allocation
  # 256 f Format processing
  # 512 r Regular expression parsing and execution
  # 1024 x Syntax tree dump
  # 2048 u Tainting checks
  # 4096 L Memory leaks (only if Perl was compiled with -DLEAKTEST)
  # 8192 H Hash dump – usurps values()
  # 16384 X Scratchpad allocation
  # 32768 D Cleaning up
  # 65536 S Thread synchronization

  #    > perl -Dst ...
  #    > perl -Dts ...
  #    > perl -D10 ...

### Automated Testing ###
### Writing a Test Script ###

### Profiling ###
### Profiling Perl Applications ###
  # > perl -d:DProf myscript.pl
  # Generating Profile Reports
  # > perl -d:DProf myscript.pl; dprofpp
  # or > dprofpp -p myscript.pl

### Testing for Performance ###

  # sudo perl -MCPAN -e shell
  # install less

  use Benchmark;
  my $start = new Benchmark;
  # ...do time consuming things...
  sleep 1;
  my $finish     = new Benchmark;
  my $difference = timediff( $finish, $start );
  print "Time taken: ", timestr($difference), "\n";
  print timestr Benchmark::timesum( $finish, $start );
  print "\n";

  # need to import 'timesum' and therefore also 'timediff' and 'timestr'
  # use Benchmark qw(timesum timediff timestr);

  # use 'timesum' via package, no need to import 'timediff' or 'timestr'
  # use Benchmark;
  # print timestr Benchmark::timesum ($difference1, $difference2);

### timeit ###
  # time one thousand iterations of '2**rand'
  # $result = timeit(1000, "2**rand");

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
# chapter17:Chapter 17 Debugging
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example17.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
