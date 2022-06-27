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
  ### Flexibly Installing Signal Handlers ###

  # %SIG = (%SIG, INT => IGNORE, PIPE = \&handler, HUP => \&handler);

### Sending Signals ###

  # tell kids to stop hogging the line
  # kill 'INT', @mychildren;
  # a more pointed syntax
  # kill INT => @mychildren, $grandpatoo;
  # commit suicide (die would be simpler)
  # kill KILL => $$; # $$ is our own process ID
  # kill (9, $$); # put numerically
  # send our parent process a signal
  # kill USR1 => getppid

### Alarms ###

  # set an alarm for sixty seconds from now
  alarm 60;
  # cancel alarm
  alarm 0;

  print qx(date);
  $SIG{ALRM} = \&alarmhandler;
  alarm 1;
  print qx(date);

  ### Process IDs ###
  print "We are process $$\n";

  my $parent = getppid;
  print "Our parent is $parent \n";
  # kill "HUP", $parent;

  my $pgid = getpgrp $$;
  print("group = $pgid\n");
  $pgid = getpgrp 0;
  print("group = $pgid\n");
  $pgid = getpgrp;
  print("group = $pgid\n");

### Waiting for an Only Child ###
  # fork a child and execute an external command in it
  my @command = ( 'sleep', '3' );
  exec @command unless fork;
  print "wait...\n";
  # wait for the child to exit
  my $child_pid = wait;
  my $exitsig   = $? & 0xff;    # signal is lower 8 bits
  my $exitcode  = $? >> 8;      # exit code is upper 8 bits
  print "exit: $exitsig, $exitcode\n";

  print "done\n";

  # use POSIX qw(:sys_wait_h);
  # $exitsig = WSTOPSIG($?);
  # $exitcode = WEXITSTATUS($?);

}

sub alarmhandler {
  print "Alarm at ", scalar(localtime), "\n";
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
# chapter22:Chapter 22 Creating and Managing Processes
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example22.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
