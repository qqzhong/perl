#!/usr/bin/perl
# getobjnet.pl
use warnings;
use strict;
use Net::netent;
use Socket qw(inet_ntoa);
my @nets;
while ( my $net = CORE::getnetent ) {
  push @nets, $net;
}
while ( my $net = shift @nets ) {
  $net = getnetbyname($net);
  print 'Name : ', $net->name,     "\n";
  print 'Type : ', $net->addrtype, "\n";
  print 'Aliases : ', join( ', ', @{ $net->aliases } ), "\n";
  print 'Addresses: ', $net->addr_list, "\n\n";
}
