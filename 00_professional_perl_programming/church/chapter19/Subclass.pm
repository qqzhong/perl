#!/usr/bin/perl
# Autoloading::Subclass
package Autoloading::Subclass;
use warnings;
use strict;
use Autoloading;
our @ISA = qw(Autoloading);
my @attrs = qw(size location);

sub new {
  my $class = shift;
  my $self  = $class->SUPER::new();
  $self->add_attrs(@attrs);
  return $self;
}
1;
