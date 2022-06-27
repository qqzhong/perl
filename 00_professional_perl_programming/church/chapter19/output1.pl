#!/usr/bin/perl
# output1.pl
use warnings;
use strict;
use IO::File;
my $object_fh = new IO::File('> /tmp/io_file_demo');
$object_fh->print("An OO print statement\n");
print $object_fh "Or we can use the object as a filehandle";
$object_fh->autoflush(1);    # this is much nicer than 'selecting'
close $object_fh;
