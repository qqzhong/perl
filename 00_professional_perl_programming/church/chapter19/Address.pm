# Address.pm
package Address;
use strict;
use Class::Struct;
struct(
  name     => '$',
  address  => '@',
  postcode => '$',
  city     => '$',
  state    => '$',
  country  => '$',
);
1;
