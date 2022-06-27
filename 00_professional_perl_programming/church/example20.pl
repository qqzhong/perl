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
  ### Analyzing the Perl Binary – 'Config.pm' ###
  # perl -V

  #1) Fetch $b and put it on the stack.
  #2) Fetch $c and put it on the stack.
  #3) Pop two values off the stack and add them, pushing the value.
  #4) Fetch $a and put it on the stack.
  #5) Pop a value and a variable off the stack and assign the value to the variable.

  # Scalar Variable
  # Pointer Value
  # Integer Value
  # Numeric Value
  # Arrays and Hashes

  # > perl -MDevel::Peek -e '$a = "A Simple Scalar"; Dump($a)'
  # > perl -MDevel::Peek -e '$a = 1; Dump($a); $a.="2"; Dump($a)'
  # > perl -MDevel::Peek -e '$a = 1; Dump($a); $a.="2"; Dump($a); $a += 0.5; Dump($a)'

### Examining Raw Datatypes with 'Devel::Peek' ###
  # > perl -MDevel::Peek -e "Dump(6)"
  # > perl -MDevel::Peek -e '$a=6; Dump($a)
  # > perl -MDevel::Peek -e '@a=(1,[2,sub {3}]); DumpArray(2, @a)'
  # > perl -MDevel::Peek -e '$a="2701"; $a*1; Dump($a)'
  # Or on Windows:
  # > perl -mDevel::Peek -e "$a=q(2701); $a*1; Dump($a)"
  # > perl -MDevel::Peek -e '$a="2701"; $a=int($a); Dump($a)'

### The 'B::' Family of Modules ###

  # > perl -MO=Terse -e '$a = $b + $c'
  # > perl -MO=Terse,exec -e '$a = $b + $c'
  # > perl -MO=Debug -e '$a = $b + $c'
  # > perl -MO=Xref debug.pl
  # > perl -MO=Deparse -e '$a = $b + $c'
  # > perl -MO=Deparse -e '($a == $b or $c) && print "hi";'
  # > perl -MO=Deparse -e 'while(<>){print}'
  # > perl -MO=Deparse -pe 1
  # > perl -MO=Deparse strip.pl

### 'B::C' ###
  # > perlcc hello.pl
  # > perlcc –o hello hello.pl

### 'B::Bytecode' ###
  # > perl -MO=Bytecode hello.pl > hello.plc
  # > perl -MByteLoader hello.plc
  # > perlcc -b -o hello.plc hello.pl

### 'B::Disassembler' ###
  # > perl disassemble hello.plc
  # > perl disassemble hello.plc > hello.S
  # > perl assemble hello.S > hello.plc

### 'B::Lint' ###
  # > perl -MO=Lint,context,undefined-subs program.pl
  # > perl -MO=Lint,all test
  # > perl -MO=Showlex B_Showlex.pl

  # sudo perl -MCPAN -e shell
  # install B::Lint

### 'B::Xref' ###
  # > perl -MO=Xref File
  # > perl -MO=Xref debug.pl

### 'B::Fathom' ###
  # > perl -MO=Fathom xws.perl

### 'B::Graph' ###
  # > perl -MO=Graph,-vcg -e '$a = $b + $c' > graph.vcg

### 'B::JVM::Jasmin' ###
  # > perljvm myprog.pl MyProgram

}

sub example {
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
# chapter20:Chapter 20 Inside Perl
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example20.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
