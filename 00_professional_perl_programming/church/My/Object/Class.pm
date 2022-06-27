#Class.pm
package My::Object::Class;
use strict;

sub new {
  $self = {};      # create a reference to a hash
  bless $self;     # mark reference as object of this class
  return $self;    # return it.
}
