#!/usr/bin/perl
# autol.pl
use warnings;
use strict;
use lib '.';
use Autoloading;
my $object = new Autoloading;
$object->name('Styglian Enumerator');
$object->number('say 6');
print $object->name, " counts ", $object->number, "\n";
