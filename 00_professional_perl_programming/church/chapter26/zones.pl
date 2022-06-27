#!/usr/bin/perl
# zones.pl
use warnings;
use strict;
use Time::Zone;
use POSIX;
die "Usage = $0 City Zone \n" if $#ARGV < 1;
my ( $city, $zone ) = @ARGV;
$ENV{TZ} = "$zone/$city";
tzset();
my ( $thisTZ, $thisDST ) = tzname();
my $offset = tz_offset($thisTZ);
my ( $sec, $min, $hour ) = localtime( time + $offset );
print qq(You are in zone $thisTZ
Difference with respect to GMT is ), $offset / 3600, qq( hours
And local time is $hour hours $min minutes $sec seconds
);
