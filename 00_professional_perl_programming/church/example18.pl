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
  ### Text Processing ###
  # Module Function
  # Text::Tabs Convert tabs to and from spaces
  # Text::Abbrev Calculate unique abbreviations from a list of words
  # Text::ParseWords Parse text into words and phrases
  # Text::Wrap Convert unformatted text into paragraphs
  # Text::Soundex Convert similar sounding text into condensed codes

### Expanding and Contracting Tabs with 'Text::Tabs' ###
  use Text::Tabs qw(expand unexpand);
  my $spaced_text = 'abc xyz 123';
  my $tabbed_text = '';
  print("$spaced_text\n");
  print("$tabbed_text\n");
  # convert spaces into tabs
  $tabbed_text = unexpand($spaced_text);
  # convert tabs into spaces
  $spaced_text = expand($tabbed_text);
  print("$spaced_text\n");
  print("$tabbed_text\n");

  # $tabstop = 8; # set a tab width of eight characters

### Determining and Assigning Formats to Other Filehandles ###
  #  $fh = new IO::File ("> $outputfile");
  #  $fh->format_name ('MYFORMAT');
  #  $fh->format_top_name ('MYFORMAT_TOP');
  #  write $fh; # or $fh->format_write ();

### Generating Report Text with 'formline' ###
  my ( $sec, $min, $hour ) = localtime;
  formline '@#/@#/@#', $hour, $min, $sec;
  my $time = $^A;
  print "The time is: $time \n";
  print "The time is: $hour:$min.$sec \n";
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
# chapter18:Chapter 18 Text Processing and Document Generation
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example18.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
