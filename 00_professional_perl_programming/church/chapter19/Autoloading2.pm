package Autoloading2;
use strict;
use Carp;
my %attrs = map { $_ => 1 } qw(name number rank);

sub new {
  my $class = shift;
  my $self  = bless {}, $class;
  $self->{'_attrs'} = \%attrs;
  return $self;
}

sub _property ($$;$) {
  my ( $self, $attr, $value ) = @_;
  if ($value) {
    my $oldv = $self->{$attr};
    $self->{$attr} = $value;
    return $oldv;
  }
  return $self->{$attr};
}

sub AUTOLOAD {
  our $AUTOLOAD;
  my $attr;
  $AUTOLOAD =~ /([^:]+)$/ and $attr = $1;
  # abort if this was a destructor call
  return if $attr eq 'DESTROY';
  # otherwise, invent a method and call it
  my $self = shift;
  if ( $self->{'_attrs'}{$attr} ) {
    eval "sub $attr {return shift->_property('$attr',\@_);}";
    $self->$attr(@_);
  } else {
    my $class = ( ref $self ) || $self;
    croak "Undefined method $class\:\:$attr called";
  }
}

sub add_attrs {
  my $self = shift;
  map { $self->{'_attrs'}{$_} = 1 } @_;
}
1;
