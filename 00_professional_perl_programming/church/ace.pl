#!/usr/bin/perl
# ace.pl
use warnings;
use strict;
use lib '.';
use Game::Card1;
#BEGIN { push @INC, '.' }
my $card = new Game::Card1( 'Ace', 'Spades' );
print $card->{'name'}, "\n";    # produces 'Ace';
$card->{'suit'} = 'Hearts';     # change card to the Ace of Hearts
print $card->{'suit'}, "\n";    # produces 'Hearts';
