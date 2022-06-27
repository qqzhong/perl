#!/usr/bin/perl
# sort.pl
use warnings;
use strict;
use POSIX qw(LC_COLLATE setlocale strcoll);
setlocale( LC_COLLATE, 'es_US' );
print sort { strcoll( $a, $b ); } <>;
