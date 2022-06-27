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

use Carp;
use Readonly;
use IO::Prompt;
Readonly my $OS_ERROR  => 'IO error';
Readonly my $EMPTY_STR => q{ };
Readonly my $PROMPT    => 'prompt> ';

sub ro {
  ### Don’t use bareword filehandles. ###
  ### Use indirect filehandles. ###
  ### If you have to use a package filehandle, localize it first. ###
  ### Use either the IO::File module or the three-argument form of open. ###
  ### Never open, close, or print to a file without checking the outcome. ###
  ### Close filehandles explicitly, and as soon as possible. ###
  ### Use while (<>), not for (<>). ###
  ### Prefer line-based I/O to slurping. ###
  ### Slurp a filehandle with a do block for purity. ###
  ### Slurp a stream with Perl6::Slurp for power and simplicity. ###
  ### Avoid using *STDIN, unless you really mean it. ###
  ### Always put filehandles in braces within any print statement. ###
  ### Always prompt for interactive input. ###
  ### Don’t reinvent the standard test for interactivity. ###
  ### Use the IO::Prompt module for prompting. ###
  ### Always convey the progress of long non-interactive operations within interactive applications. ###
  ### Consider using the Smart::Comments module to automate your progress indicators. ###
  ### Avoid a raw select when setting autoflushes. ###

  # print {$wfh} 'text', "\n";
  power_prompt();

  # use IO::Handle;
  # # and later...
  # $fh->autoflush( );
}

# Opening Cleanly
sub io {
  # Log system uses a weird but distinctive naming scheme...
  Readonly my $ACTIVE_LOG => '>temp.log<';
  Readonly my $STATIC_LOG => '>perm.log<';
  # and later...
  use IO::File;
  my $active = IO::File->new( $ACTIVE_LOG, '<' )
    or croak "Can't open '$ACTIVE_LOG': $OS_ERROR";
  my $static = IO::File->new( $STATIC_LOG, '>' )
    or croak "Can't open '$STATIC_LOG': $OS_ERROR";
}

# Error Checking
sub check {
  my $out_file = 'dummy.txt';
  my @results  = (qx(date));
  open my $out, '>', $out_file or croak "Couldn't open '$out_file': $OS_ERROR";
  print {$out} @results or croak "Couldn't write '$out_file': $OS_ERROR";
  close $out or croak "Couldn't close '$out_file': $OS_ERROR";
}

# Cleanup
sub get_config {
  my ($config_file) = @_;
  # Access config file or signal failure...
  open my $fh, '<', $config_file
    or croak "Can't open '$config_file': $OS_ERROR";
  # Load file contents and close file...
  my @lines = <$fh>;
  close $fh
    or croak "Can't close '$config_file' after reading: $OS_ERROR";
  # [Decode config data and return, as before]
}

# In modern versions of Perl, ranges are lazily evaluated,
# so the previous code doesn’t first have to build a list of 999,999,999
# consecutive integers before the for can start iterating.
sub factors_of { return 0; }

sub prime {
  for my $n ( 2 .. 1_000_000_000 ) {
    my @factors = factors_of($n);
    if ( @factors == 2 ) {
      print "$n is prime\n";
    } else {
      print "$n is composite with factors: @factors\n";
    }
  }
}

use Perl6::Slurp;

sub perl6slurp {
  my $filename    = 'dummy.txt';
  my $file_handle = open $filename;
  my $text1       = slurp $file_handle;
  my $text2       = slurp $filename;
  my @lines1      = slurp $filename;
  my @lines2      = slurp $filename, { chomp => 1 };
  my @lines3      = slurp $filename, { chomp => '[EOL]' };
  my @paragraphs1 = slurp $filename, { irs => $EMPTY_STR };
  # Read "human" paragraphs (separated by two or more whitespace-only lines)...
  my @paragraphs2 = slurp $filename, { irs => qr/\n \s* \n/xms };
}

sub interactive {
  #  use IO::Interactive qw( is_interactive );
  #  # and later...
  #  if ( is_interactive() ) {
  #    print $PROMPT;
  #  }
  #
  #  use IO::Interactive qw( interactive );
  #  # and later...
  #  print {interactive} $PROMPT;
}

sub power_prompt {
  my $username  = prompt 'Enter user name: ';
  my $password1 = prompt 'Password: ', -echo => '*';
  my $password2 = prompt 'Password: ', -echo => $EMPTY_STR;
  my $choice1   = prompt 'Enter your choice [a-e]: ', -one_char;
  print("\n");
  my $choice2 = prompt 'Enter your choice [a-e]: ', -require => { 'Must be a, b, c, d, or e: ' => qr/[a-e]/xms };
  print("$username,$password1,$password2,$choice1,$choice2\n");

  print("quit1\n");
  # quit1();
  print("quit2\n");
  # quit2();
}

sub quit1 {
CODE:
  while ( my $ord = prompt -integer, 'Enter a code (zero to quit): ' ) {
    if ( $ord == 0 ) {
      exit if prompt -yn, 'Really quit? [y/n]';
      next CODE;
    }
    print qq{Character $ord is: '}, chr($ord), qq{'\n};
  }
}

sub get_prompt_str { return $PROMPT; }
sub execute        { return system(@_); }

sub quit2 {
  Readonly my $QUIT => 'quit';
  # Until the q[uit] command is entered...
  while ( my $cmd = prompt( get_prompt_str(), -fail_if => $QUIT ) ) {
    # Run whatever else was...
    execute($cmd) or carp "Unknown command: $cmd";
  }
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
# chapter10:Chapter 10, I/O
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example10.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
