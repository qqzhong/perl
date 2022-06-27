# My/AutoModule.pm
package My::AutoModule;
use strict;
use Exporter;
use AutoLoader qw(AUTOLOAD);
our @ISA    = qw(Exporter);
our @EXPORT = qw(zero one two three);

sub one {
  print "This is always compiled\n";
}
__END__

sub two {
  print "This is sub two\n";
}

sub three {
  print "This is sub three\n";
}
1;
