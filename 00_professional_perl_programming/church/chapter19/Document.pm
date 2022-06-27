# Document.pm
package Document;
use strict;
# scalar constructor
sub new {
  my $class = shift;
  my $self  = \$_;     #Can't bless non-reference value
  if ( my $fh = shift ) {
    local $/ = undef;
    $$self = <$fh>;
  }
  return bless $self, $class;
}
# search a document object
sub search {
  my ( $self, $pattern ) = @_;
  my @matches = $$self =~ /$pattern/sg;
  return @matches;
}
# search and return words
sub wordsearch {
  my ( $self, $wordbit ) = @_;
  my $pattern = '\b\w*' . $wordbit . '\w*\b';
  return $self->search($pattern);
}
1;
