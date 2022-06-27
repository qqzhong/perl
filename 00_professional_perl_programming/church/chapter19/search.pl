#!/usr/bin/perl
# search.pl
use warnings;
use strict;
use IO::File;
use lib '.';
use Document;
my $fh       = new IO::File('file.txt');
my $document = new Document($fh);
# find words containing e or t
print join( ' ', $document->wordsearch('[et]') ), "\n";
