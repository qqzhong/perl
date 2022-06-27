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
  ### Intercepting Warnings and Errors ###
  # $SIG{__WARN__} = sub{print WARNLOG, "$0 warning: ", @_, "\n"};
  # $SIG{__WARN__} = sub{warn "$0 warning: ", @_;};

  # $SIG{__DIE__} = sub {
  # # send real message to log file
  # print LOGFILE "Died: @_";
  # # Give the user something flowery
  # die "Oh no, not again";
  # }

  ### Deciphering Error Results from System Calls ###

  # use Errno qw(EAGAIN);
  # if ($!) {
  # # check for EAGAIN in numeric comparison
  # sleep(1), redo if $! == EAGAIN;
  # # die, using $! in string context
  # die "Fatal error: $!\n";
  # }

### Checking the Exit Status of Subprocesses and External Commands ###
  # my $exitcode = $? >> 8; # exit code
  # my $exitsignal = $? & 127; # signal that caused exit

  my $result = system(@args);
  if ( my $signal = $? & 127 ) {
    warn "External command exited on signal $signal\n";
  } elsif ( our $! = $? >> 8 ) {
    # assign $! numerically
    $! = $exitcode;
    # display it textually
    warn "External command existed with error: $!\n";
  }

### Making Non-Fatal Errors Fatal ###
  # use Fatal qw(print open close sysopen);
  # use Fatal qw(mysubroutine);

### Returning Warnings and Errors in Context with 'Carp' ###
  # perl -MCarp=verbose myscript.pl

### Error Logs and System Logs ###

  # use Sys::Syslog;

  # syslog('debug', 'This is a debug message');
  # syslog('info', 'Testing, Testing, %d %d %d', 1, 2, 3);
  # syslog('news|warning', 'News unavailable at %s', scalar(localtime));
  # syslog('error', "Error! $!");

### Advanced Warnings ###
  use warnings qw(all);

  # no warnings qw(void);
  # no warnings 'void';
  # no warnings 'untie';
  # no warnings 'uninitialized';
  # use warnings 'untie';
  # no warnings qw(void uninitialized);

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
# chapter16:Chapter 16 Warnings and Errors
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example16.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
