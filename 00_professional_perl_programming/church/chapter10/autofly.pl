#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG
# autofly.pl
use warnings;
use strict;

print(qx(date));

sub AUTOLOAD {
  our $AUTOLOAD;
  my $tag;
  $AUTOLOAD =~ /([^:]+)$/ and $tag = $1;
SWITCH: foreach ($tag) {
    /^start_(.*)/ and do {
      eval "sub $tag { return \"<$1>\@_\" }";
      last;
    };
    /^end_(.*)/ and do {
      eval "sub $tag { return \"</$1>\" }";
      last;
    };
    eval "sub $tag { return \"<$tag>\@_</$tag>\" }";
  }
  no strict 'refs';
  &$tag;
}
# generate a quick HTML document
print html( head( title('Autoloading Demo') ), body( ul( start_li('First'), start_li('Second'), start_li('Third'), ) ) );
print "\n";

exit 0;
