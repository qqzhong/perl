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

sub output {
  print "[";
  foreach my $e (@_) { print "$e,"; }
  print "]\n";
}

sub outputHash {
  my $hRef = shift;
  print "{";
  foreach my $k ( keys %{$hRef} ) { print "$k => ${$hRef}{$k},"; }
  print "}\n";
}

sub example {
  my $name     = "Inigo Montoya";
  my $relative = "father";
  print "My name is $name, you killed my $relative";
  print "\n";
  print 'You may have won $1,000,000';
  print "\n";
  print "You may have won \$1,000,000";
  print "\n";

  # my $email = "andy@foo.com";
  # print $email;
  # Prints "andy.com"

  my $email1 = 'andy@foo.com';
  print $email1;
  print "\n";

  my $email2 = q{andy@foo.com};
  print $email2;
  print "\n";

  my $email3 = "andy\@foo.com";
  print $email3;
  print "\n";

  my $str = "Chicago Perl Mongers";
  print length($str);    # 20
  print "\n";

  my $x = "Chicago Perl Mongers";
  print substr( $x, 0, 4 );    # Chic
  print "\n";
  print substr( $x, 13 );      # Mongers
  print "\n";
  print substr( $x, -4 );      # gers
  print "\n";

  # DTRT (Do The Right Thing)
  my $phone    = "312-588-2300";
  my $exchange = substr( $phone, 4, 3 );    # 588
  print sqrt($exchange);                    # 24.2487113059643
  print "\n";

  my $a = 'abc';
  $a = $a + 1;                              # Argument "abc" isn't numeric in addition (+)
  my $b = 'abc';
  $b += 1;                                  # Argument "abc" isn't numeric in addition (+)
  my $c = 'abc';
  $c++;
  print join ", ", ( $a, $b, $c );
  print "\n";

  my $title = 'heredocs';
  my $page  = <<HERE;
<html>
    <head><title>$title</title></head>
    <body>This is a page.</body>
</html>
HERE

  print "$page\n";

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
# chapter04:strings
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/01_things_perl101/church/example04.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
