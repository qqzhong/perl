# MySerial.pm
package MySerial;
use strict;
use Serial;
our @ISA = qw(Serial);
my $next = 1;
my $plus = 1;

sub new {
  my $class = shift;
  # call Serial::new
  my $self = $class->SUPER::new(@_);
  # override parent serial with our own
  $self->{'serial'} = $next;
  # replace class data references
  $self->{'_next'} = \$next;
  $self->{'_incr'} = \$plus;
  # add a creation time
  $self->{'time'} = time;
  return $self;
}

sub time {
  return shift->{'time'};
}
1;
