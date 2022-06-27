#!/usr/bin/perl
# auto2.pl
use warnings;
use strict;
use Autoloading;
my $object = new Autoloading;
$object->name('Styglian Enumerator');
$object->number('say 6');
$object->size('little');    # ERROR
print $object->name, " counts ", $object->number, "\n";
print "It's a ", $object->size, " one.\n";
