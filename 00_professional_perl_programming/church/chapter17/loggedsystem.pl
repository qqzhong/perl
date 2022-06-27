#!/usr/bin/perl
# loggedsystem.pl
use warnings;
use strict;
use Safe;
my $compartment = new Safe;
$compartment->deny( 'system', 'backtick' );
use subs qw(system);

sub system {
  warn "About to execute: @_ \n";
  CORE::system @_;
}
# offer our 'system' to the compartment
$compartment->share('&system');
# test line to prove compartment is working
$compartment->reval('system("ls")');
$compartment->reval('CORE::system("ls")');
warn $@ if $@;
# process command-line
foreach (@ARGV) {
  die "'$_' not found or not executable \n" unless -x;
  $compartment->rdo($_);
  warn $@ if $@;
}
