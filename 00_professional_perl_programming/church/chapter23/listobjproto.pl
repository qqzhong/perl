#!/usr/bin/perl
# listobjproto.pl
use warnings;
use strict;
use Net::protoent;
while ( my $protocol = getprotoent ) {
  print "Protocol: ", $protocol->proto, "\n";
  print "Name : ",    $protocol->name,  "\n";
  print "Aliases : ", join( ', ', @{ $protocol->aliases } ), "\n\n";
}
