#!/usr/bin/perl
# closure.pl
use warnings;
use strict;
use lib '.';
use Closure;
my $object = new Closure;
$object->size(10);
$object->weight(1.4);
$object->shape('pear');
print "Size:", $object->size, " Weight:", $object->weight, " Shape:", $object->shape, "\n";
print "Also size:", &$object('size'), "\n";
