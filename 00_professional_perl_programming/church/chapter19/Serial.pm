# extract from Serial.pm
package Serial;
use strict;
use Carp;
our %conf = (
  'start'     => 1,
  'increment' => 1,
);

sub new {
  my $class = ( ref $_[0] ) || $_[0];
  $conf{'start'} = $_[1] if defined $_[1];
  my $self = bless {}, $class;
  $self->{'serial'} = $conf{'start'};
  $conf{'start'} += $conf{'increment'};
  return $self;
}

sub serial {
  return shift->{'serial'};
}

sub next ($;$) {
  my ( $self, $new ) = @_;
  ${ $self->{'_next'} } = $new if $new;
  return ${ $self->{'_next'} };
}

# destructor for 'Serial' class ...
sub DESTROY {
  my $self = shift;
  print STDERR ref($self), " serial no ", $self->serial, " destroyed\n";
}
1;
