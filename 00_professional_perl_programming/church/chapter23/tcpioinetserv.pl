#!/usr/bin/perl
# tcpioinetserv.pl
use warnings;
use strict;
use IO::Socket;
my $port   = 4444;
my $server = IO::Socket->new(
  Domain    => AF_INET,
  Proto     => 'tcp',
  LocalPort => $port,
  Listen    => SOMAXCONN,
);
print "Server running on port $port...\n";
while ( my $connection = $server->accept ) {
  print "Client connected at ", scalar(localtime), "\n";
  print $connection "You're connected to the server!\n";
  while (<$connection>) {
    print "Client says: $_";
  }
  close $connection;
  print "Client disconnected\n";
}
