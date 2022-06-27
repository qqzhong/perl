#!/usr/bin/perl
# debug.pl
use warnings;
use strict;
# define a debugging infrastructure
{
  my $debug_level = $ENV{'DEBUG'};
  $debug_level |= 0;    # set if unset
                        # return and optionally set debug level

  sub debug_level {
    my $old_level = $debug_level;
    $debug_level = $_[0] if @_;
    return $old_level;
  }
  # print debug message or set debug level
  sub debug {
    # remove first argument, if present
    my $level = shift;
    # @_ will contain more elements if 2+ arguments passed
    if (@_) {
      # 2+ argument calls print debug message if permitted
      print STDERR @_, "\n" if $level <= debug_level();
    } else {
      # one and no-argument calls set level
      debug_level( $level ? $level : 1 );
    }
  }
}
