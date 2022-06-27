#!/usr/bin/perl
# getfldnet.pl
use warnings;
use strict;
use Net::netent qw(:FIELDS);
use Socket qw(inet_ntoa);
my @nets;
while ( my $net = CORE::getnetent ) {
  push @nets, $net;
}
while ( my $net = shift @nets ) {
  $net = getnetbyname($net);
  print 'Name : ', $n_name,     "\n";
  print 'Type : ', $n_addrtype, "\n";
  print 'Aliases : ', join( ', ', @n_aliases ), "\n";
  print 'Addresses: ', $n_net, "\n\n";
}
