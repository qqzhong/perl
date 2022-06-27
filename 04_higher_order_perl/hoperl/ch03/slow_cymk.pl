#!/usr/bin/perl

use Time::HiRes qw(time);

# generate a slow version of RGB to CYMK, as part of the caching and memoization chapter of HOP

sub RGB_to_CYMK {
    my ($r, $g, $b) = @_;
    my ($c, $m, $y) = (255-$r, 255-$g, 255-$b);
    my $k = $c < $m ? ($c < $y ? $c : $y) : ($m < $y ? $m : $y);
    for ($c, $m, $y) { $_ -= $k}
    return "$c $y $m $k";
}

my $start = time();

print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");
print (RGB_to_CYMK(184, 90, 64) . "\n");

print (RGB_to_CYMK(0, 255, 255) . "\n");

my $end = time();

#strecting this out to five decimal points at least shows you the time taken.  If we were to add 1,000+ lines or so and compare with cache_cymk, we would probably see a greater speed difference.

printf("%.5f\n", $end - $start );
