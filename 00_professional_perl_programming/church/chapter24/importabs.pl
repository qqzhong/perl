#!/usr/bin/perl
# importabs.pl
use warnings;
use strict;
use Socket qw(:DEFAULT :crlf);
{
  local $/ = $LF;
  while (<$socket>) {
    s/$CR?$LF/\n/;    # not sure if CRLF or LF
    ...;
  }
}
