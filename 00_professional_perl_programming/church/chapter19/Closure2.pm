# Closure2.pm
package Closure;
use strict;
use Carp;
my @attrs = qw(size weight shape);

sub new {
  my $class = shift;
  $class = ( ref $class ) || $class;
  my %attrs  = map { $_ => 1 } @attrs;
  my $object = sub {
    return _property_sub( \%attrs, @_ );
  };
  return bless $object, $class;
}

sub _property_sub {
  my ( $href, $attr, $value ) = @_;
  unless ( exists $href->{$attr} ) {
    croak "Attempt to ", ( defined $value ) ? "set" : "get", " invalid attribute '$attr'";
  }
  if ( defined $value ) {
    my $oldv = $href->{$attr};
    $href->{$attr} = $value;
    return $oldv;
  }
  return $href->{$attr};
}
# generate attribute methods for each valid attribute
foreach my $attr (@attrs) {
  eval "sub $attr {\$_[0]('$attr', \$_[1]);}";
}
1;
