#!/usr/bin/perl
# password.pl
use warnings;
use strict;
use Text::ParseWords;
@ARGV = ('/etc/passwd');
my @users = nested_quotewords( ':', 0, <> );
print scalar(@users), " users: \n";
foreach (@users) {
  print "\t${$_}[0] => ${$_}[2] \n";
}
