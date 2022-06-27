#!/usr/bin/perl
# arrayuse.pl
use warnings;
use strict;
use lib '.';
use Game::Card2;    # imports 'NAME' and 'SUIT'
#BEGIN { push @INC, '.' }
my $card = new Game::Card2( 'Ace', 'Spades' );
print $card->[NAME];    # produces 'Ace'
$card->[SUIT] = 'Hearts';    # change card to the Ace of Hearts
print " of ", $card->[SUIT], "\n";    # produces ' of Hearts'
