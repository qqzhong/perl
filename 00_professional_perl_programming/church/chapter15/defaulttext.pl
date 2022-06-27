#!/usr/bin/perl
# defaulttext.pl
use warnings;
use strict;
use Term::ReadLine;
my $term  = new Term::ReadLine "Default Input";
my $input = $term->readline( "Enter some text: ", "Default Text" );
print "You entered: $input\n";
