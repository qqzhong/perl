#!/usr/bin/perl
# iothreadserv.pl
use warnings;
use strict;

BEGIN {
  use Config;
  die "No thread support!\n" unless $Config{'usethreads'};
}
use Thread;
use IO::Socket;
# Autoflushing on
$| = 1;
my $port   = 4444;
my $server = IO::Socket->new(
  Domain    => PF_INET,
  Proto     => 'tcp',
  LocalPort => $port,
  Listen    => SOMAXCONN,
  Reuse     => 1,
);
die "Bind failed: $!\n" unless $server;
print "Multiplex server running on port $port...\n";
while ( my $connection = $server->accept ) {
  my $name   = $connection->peerhost;
  my $port   = $connection->peerport;
  my $thread = new Thread( \&connection, $connection, $name, $port );
  print "Created thread ", $thread->tid, " for new client $name:$port\n";
  $thread->detach;
}

# child thread - handle connection
sub connection {
  my ( $connection, $name, $port ) = @_;
  $connection->autoflush(1);
  print $connection "You're connected to the server!\n";
  while (<$connection>) {
    print "Client $name:$port says: $_";
    print $connection "Message received OK\n";
  }
  $connection->shutdown(SHUT_RDWR);
}
