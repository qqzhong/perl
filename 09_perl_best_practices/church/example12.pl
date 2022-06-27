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
Readonly my $SPACE     => q{ };
Readonly my $EMPTY_STR => q{ };
Readonly my $IDENT     => q{name};

sub enter { print( @_, "\n" ); }
sub leave { print( @_, "\n" ); }

sub ro {
  ### Always use the /x flag. ###
  ### Always use the /m flag. ###
  ### Use \A and \z as string boundary anchors. ###
  ### Use \z, not \Z, to indicate “end of string”. ###
  ### Always use the /s flag. ###
  ### Consider mandating the Regexp::Defaultflags module. ###
  ### Use m{...} in preference to /.../ in multiline regexes. ###
  ### Don’t use any delimiters other than /.../ or m{...}. ###
  ### Prefer singular character classes to escaped metacharacters. ###
  ### Prefer named characters to escaped metacharacters. ###
  ### Prefer properties to enumerated character classes. ###
  ### Consider matching arbitrary whitespace, rather than specific whitespace characters. ###
  ### Be specific when matching “as much as possible”. ###
  ### Use capturing parentheses only when you intend to capture. ###
  ### Use the numeric capture variables only when you’re sure that the preceding match succeeded. ###
  ### Always give captured substrings proper names. ###
  ### Tokenize input using the /gc flag. ###
  ### Build regular expressions from tables. ###
  ### Build complex regular expressions from simpler pieces. ###
  ### Consider using Regexp::Common instead of writing your own regexes. ###
  ### Always use character classes instead of single-character alternations. ###
  ### Factor out common affixes from alternations. ###
  ### Prevent useless backtracking. ###
  ### Prefer fixed-string eq comparisons to fixed-pattern regex matches. ###

  if (0) {
    match1();
    match2();
    match3();
    match4();
    match5();
    match6();
    match7();
    match8();
    match9();
    match10();
  }
  if (0) {
    match11();
    match12();
    match13();
    match14();
    match15();
    match16();
    match17();
  }
  if (1) {
    match18();
    match19();
    match20();
    match21();
    match22();
    match23();
    match24();
  }
}

# Extended Formatting, Always use the /x flag.
sub match1 {
  enter( ( caller(0) )[3] );
  my $text = "'church'";
  print("$text\n") if $text =~
    # Match a single-quoted string efficiently...
    m{ ' # an opening single quote
[^\\']* # any non-special chars (i.e., not backslash or single quote)
(?: # then all of...
\\ . # any explicitly backslashed char
[^\\']* # followed by any non-special chars
)* # ...repeated zero or more times
' # a closing single quote
}x;
  leave( ( caller(0) )[3] );
}

# Line Boundaries, Always use the /m flag.
sub match2 {
  enter( ( caller(0) )[3] );
  my $text = << 'HERE'
1
2
3
__END__
HERE
    ;

  print("$text\n") if $text =~ m{ [^\0]*? # match the minimal number of chars
^ # until the start of any line (/m mode)
__END__ # then match the end-marker
$ # then match the end of a line (/m mode)
}xm;
  leave( ( caller(0) )[3] );
}

# String Boundaries, Use \A and \z as string boundary anchors.
sub match3 {
  enter( ( caller(0) )[3] );
  my $text = '  space  ';
  # Remove leading and trailing whitespace...
  print("$text\n") if $text =~ s{\A \s* | \s* \z}{}gxm;

  $text = '  -- space --  ';
  # Remove leading and trailing whitespace, and any -- line...
  print("$text\n") if $text =~ s{\A \s* | ^-- [^\n]* $ | \s* \z}{}gxm;
  leave( ( caller(0) )[3] );
}

# End of String, Use \z, not \Z, to indicate “end of string”.
sub match4 {
  enter( ( caller(0) )[3] );
  # Print contents of lines starting with --...
  my @input_lines = ( " -line1\n", " --line2\n", "--line3\n" );
LINE:
  while ( my $line = <@input_lines> ) {
    next LINE if $line !~ m/ \A -- ([^\n]+) \n? \z/xm;    # Might be newline at end
    print $1, "\n";
  }

  # especially if what you actually meant was :
  # Print contents of lines starting with -- (including any trailing newline!)...
LINE: while ( my $line = <@input_lines> ) {
    next LINE if $line !~ m/ \A -- ([^\n]* \n?) \z/xm;
    print $1, "\n";
  }
  leave( ( caller(0) )[3] );
}

# Matching Anything, Always use the /s flag.
sub match5 {
  enter( ( caller(0) )[3] );
  my $text = << 'HERE';
1
2
3
__END__
HERE

  # Capture the source of a Perl program...
  print("$text\n") if $text =~ m{\A # From start of string...
(.*?) # ...match and capture any characters (including newlines!)
^__END__$ # ...until the first _ _END_ _ line
}xms;

  my $source_code = <<'SOURCE_CODE';
# main
int main(){
  printf("hello, world\n");
}
SOURCE_CODE

  # Delete comments....
  print("$source_code\n") if $source_code =~ s{ # Substitute...
\# # ...a literal octothorpe
[^\n]* # ...followed by any number of non-newlines
}
{$SPACE}gxms;    # Replacing it with a single space
  leave( ( caller(0) )[3] );
}

# Lazy Flags, Consider mandating the Regexp::Defaultflags module.
sub match6 {
  enter( ( caller(0) )[3] );
  # use Regexp::Defaultflags;# use xms by church;
  my $text = << 'HERE';
1
2
3
__END__
HERE

  print("$text\n") if $text =~ m{\A # From start of string...
(.*?) # ...match and capture any characters (including newlines!)
^__END__$ # ...until the first _ _END_ _ line
}xms;

  my $source_code = <<'SOURCE_CODE';
# main
int main(){
  printf("hello, world\n");
}
SOURCE_CODE

  print("$source_code\n") if $source_code =~ s{ # Substitute...
\# # ...a literal octothorpe
[^\n]* # ...followed by any number of non-newlines
}
{$SPACE}gxms;    # Replacing it with a single space
  leave( ( caller(0) )[3] );
}

sub get_source_code {
  return <<'HERE';
/*
file:main.c
*/
// header
#include<stdio.h>

/*main*/
int main(){
  /* output church */
  printf("church\n");
}
HERE
}
# Brace Delimiters, Use m{...} in preference to /.../ in multiline regexes.
sub match7 {
  enter( ( caller(0) )[3] );

  Readonly my $C_COMMENT => qr{
/ \* # Opening C comment delimiter
.*? # Smallest number of characters (C comments don't nest)
\* / # Closing delimiter
}xms;

  my $source_code = get_source_code();

  print("1:$source_code\n") if $source_code =~ s{ / \* (.*?) \* / }{}gxms;
  $source_code = get_source_code();
  print("2:$source_code\n") if $source_code =~ s{$C_COMMENT}{$EMPTY_STR}gxms;
  $source_code = get_source_code();
  print("3:$source_code\n") if $source_code =~ s{$C_COMMENT}{$EMPTY_STR}xms;

  my $regex = '';

  $regex =~ m{
set \s+ # Keyword
($IDENT) \s* # Name of file/option/mode
= \s* # literal =
([^\n]*) # Value of file/option/mode
}xms;

  $regex =~ m{
set \s+ # Keyword
($IDENT) \s* # Name of file/option/mode
= \s* # literal =
\{ # literal {
([^\n]*) # Value of file/option/mode
\} # literal }
}xms;

  my @count_reports = ();
  my @counts        = map { m/(\d{4,8})/xms } @count_reports;

  leave( ( caller(0) )[3] );
}

# Other Delimiters, Don’t use any delimiters other than /.../ or m{...}.
sub match8 {
  enter( ( caller(0) )[3] );

  # last TRY if !$OS_ERROR !~ m{ /pattern/ }xms;
  # $same = ($str =~ m/{/xms == $str =~ m/}/xms);
  # harry( $str =~ s{ruman was }{he 33rd u.s. presiden}xms );

  leave( ( caller(0) )[3] );
}

# Metacharacters, Prefer singular character classes to escaped metacharacters.
sub match9 {
  enter( ( caller(0) )[3] );
  # m/ \{ . \. \d{2} \} /xms;
  # m/ [{] . [.] \d{2} [}] /xms;
  my $name = 'harry s truman';
  print("$name\n") if $name =~ m{ harry [ ] s [ ] truman
| harry [ ] j [ ] potter
}ixms;
  $name = 'harry j potter';
  print("$name\n") if $name =~ m{ harry [ ] s [ ] truman
| harry [ ] j [ ] potter
}ixms;

  $name = 'harry s truman';
  print("$name\n") if $name =~ m{ harry \ s \ truman
| harry \ j \ potter
}ixms;
  $name = 'harry j potter';
  print("$name\n") if $name =~ m{ harry \ s \ truman
| harry \ j \ potter
}ixms;

  leave( ( caller(0) )[3] );
}

# Named Characters, Prefer named characters to escaped metacharacters.
sub match10 {
  enter( ( caller(0) )[3] );
  use charnames qw( :full );
  my $escape_seq = " \177 \006 \030 Z ";
  if ( $escape_seq =~ m/\N{DELETE} \N{ACKNOWLEDGE} \N{CANCEL} Z/xms ) {
    # blink(182);
    print("matched\n");    #FIXME
  }

  my $name = 'harry s truman';
  print("$name\n") if $name =~ m{ harry [\N{SPACE}] s [\N{SPACE}] truman # harry s truman
| harry [\N{SPACE}] j [\N{SPACE}] potter # harry j potter
}ixms;
  $name = 'harry j potter';
  print("$name\n") if $name =~ m{ harry [\N{SPACE}] s [\N{SPACE}] truman # harry s truman
| harry [\N{SPACE}] j [\N{SPACE}] potter # harry j potter
}ixms;
  leave( ( caller(0) )[3] );
}

# Properties, Prefer properties to enumerated character classes.
sub match11 {
  enter( ( caller(0) )[3] );

  Readonly my $ALPHA_IDENT => qr/ \p{Uppercase} \p{Alphabetic}* /xms;
  Readonly my $PERL_IDENT  => qr/ \p{ID_Start} \p{ID_Continue}* /xms;

  my $text = 'A';
  print("$text\n") if $text =~ $ALPHA_IDENT;
  $text = 'ID_Start ID_Continue';
  print("$text\n") if $text =~ $PERL_IDENT;

  leave( ( caller(0) )[3] );
}

# Whitespace, Consider matching arbitrary whitespace, rather than specific whitespace characters.
sub match12 {
  enter( ( caller(0) )[3] );
  my $config_line = << 'HERE';
name = Yossarian, J
rank = Captain
serial_num = 3192304
HERE

  print("$config_line\n") if $config_line =~ m{ ($IDENT) \s* = \s* (.*) }xms;
  leave( ( caller(0) )[3] );
}

# Unconstrained Repetitions, Be specific when matching “as much as possible”.
sub compile { return @_; }
sub execute { return @_; }

sub match13 {
  enter( ( caller(0) )[3] );

  my $source = 'source % data & config';
  # Format is: <source> % <data> & <config>...
  if ( $source =~ m/\A ([^%]*) % ([^&]*) & (.*) /xms ) {
    my ( $statements, $data, $config ) = ( $1, $2, $3 );
    my $prog = compile( $statements, { config => $config } );
    my $res  = execute( $prog,       { data   => $data, config => $config } );
    print("matched\n");
  } else {
    croak 'Invalid program';
  }

  leave( ( caller(0) )[3] );
}

# Capturing Parentheses, Use capturing parentheses only when you intend to capture.
sub match14 {
  enter( ( caller(0) )[3] );

  my $cmd = 'quit';
  if ( $cmd =~ m/\A (?:q | quit | bye | exit) \n? \z/xms ) {
    # perform_cleanup( );
    # exit;
    print("matched\n");
  }
  leave( ( caller(0) )[3] );
}

# Captured Values, Use the numeric capture variables only when you’re sure that the preceding match succeeded.
sub match15 {
  enter( ( caller(0) )[3] );
  # FIXME
  my @input_lines = ( "Dr Church ZHONG \n", "Ms Florence Nightingale \n" );
  my ( $title, $first_name, $last_name ) = ( undef, undef, undef );
NAME1:
  while ( my $full_name = <@input_lines> ) {
    if ( $full_name =~ m/\A (Mrs?|Ms|Dr) \s+ (\S+) \s+ (\S+) \z/xms ) {
      ( $title, $first_name, $last_name ) = ( $1, $2, $3 );
      print( $title, $first_name, $last_name, "\n" );
    }
  }

NAME2:
  while ( my $full_name = <@input_lines> ) {
    next NAME2 if $full_name !~ m/\A (Mrs?|Ms|Dr) \s+ (\S+) \s+ (\S+) \z/xms;
    ( $title, $first_name, $last_name ) = ( $1, $2, $3 );
    print( $title, $first_name, $last_name, "\n" );
  }
  leave( ( caller(0) )[3] );
}

# Capture Variables, Always give captured substrings proper names.
sub match16 {
  enter( ( caller(0) )[3] );
  # FIXME
  my %option      = ( 'c1' => 'v1', 'c2' => 'v2' );
  my @input_lines = ( "name = c1; # c1", "name = c2; # c2" );

CONFIG_LINE1:
  while ( my $config = <@input_lines> ) {
    # Ignore lines that are unrecognisable...
    next CONFIG_LINE1
      if $config !~ m/ \A (\S+) \s* = \s* ([^;]+) ; \s* \# (.*)/xms;
    # Name captured components...
    my ( $opt_name, $opt_val, $comment ) = ( $1, $2, $3 );
    print( $opt_name, $opt_val, $comment, "\n" );
    # Verify the option makes sense...
    debug($comment);
    croak "Unknown option ($opt_name)"
      if not exists $option{$opt_val};    # Oops: value used as key
                                          # Record the configuration option...
    $option{$opt_val} = $opt_name;        # Oops*2: value as key; name as value
  }

CONFIG_LINE2:
  while ( my $config = <@input_lines> ) {
    # Ignore lines that are unrecognisable...
    next CONFIG_LINE2
      if $config !~ m/ \A (\S+) \s* = \s* ([^;]+) ; \s* \# (.*)/xms;
    # Name captured components...
    my ( $opt_name, $opt_val, $comment ) = ( $1, $2, $3 );
    print( $opt_name, $opt_val, $comment, "\n" );
    # Verify that the option makes sense...
    debug($comment);
    croak "Unknown option ($opt_name)"
      if not exists $option{$opt_name};    # Name used as key
                                           # Record the configuration option...
    $option{$opt_name} = $opt_val;         # Names as key; value as value
  }

CONFIG_LINE3:
  while ( my $config = <@input_lines> ) {
    # Ignore lines that are unrecognisable...
    next CONFIG_LINE3
      if $config !~ m/\A (\S+) \s* (=|[+]=) \s* ([^;]+) ; \s* \# (.*)/xms;
    # Unpack the components of the config line...
    my ( $opt_name, $operator, $opt_val, $comment ) = ( $1, $2, $3, $4 );
    print( $opt_name, $opt_val, $comment, "\n" );
    # Verify that the option makes sense...
    debug($comment);
    croak "Unknown option ($opt_name)"
      if not exists $option{$opt_name};
    # Replace or append value depending on specified operator...
    if ( $operator eq '=' ) {
      $option{$opt_name} = $opt_val;
    } else {
      $option{$opt_name} .= $opt_val;
    }
  }

CONFIG_LINE4:
  while ( my $config = <@input_lines> ) {
    # Match config line in list context, capturing components into named vars...
    my ( $opt_name, $operator, $opt_val, $comment ) = $config =~ m/\A (\S+) \s* (=|[+]=) \s* ([^;]+) ; \s* \# (.*)/xms;
    # Process line only if it was recognizable...
    next CONFIG_LINE4 if !defined $opt_name;
    print( $opt_name, $opt_val, $comment, "\n" );
    # Verify that the option makes sense...
    debug($comment);
    croak "Unknown option ($opt_name)"
      if not exists $option{$opt_name};
    # Replace or append value depending on specified operator...
    if ( $operator eq '=' ) {
      $option{$opt_name} = $opt_val;
    } else {
      $option{$opt_name} .= $opt_val;
    }
  }

  leave( ( caller(0) )[3] );
}

# Piecewise Matching, Tokenize input using the /gc flag.
sub start_cmd  { return @_; }
sub make_ident { return @_; }
sub make_block { return @_; }

sub match17 {
  enter( ( caller(0) )[3] );

  my ( $KEYWORD, $IDENT, $BLOCK ) = ( 'keyword', 'ident', 'block' );
  my @tokens = ();
  my $input  = "keyword ident block (text)\n";
  # Reset the matching position of $input to the beginning of the string...
  pos $input = 0;
  # ...and continue until the matching position is past the last character...
LOOP1:
  while ( pos $input < length $input ) {
    if ( $input =~ m{ \G ($KEYWORD) }gcxms ) {
      my $keyword = $1;
      push @tokens, start_cmd($keyword);
      print("keyword=$keyword\n") if $keyword;
    } elsif ( $input =~ m{ \G ( $IDENT) }gcxms ) {
      my $ident = $1;
      push @tokens, make_ident($ident);
      print("ident=$ident\n") if $ident;
    } elsif ( $input =~ m{ \G ($BLOCK) }gcxms ) {
      my $block = $1;
      push @tokens, make_block($block);
      print("block=$block\n") if $block;
    } else {
      $input =~ m/ \G ([^\n]*) /gcxms;
      my $context = $1;
      print("context=$context\n") if $context;
      # croak "Error near: $context";
      last LOOP1;
    }
  }

  pos $input = 0;
LOOP2:
  while ( pos $input < length $input ) {
    push @tokens, (
      # For token type... # Build token...
        $input =~ m{ \G ($KEYWORD) }gcxms ? start_cmd($1)
      : $input =~ m{ \G ( $IDENT ) }gcxms ? make_ident($1)
      : $input =~ m{ \G ( $BLOCK ) }gcxms ? make_block($1)
      : $input =~ m{ \G ( [^\n]* ) }gcxms ? last LOOP2             #croak "Error near:$1"
      :                                     die 'Internal error'
    );
  }
  leave( ( caller(0) )[3] );
}

# Tabular Regexes, Build regular expressions from tables.
sub match18 {
  enter( ( caller(0) )[3] );
  # Table of irregular plurals...
  my %irregular_plural_of = (
    'child'       => 'children',
    'brother'     => 'brethren',
    'money'       => 'monies',
    'mongoose'    => 'mongooses',
    'ox'          => 'oxen',
    'cow'         => 'kine',
    'soliloquy'   => 'soliloquies',
    'prima donna' => 'prime donne',
    'octopus'     => 'octopodes',
    'tooth'       => 'teeth',
    'toothfish'   => 'toothfish',
  );
  # Build a pattern matching any of those irregular plurals...
  my $has_irregular_plural = join '|', map { quotemeta $_ } reverse sort keys %irregular_plural_of;
  print("0:$has_irregular_plural\n");

  my $has_irregular_plural1 = regex_that_matches1( keys %irregular_plural_of );
  print("1:$has_irregular_plural\n");

  # and later...
  my $has_irregular_plural2 = regex_that_matches2( keys %irregular_plural_of );
  print("2:$has_irregular_plural\n");
  leave( ( caller(0) )[3] );
}

# Build a pattern matching any of the arguments given...
sub regex_that_matches1 {
  return join '|', map { quotemeta $_ } reverse sort @_;
}

# Build a pattern matching any of the arguments given...
sub regex_that_matches2 {
  return join '|', map { quotemeta $_ }
    # longest strings first, otherwise alphabetically...
    sort { length($b) <=> length($a) or $a cmp $b } @_;
}

# Constructing Regexes, Build complex regular expressions from simpler pieces.
sub match19 {
  enter( ( caller(0) )[3] );

  # Build a regex that matches floating point representations...
  Readonly my $DIGITS   => qr{ \d+ (?: [.] \d*)? | [.] \d+ }xms;
  Readonly my $SIGN     => qr{ [+-] }xms;
  Readonly my $EXPONENT => qr{ [Ee] $SIGN? \d+ }xms;
  Readonly my $NUMBER   => qr{ ( ($SIGN?) ($DIGITS) ($EXPONENT?) ) }xms;
  # and later...
  my $input = '+19';
  my ( $number, $sign, $digits, $exponent ) = $input =~ $NUMBER;
  print("number=$number\n");
  print("sign=$sign\n");
  print("digits=$digits\n");
  print("exponent=$exponent\n");

  leave( ( caller(0) )[3] );
}

# Canned Regexes, Consider using Regexp::Common instead of writing your own regexes.
use Regexp::Common;
use IO::Prompt;

sub match20 {
  enter( ( caller(0) )[3] );
  my $number = 0;
  my $input  = '20';

  # Build a regex that matches floating point representations...
  Readonly my $NUMBER1 => $RE{num}{real}{-keep};
  # and later...
  ($number) = $input =~ $NUMBER1;
  print("number=$number\n");

  my @input_lines = (
    'http://perldoc.perl.org',  'http://metacpan.org/pod/perlre',
    'https://perldoc.perl.org', 'https://metacpan.org/pod/perlre'
  );
  # Find web pages...
URI:
  while ( my $uri = <@input_lines> ) {
    next URI if $uri !~ m/ $RE{URI}{HTTP} /xms;
    print "uri=$uri\n";
  }

  # The alien hardware device requires duodecimal floating-point numbers...
  Readonly my $NUMBER2 => $RE{num}{real}{ -base => 12 }{ -places => '6,9' }{-keep};
  # and later...
  ($number) = $input =~ m/$NUMBER2/xms;
  print("number=$number\n");

  my $text = "abc \177 xyz";
  # Clean up their [DELETED] language...
  print("$text\n") if $text =~ s{ $RE{profanity}{contextual} }{[DELETED]}gxms;

  # Strewth, better find out where this bloke lives...
  # my $postcode = prompt 'Giz ya postcode, mate: ', -require => { 'Try again, cobber: ' => qr/\A $RE{zip}{Australia} \Z/xms };
  # print("postcode=$postcode\n") if ( defined $postcode );
  # A ZIP code that is important in Australia, located between 3000 to 30001 in Melbourne.
  # Its postal code ranges from 4000 to 4179 in Perth;
  # 6000 to 6152 in Brisbane. 2600 and 0829 refer to city areas such as Adelaide,
  # whilst a number of 2616 has a state capital for NSW (Canberra).

  leave( ( caller(0) )[3] );
}

# Alternations, Always use character classes instead of single-character alternations.

sub match21 {
  enter( ( caller(0) )[3] );

  my @input_lines = ( "adiqrwx", "a", "d", "i", "q", "r", "w", "x" );
COMMAND:
  while ( my $cmd = <@input_lines> ) {
    if ( $cmd !~ m{\A [adiqrwx] \z}xms ) {
      carp "Unknown command: $cmd";
      next COMMAND;
    }
    print("cmd=$cmd\n");
  }

  @input_lines = ("qq");
QUOTELIKE1:
  while ( my $quotelike = <@input_lines> ) {
    if ( $quotelike !~ m{\A (?: qq | qr | qx | [qsy] | tr ) \z}xms ) {
      carp "Unknown quotelike: $quotelike";
      next QUOTELIKE1;
    }
    print("quotelike=$quotelike\n");
  }
QUOTELIKE2:
  while ( my $quotelike = <@input_lines> ) {
    if ( $quotelike !~ m{\A (?: q[qrx] | [qsy] | tr ) \z}xms ) {
      carp "Unknown quotelike: $quotelike";
      next QUOTELIKE2;
    }
    print("quotelike=$quotelike\n");
  }
  leave( ( caller(0) )[3] );
}

# Factoring Alternations, Factor out common affixes from alternations.
sub match22 {
  enter( ( caller(0) )[3] );
  my ( $EXPR, $BLOCK, $VAR, $LIST ) = ( 'expr', 'block', 'var', 'list' );

  my $text = 'with each var in (list) block';
  print("1:$text\n") if $text =~ m{
(?: with \s+ each \s+ $EXPR \s* $BLOCK
| with \s+ each \s+ $VAR \s* in \s* [(] $LIST [)] \s* $BLOCK
| with \s+ [(] $LIST [)] \s* $BLOCK
)
}xms;

  print("2:$text\n") if $text =~ m{
with \s+
(?: each \s+ $EXPR \s* $BLOCK
| each \s+ $VAR \s* in \s* [(] $LIST [)] \s* $BLOCK
| [(] $LIST [)] \s* $BLOCK
)
}xms;

  print("3:$text\n") if $text =~ m{
with \s+
(?:
(?: each \s+ $EXPR \s* $BLOCK
| each \s+ $VAR \s* in \s* [(] $LIST [)] \s* $BLOCK
)
| [(] $LIST [)] \s* $BLOCK
)
}xms;

  print("4:$text\n") if $text =~ m{
with \s+
(?: each \s+
(?: $EXPR \s* $BLOCK
| $VAR \s* in \s* [(] $LIST [)] \s* $BLOCK
)
| [(] $LIST [)] \s* $BLOCK
)
}xms;

  print("5:$text\n") if $text =~ m{
with \s+
(?: each \s+
(?:$EXPR
| $VAR \s* in \s* [(] $LIST [)]
)
| [(] $LIST [)]
)
\s* $BLOCK
}xms;

  Readonly my $WITH_BLOCK => qr{
with \s+ # Always a 'with' keyword
(?: each \s+ # If followed by 'each'
(?:$EXPR # Then expect an expression
| $VAR \s* in \s* [(] $LIST [)] # or a variable and list
)
| [(] $LIST [)] # Otherwise, no 'each' and just a list
)
\s* $BLOCK # And the loop block always at the end
}xms;

  print("6:$text\n") if $text =~ $WITH_BLOCK;

  leave( ( caller(0) )[3] );
}

# Backtracking, Prevent useless backtracking.
sub match23 {
  enter( ( caller(0) )[3] );

  my ( $EXPR, $BLOCK, $VAR, $LIST ) = ( 'expr', 'block', 'var', 'list' );
  my $text = 'with each var in list block';

  print("7:$text\n") if $text =~ qr{
with \s+
(?: each \s+
(?:$EXPR
| $VAR \s* in \s* [(] $LIST [)]
)
| [(] $LIST [)]
)
\s* $BLOCK
}xms;

  print("8:$text\n") if $text =~ m{
with \s+
(?> each \s+ # (?> means:
(?: $EXPR # There can be only
| $VAR \s* in \s* [(] $LIST [)] # one way to match
) # the enclosed set
| [(] $LIST [)] # of alternatives
) # )
\s* $BLOCK
}xms;

  my $ITEM = 'item';
  $text = '(item)';
  print("9:$text\n") if $text =~ m{ [(] $ITEM (?> (?: , $ITEM )* ) [)] }xms;

  leave( ( caller(0) )[3] );
}

# String Comparisons, Prefer fixed-string eq comparisons to fixed-pattern regex matches.
use List::Util qw( any );
Readonly my @EXIT_WORDS => qw( q quit bye exit stop done last finish aurevoir );
# Readonly my @EXIT_WORDS => slurp $EXIT_WORDS_FILE, { chomp => 1 };
Readonly my %IS_EXIT_WORD => map { ( $_ => 1 ) } qw(
  q quit bye exit stop done last finish aurevoir
);

sub match24 {
  enter( ( caller(0) )[3] );

  my @input_lines = ( "q\n", "quit\n", "bye\n", "exit\n", "stop\n", "done\n", "last\n", "finish\n", "aurevoir\n" );
COMMAND:
  while ( my $cmd = <@input_lines> ) {
    # Quit command has several variants...
    # last COMMAND if $cmd eq 'q' || $cmd eq 'quit' || $cmd eq 'bye';
    print("1:$cmd\n") if $cmd eq 'q' || $cmd eq 'quit' || $cmd eq 'bye';

    # Quit command is case-insensitive...
    # last COMMAND if lc($cmd) eq 'quit';
    print("2:$cmd\n") if lc($cmd) eq 'quit';

    # Quit command has several variants...
    # last COMMAND if any { $cmd eq $_ } @EXIT_WORDS;
    print("3:$cmd\n") if any { $cmd eq $_ } @EXIT_WORDS;

    # and later...
    # Quit command has several variants...
    # last COMMAND if $IS_EXIT_WORD{$cmd};
    print("4:$cmd\n") if $IS_EXIT_WORD{$cmd};
  }
  leave( ( caller(0) )[3] );
}

sub example {
  ro();
  my @array = ( 1, 2, 3 );
  printArray( 'array', @array );
  my %hash = (
    one   => 1,
    two   => 2,
    three => 3
  );
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
# chapter12:Chapter 12, Regular Expressions
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/09_perl_best_practices/church/example12.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
