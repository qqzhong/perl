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
  ### Building a Program (The Hard Way) ###

# $  perl -V:cc
# cc='x86_64-linux-gnu-gcc';
# $  perl -V:ld
# ld='x86_64-linux-gnu-gcc';
# $  perl -V:archlib
# archlib='/usr/lib/x86_64-linux-gnu/perl/5.30';
# $  perl -V:libperl
# libperl='libperl.so.5.30';
# $  perl -V:libs
# libs='-lgdbm -lgdbm_compat -ldb -ldl -lm -lpthread -lc -lcrypt';
# $  perl -V:ccflags
# ccflags='-D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fwrapv -fno-strict-aliasing -pipe -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64';
# $  perl -V:ldflags
# ldflags=' -fstack-protector-strong -L/usr/local/lib';

  #  gcc program.c -fno-strict-aliasing -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
  #  -I/usr/local/perl-5.6/lib/5.6.0/i686-linux/CORE
  #  /usr/local/perl-5.6/lib/5.6.0/i686-linux/CORE/libperl.a
  #  -L/usr/local/lib -lnsl -lndbm -lgdbm -ldb -ldl -lm -lc -lposix -lcrypt

### Building a Program (The Easy Way) ###
  # > perl -MExtUtils::Embed -e ccopts -e ldopts
  # > -rdynamic -L/usr/local/lib
  # > gcc -o program program.c 'perl -MExtUtils::Embed -e ccopts -e ldopts'
  # > perl genmake program.c
  # > make

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
# chapter21:Chapter 21 Integrating Perl with Other Programming Languages
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example21.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
