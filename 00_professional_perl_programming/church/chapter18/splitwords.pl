#!/usr/bin/perl
# splitwords.pl
use warnings;
use strict;
my @words;
push @words, split foreach (<>);
print scalar(@words), "words: @words \n";
