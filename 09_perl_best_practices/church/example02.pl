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
  ### Brace and parenthesize in K&R style. ###
  ### Separate your control keywords from the following opening bracket. ###
  ### Don't separate subroutine or variable names from the following opening bracket. ###
  ### Don't use unnecessary parentheses for builtins and "honorary" builtins. ###
  ### Separate complex keys or indices from their surrounding brackets. ###
  ### Use whitespace to help binary operators stand out from their operands. ###
  ### Place a semicolon after every statement. ###
  ### Place a comma after every value in a multiline list. ###
  ### Use 78-column lines. ###
  ### Use four-column indentation levels. ###
  ### Indent with spaces, not tabs. ###
  ### Never place two statements on the same line. ###
  ### Code in paragraphs. ###
  ### Don't cuddle an else. ###
  ### Align corresponding items vertically. ###
  ### Break long expressions before an operator. ###
  ### Factor out long expressions in the middle of statements. ###
  ### Always break a long expression at the operator of the lowest possible precedence. ###
  ### Break long assignments before the assignment operator. ###
  ### Format cascaded ternary operators in columns. ###
  ### Parenthesize long lists. ###
  ### Enforce your chosen layout style mechanically. ###

  # In vi, you can set your right margin appropriately by adding:
  # set textwidth=78
  # to your configuration file. For Emacs, use:
  # (setq fill-column 78)
  # (setq auto-fill-mode t)

  # in your .vimrc file:
  # set tabstop=4 "An indentation level every four columns"
  # set expandtab "Convert all tabs typed into spaces"
  # set shiftwidth=4 "Indent/outdent by four columns"
  # set shiftround "Always indent/outdent to the nearest tabstop"

  # Or in your .emacs initialization file (using “cperl” mode):
  # (defalias 'perl-mode 'cperl-mode)
  # ;; 4 space indents in cperl mode
  # '(cperl-close-paren-offset -4)
  # '(cperl-continued-statement-offset 4)
  # '(cperl-indent-level 4)
  # '(cperl-indent-parens-as-block t)
  # '(cperl-tab-always-indent t)

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
# chapter02:Chapter 2, Code Layout
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example02.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
