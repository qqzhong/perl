#!/usr/bin/perl
# tcpioinetclient.pl
use warnings;
use strict;
use IO::Socket;
my $host   = 'localhost';
my $port   = 4444;
my $server = IO::Socket->new(
  Domain   => PF_INET,
  Proto    => 'tcp',
  PeerAddr => $host,
  PeerPort => $port,
);
die "Connect failed: $!\n" unless $server;
# communicate with the server
print "Client connected.\n";
print "Server says: ", scalar(<$server>);
print $server "Hello from the client!\n";
print $server "And goodbye!\n";
close $server;

