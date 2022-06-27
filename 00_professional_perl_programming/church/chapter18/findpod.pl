#!/usr/bin/perl
# findpod.pl
use warnings;
use strict;
use Pod::Find qw(pod_find);
use Getopt::Long;
# default options
my $verbose = undef;
my $include = undef;
my $scripts = undef;
my $display = 1;
# allow files/directories and options to mix
Getopt::Long::Configure('permute');
# get options
GetOptions(
  'verbose!' => \$verbose,
  'include!' => \$include,
  'scripts!' => \$scripts,
  'display!' => \$display,
);
# if no directories specified, default to @INC
$include = 1 if !defined($include) and ( @ARGV or $scripts );
# perform scan
my %pods = pod_find(
  {
    -verbose => $verbose,
    -inc     => $include,
    -script  => $scripts,
    -perl    => 1
  },
  @ARGV
);
# display results if required
if ($display) {
  if (%pods) {
    foreach ( sort keys %pods ) {
      print "Found '$pods{$_}' in $_\n";
    }
  } else {
    print "No pods found\n";
  }
}
