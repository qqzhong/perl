#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# printstat.pl
use warnings;
use strict;
use Carp;

sub AUTOLOAD {
  our $AUTOLOAD;
  my $subname;
  $AUTOLOAD =~ /([^:]+)$/ and $subname = $1;
  my $print;
  $subname =~ s/^print_// and $print = 1;
  my $result;
SWITCH: foreach ($subname) {
    /^sum$/ and do {
      $result = 0;
      map { $result += $_ } @_;
      last;
    };
    /^average$/ and do {
      $result = 0;
      map { $result += $_ } @_;
      $result /= scalar(@_);
      last;
    };
    /^biggest$/ and do {
      $result = shift;
      map { $result = ( $_ > $result ) ? $_ : $result } @_;
      last;
    };
    /^smallest$/ and do {
      $result = shift;
      map { $result = ( $_ < $result ) ? $_ : $result } @_;
      last;
    }
  }
  croak "Undefined subroutine $subname called" unless defined $result;
  print ucfirst($subname), ": $result\n" if $print;
  return $result;
}
my @values = ( 1, 4, 9, 16, 25, 36 );
print_sum(@values);
print_average(@values);
print_biggest(@values);
print_smallest(@values);

print(qx(date));
exit 0;
