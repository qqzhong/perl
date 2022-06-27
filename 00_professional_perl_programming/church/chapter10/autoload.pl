#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# autoload.pl
use warnings;
use strict;

print(qx(date));

sub AUTOLOAD {
  our $AUTOLOAD;    # " use vars '$AUTOLOAD'" for Perl < 5.6
  $" = ',';
  print "You called '$AUTOLOAD(@_)'\n";
}
fee( 'fie', 'foe', 'fum' );
testing( 1, 2, 3 );
#", for humanized;

exit 0;
