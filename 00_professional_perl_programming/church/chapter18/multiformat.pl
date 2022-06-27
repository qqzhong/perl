#!/usr/bin/perl
# multiformat.pl
use warnings;
use strict;
#set the lines remaining on the default page size
$- = 60;
# define some simple records to demonstrate the technique
my @records = (
  {
    main    => 'This is the first record, with three extra lines of data',
    extra   => [ 'Extra 1', 'Extra 2', 'Extra 3' ],
    comment => 'Each part of the record is printed out using a
different format'
  },
  {
    main  => 'This is the second record, which has only one extra line',
    extra => ['An extra line']
  },
  {
    main    => 'The third record has no extra data at all',
    comment => 'So we switch to a different format and print a special
message instead'
  },
  {
    main  => 'This is the fourth record, with three more extra lines',
    extra => [ 'Extra 4', 'Extra 5', 'Extra 6' ]
  }
);
# define main format for main body of record
format MAIN =
@#: ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_+1, $records[$_]{main}
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~~
$records[$_]{main}
.
# define a format for displaying extra data
format EXTRA =
[ @<<<<<<<<<<<<<<<<<<<<<<<<<<<< ]
$_
.
# define a format for no extra data
format NO_EXTRA =
< No extra data for this record >
.

# define a format for displaying extra data
format COMMENT =
Comment: ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$records[$_]{comment}
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~~
$records[$_]{comment}
.
# iterate through the list of hashes, using extra format when required
foreach ( 0 .. $#records ) {
  # write out the main format
  $~ = 'MAIN';
  write;
  if ( exists $records[$_]{extra} ) {
    # change format
    $~ = 'EXTRA';
    # write out the extra lines
    foreach ( @{ $records[$_]{extra} } ) {
      write;
    }
  } else {
    # change to the no data message format
    $~ = 'NO_EXTRA';
    write;
  }
  $~ = 'COMMENT', write if exists $records[$_]{comment};
}
