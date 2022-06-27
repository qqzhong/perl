# AddressMap.pm
use strict;
use Class::Struct;
struct Address => {
  map { $_ => '$' }
    qw(
    name house street city state country postcode)
};
1;
