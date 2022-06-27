#!/usr/bin/perl
# addressmap.pl
use warnings;
use strict;
use lib '.';
use AddressMap;
my $address = new Address(
  name   => 'Me Myself',
  house  => 'My House',
  street => '123 My Street',
  city   => 'My Town',
);
print $address->name, " lives at:\n",
  "\t",              $address->house,  "\n",
  "\t",              $address->street, "\n",
  "in the city of ", $address->city,   "\n";
