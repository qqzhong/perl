# Card1.pm
package Game::Card1;
use strict;

sub new {
  my ( $class, $name, $suit ) = @_;
  my $self = bless {}, $class;
  $self->{'name'} = $name;
  $self->{'suit'} = $suit;
  return $self;
}
1;
