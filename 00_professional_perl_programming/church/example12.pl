#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;
use utf8;
use Time::HiRes qw( time );
use File::Spec;
my $sep = '/';

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s }
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s }
sub trim  { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s }

sub open_filehandle_for_write {
  my $filename = $_[0];
  local *FH;
  use open ':encoding(UTF-8)';
  open( FH, '>', $filename ) || die "Could not open $filename";
  binmode FH, ":encoding(UTF-8)";
  return *FH;
}

sub open_filehandle_for_read {
  my $filename = $_[0];
  local *FH;
  open( FH, $filename ) || die "Could not open $filename";
  return *FH;
}

sub get_abs_path {
  # best code, get file true path.
  my $path_curf = File::Spec->rel2abs(__FILE__);
  # print ("# file in PATH = $path_curf\n");
  my ( $vol, $dirs, $file ) = File::Spec->splitpath($path_curf);
  # print ("# file in Dir = $dirs\n");
  return $dirs;
}

sub printArray {
  my $name = shift;
  print "${name}:[";
  foreach my $e (@_) {
    print "$e,"    if defined $e;
    print "undef," if !defined $e;
  }
  print "]\n";
}

sub printHash {
  my $name = shift;
  my $hRef = shift;
  print "${name}:{";
  foreach my $k ( keys %{$hRef} ) { print "$k => ${$hRef}{$k},"; }
  print "}\n";
}

sub ro {
  ### IO and Filehandles ###
### The Filehandle Data Type ###

  # open MYHANDLE, ">$file"; # open file for writing
  # open MYHANDLE, "> $file"; # the same, with optional spacing added
  # open MYHANDLE, ">>$file"; # open file for appending

  #    'open' Mode 'fopen' mode 'sysopen' flags
  #    <            r O_RDONLY
  #    >            w O_WRONLY | O_CREAT | O_TRUNC
  #    >>           a O_WRONLY | O_APPEND | O_CREAT
  #    +<           r+ O_RDWR
  #    +>           w+ O_RDWR |O_CREAT | O_TRUNC
  #    +>>          a+ O_RDWR |O_APPEND | O_CREAT

  # system("perl planets.pl");

### Redefining the Line Separator ###
  # undef $/;
  # $file = <MYHANDLE>; # read entire file as one scalar

  # while (<MYHANDLE>) {
  # /$searchpattern/ and print "$.: $_ \n";
  # }

  # @lines = <MYHANDLE>;
  # print "$. lines read \n";

### Finer Control Over Reading ###
  # read MYHANDLE, $text, 60; # attempt to read 60 bytes into $text

### Detecting the End-of-File ###
  # print "No more to read\n" if ( eof STDIN );

### Buffering and Autoflush Mode ###
  #  $| = 1; # set line buffering, 'autoflush' mode
  #  print "Hello World \n"; # write a line
  #  $| = 0; # restore block buffering

### The 'binmode' Function ###
  # binmode HANDLE; # make HANDLE a binary filehandle
  # binmode HANDLE ':raw'; # make HANDLE a binary filehandle
  # binmode HANDLE ':crlf'; # make HANDLE a DOS text filehandle

  # use open IN => ':crlf', OUT => ':raw';

### Writing at the End-of-File ###
  # logging_pl();

### 'IO::Handle' Methods and Special Variables ###
  # new
  # new_from_fd
  # close
  # eof
  # fileno
  # format_write
  # getc
  # read
  # print
  # printf
  # stat
  # sysread
  # syswrite
  # truncate
  # autoflush
  # format_page_number
  # format_lines_per_page
  # format_lines_left
  # format_name
  # format_top_name
  # input_line_number
  # format_line_break_characters
  # format_formfeed
  # format_field_separator
  # output_record_seperator
  # input_record_seperator
  # fdopen FILENO
  # opened
  # getline
  # getlines
  # ungetc CHAR
  # write BUF, LEN, OFFSET
  # error
  # clearerr
  # sync
  # flush
  # printflush
  # ARGS
  # blocking 0|1
  # untaint 0|1

### Opening Filehandles at the System Level ###
  # use Fcntl;    # import standard symbols
  # sysopen SYSHANDLE, $filename, O_WRONLY | O_CREAT;

### Non-blocking IO ###
### File Locking ###
### Establishing File Locks ###
### Unbuffered Reading ###
### Unbuffered Writing ###
### Setting Filehandle Attributes with 'fcntl' ###
}

sub readfile {
  my $file = shift;
  if ( open FILE, $file ) {
    # undefine $/ if called in a scalar context
    local $/ = undef unless wantarray;
    # return file contents as array or single scalar
    return <FILE>;
  }
  return undef;    # failed to open, check $! for the reason
}

sub read_fixed {
  my $file        = shift;
  my $record_size = 32;
  $/ = \$record_size;    # or, equivalently, $/ = \32
  if ( open FILE, $file ) {
    while (<MYHANDLE>) {
      print "Got $_\n";
      # $_ contains 32 characters unless end of file intervenes
    }
  }
}

sub logging_pl {
  #logging.pl
  use warnings;
  use strict;
  use Fcntl qw(:seek :flock);
  # open file for update, position is at current end of file
  open LOGFILE, ">>/tmp/mylog" or die "Unable to open: $! \n";
  # lock file for exclusive access
  flock LOGFILE, LOCK_EX;
  # now seek to end of file explicitly, in case it changed since the open
  seek LOGFILE, 0, SEEK_END;
  # write our log message
  print LOGFILE "Log message...\n";
  # remove lock and close file
  flock LOGFILE, LOCK_UN;
  close LOGFILE;
}

sub lastten_pl {
  # lastten.pl
  use warnings;
  use strict;
  print "Reading...";

  open READ, "myfile" or die "Cannot open: $! \n";
  my @lines = <READ>;
  print "$. lines read \n";
  close READ;
  if ( $#lines < 9 ) {
    exit;
  }
  print "Writing...";
  open WRITE, "> myfile" or die "Cannot write: $! \n";
  foreach ( @lines[ -10 .. -1 ] ) {
    print WRITE $_;
  }
  print "done \n";
  close WRITE;
}

sub truncate_pl {
  # truncate.pl
  use warnings;
  use strict;
  die "Specify a file \n"   unless @ARGV;
  die "Specify a length \n" unless defined( $ARGV[1] ) and ( $ARGV[1] >= 1 );
  my $file        = $ARGV[0];
  my $truncate_to = int( $ARGV[1] );
  print "Reading...";
  open READ, "$file" or die "Cannot open: $! \n";

  while (<READ>) {
    last if $. == $truncate_to;
  }

  my $size = tell READ;
  print "$. lines read ($size bytes) \n";
  exit if $. < $truncate_to;    # already shorter
  close READ;
  print "Truncating to $size bytes...";
  open WRITE, "+< $file" or die "Cannot write: $! \n";
  truncate WRITE, $size;
  print "done \n";
  close WRITE;
}

### File Locking ###
sub badcounter_cgi_pl {
  #!/usr/bin/perl -T
  # badcounter.cgi
  use warnings;
  use strict;
  # script assumes file exists, but may be empty
  my $counter = "/home/httpd/data/counter/counter.dat";
  open( FILE, "+< $counter" ) or die "Cannot access counter: $! \n";
  my $visitors = <FILE>;
  chomp $visitors;
  seek FILE, 0, 0;
  print FILE $visitors ? ++$visitors : 1;
  close(FILE);
  print "Content-type: text/html\n\n";
  print $visitors, "\n";
}

### Establishing File Locks ###
sub counter_cgi_pl {
  #!/usr/bin/perl -T
  # counter.cgi
  use warnings;
  use strict;
  use Fcntl ':flock';
  # script assumes file exists but may be empty
  my $counter = "/home/httpd/data/counter/counter.dat";
  open( FILE, "+< $counter" ) or die "Cannot access counter: $!\n";
  flock( FILE, LOCK_EX );
  my $visitors = <FILE>;
  chomp $visitors;
  seek FILE, 0, 0;
  print FILE $visitors ? ++$visitors : 1;
  flock( FILE, LOCK_UN );
  close(FILE);
  print "Content-type: text/html\n\n";
  print $visitors, "\n";
}

sub nio1_pl {
  use Fcntl;
  # open serial port read only, non-blocking
  sysopen SERIAL, '/dev/ttyS0', O_RDONLY | O_NONBLOCK;
  # attempt to read characters
  my $key;
  while ( sysread SERIAL, $key, 1 ) {
    if ( defined $key ) {
      print "Got '$key' \n";
    } else {
      warn "No input available \n";
      # wait before trying again
      sleep(1);
    }
  }
  # close the port
  close SERIAL;
}

sub nio2_pl {
  use POSIX qw(EAGAIN);
  use Fcntl;
  # open serial port read only, non-blocking
  sysopen SERIAL, '/dev/ttyS0', O_RDONLY | O_NONBLOCK;
  # attempt to read characters
  my $key;
  while ( sysread SERIAL, $key, 1 ) {
    if ( defined($key) ) {
      print "Got '$key' \n";
    } else {
      if ( $! == EAGAIN ) {
        warn "No input available \n";
        # wait before trying again
        sleep(1);
      } else {
        warn "Error attempting to read: $! \n";
        last;
      }
    }
  }
  # close the port
  close SERIAL;
}

### Unbuffered Reading ###
sub unbuf_read_pl {
  #!/usr/bin/perl
  # sysread.pl
  use warnings;
  use strict;
  use POSIX;
  my $result;
  die "Usage: $0 file \n" unless @ARGV;
  sysopen HANDLE, $ARGV[0], O_RDONLY | O_NONBLOCK;
  # read 20 chrs into $result
  my $chrs = sysread HANDLE, $result, 20;
  if ( $chrs == 20 ) {
    # got all 20, try to read another 30 chrs into $result after the first 20
    $chrs += sysread HANDLE, $result, 30, 20;
    print "Got '$result' \n";
    if ( $chrs < 50 ) {
      print "Data source exhausted after $chrs characters \n";
    } else {
      print "Read $chrs characters \n";
    }
  } elsif ( $chrs > 0 ) {
    print "Got '$result' \n";
    print "Data source exhausted after $chrs characters \n";
  } else {
    print "No data! \n";
  }
}

### Unbuffered Writing ###
sub unbuf_write_pl {
  # an unbuffered print-a-like
  sub sysprint {
    # check for a leading filehandle and remove it if present
    my $fh = ( defined fileno( $_[0] ) ) ? shift : *STDOUT;
    # use $, to join arguments, just like print
    my $joiner = $, ? $, : '';
    syswrite $fh, join( $joiner, @_ );
  }
  sysprint( *STDOUT, "This ", "works ", "like ", "print ", "(sort of) ", "\n" );
}

### Setting Filehandle Attributes with 'fcntl' ###
sub fcntl_pl {
  # fcntl.pl
  use warnings;
  use strict;
  use Fcntl;
  # generic lock subroutine
  sub _do_lock {
    my ( $locktype, $fh, $block ) = @_;
    $block |= 0;    # don't block unless asked to
                    # is this a blocking or non-blocking attempt
    my $op = $block ? F_SETLKW : F_SETLK;
    # pack a structure suitable for this operation
    my $lock = pack( 's s l l s', $locktype, 0, 0, 0, 0 );
    # establish the chosen lock in the chosen way
    my $res = fcntl( $fh, $op, $lock );
    seek( $fh, 0, 0 );
    return $res;
  }
  # specific lock types
  sub read_lock  { return _do_lock( F_RDLCK, @_ ); }
  sub write_lock { return _do_lock( F_WRLCK, @_ ); }
  sub undo_lock  { return _do_lock( F_UNLCK, @_ ); }
  # called like this:
  open MYHANDLE, "+> myfile" or die "Failed to open: $! \n";
  # block write lock
  write_lock( *MYHANDLE, 1 ) or die "Failed to lock: $! \n";
  print MYHANDLE "Only I can write here \n";
  # undo (can't block anyway)
  undo_lock(*MYHANDLE) or die "Failed to unlick: $! \n";
  close MYHANDLE;
}

sub ioctl_pl {
  # ioctl.pl
  use warnings;
  use strict;
  # require 'linux/cdrom.ph';
  open CDROM, '/dev/cdrom';
  ioctl CDROM, 0x5309, 1;    # the ioctl number for CDROMEJECT
                             # ioctl CDROM, &CDROMEJECT, 1;
  close CDROM;
}

sub example {
  ro();
  my @array = ( 1, 2, 3 );
  printArray( 'array', @array );
  my %hash = ( one => 1, two => 2, three => 3 );
  printHash( 'hash', \%hash );
  sleep 0.6;
}

# -------------------------------- main --------------------------------
sub main() {
  # my $startTime = Time::HiRes::gettimeofday();
  # my $beginT    = time();
  example();
  my $elapsed_time = time() - $^T;
  # $^T just like $start_time=time() put it very beginning of perl script.
  print "\n# run time is: $elapsed_time second(s) \n";

  # my $endT = time();
  # printf( "%.4f\n", $endT - $beginT );
  # my $stopTime = Time::HiRes::gettimeofday();
  # printf( "%.4f\n", $stopTime - $startTime );
}
# -------------------------------- exit --------------------------------
main();
exit 0;
# sudo apt install -y perltidy
# http://perltidy.sourceforge.net/tutorial.html
# chapter12:Chapter 12 Input and Output With Filehandles
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example12.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
