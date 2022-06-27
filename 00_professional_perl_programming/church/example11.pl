#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;
#use diagnostics;
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
  ### String Interpolation ###
  my $result = 6 * 7;
  print "The answer is $result \n";

### Interpolating Metacharacters and Character Codes ###
  # Character      Description
  # \000..\377     An ASCII code in octal
  # \a             Alarm (ASCII 7)
  # \b             Backspace (ASCII 8)
  # \c<chr>        A control character (e.g. \cg is ctrl-g, ASCII 7, same as \a)
  # \e             Escape character (ASCII 27)
  # \E             End effect of \L, \Q, or \U.
  # \f             Form Feed (New Page) character (ASCII 12)
  # \l             Lowercase next character
  # \L             Lowercase all following characters to end of string or \E
  # \n             Newline character (ASCII 10 on UNIX, 13+10 on Windows, etc.)
  # \N{name}       A named character
  # \Q             Escape (backslash) all non-alphanumeric characters to end of string or \E
  # \r             Return character (usually ASCII 13)
  # \t             Tab character (ASCII 8)
  # \u             Uppercase next character
  # \U             Uppercase all following characters to end of string or \E
  # \x<code>       An ASCII code 00 to ff in hexadecimal
  # \x{<code>}     A UTF8 Unicode character code in hexadecimal
  # \\, \$, \@, \" A literal backslash, dollar sign, at sign or double quote. The backslash
  #    disables the usual metacharacter meaning. These are actually just the
  #    specific cases of general escapes that are most likely to cause trouble as
  #    unescaped characters.

  ### Common Special Characters ###
  # Newlines on a Macintosh
  print "This is a new line in octal \012\015";
  print "This is a new line in control characters \cJ\cM";

### Special Effects ####
  print "\lPolish\n";    # produce 'polish'
  print "\uperl\n";      # produce 'Perl'

  print "This is \Uupper\E case\n";    # produces UPPER
  print "This is \LLOWER\E case\n";    # produces lower

  my $surname = "rOBOTHAM";
  print "\u\L$surname\E\n";            # produces 'Robotham'

  my $church = "\Uchurch\E";
  print $church, "\n";                 #works well
  $church = "church";
  print "\U$church\E\n";               #works well

### Interpolating Variables ###
  my @array = ( 1, 2, 3, 4 );
  $\ = "\n";
  print @array;                        # display '1234'
  print "@array";                      # display '1 2 3 4'
  $, = ',';                            # change the output field separator
  print @array;                        # display '1, 2, 3, 4'
  print "@array";                      # still display '1 2 3 4'
  $" = ':';                            #" change the interpolated list separator
  print "@array";                      # display '1:2:3:4'
  $\ = "";

  my $var = "Hello ";
  # print "Greetings, $varWorld \n"; # try to interpolate $varWorld
  print "Greetings, ${var}World \n";    # interpolate $var

### Interpolating Code ###
  # print out the data from first 10 characters of scalar 'gmtime'
  print "Today is ${\ substr(scalar(gmtime), 0, 10)} \n";

  my %hash = ( one => 1, two => 2 );
  # print out the keys of a hash
  print "Keys: @{[keys %hash]}\n";
  # print out the time, hms
  print "The time is @{[reverse((gmtime)[0..2])]} exactly \n";

  # subtract each array element from its maximum index
  print "Mapping \@array:@{[map{$_ = $#array-$_}@array]}\n";

### Interpolative Context ###
  print qx(date);
### Interpolation in Regular Expressions ###
  my @var   = ( "one", "two", "three" );
  my $index = 1;

  $_ = "one two three";
  my $match = /$var[$index]/;
  print("match = $match\n");
  # $text =~ s/($this|$that|$other)/$spare/;

### Interpolating Text Inside String Variables ###
  @array = ( 1, 2, 3, 4 );
  my $text = '@array';    # note the single quotes!
  print "$text\n";        # produce '@array'
  print eval $text, "\n"; # produce 1234

  $text = 'The array contains: @array' . "\n";
  print eval '"' . $text . '"';    # produce 'The array contains: 1 2 3 4'
  print eval "\"$text\"";          # an alternative way to do the same thing
  print eval qq("$text");          # and another

### Protecting Strings Against Interpolation ###
  my $contents = '@array contains ' . join( ', ', @array ) . "\n";
  print("contents = $contents\n");

  # escape all backlashes, at signs and dollar characters
  $text = 'A $scalar, an @array and a \backslash';
  $text =~ s/([\$\@\\])/\\$1/mg;
  print $text . "\n";              # produce 'A \$scalar, an \@array, and a \\backslash'

  $text = '"$" denotes a scalar variable';
  $text = quotemeta $text;
  print $text . "\n";              # display '\"\$\"\ denotes\ a\ scalar\ variable'
  print eval qq("$text\n");        # display '"$" denotes a scalar variable'

  $text = "That's double+ good";
  my $pattern = "double+";
  print "Matched1\n" if $text =~ /\Q$pattern/;    # return 'Matched'
  $text = "That's double plus good";
  print "Matched2\n" if $text =~ /$pattern/;      # (incorrectly) return 'Matched'
  print "Matched3\n" if $text =~ /\Q$pattern/;    # do not match, return nothing.
  $pattern = quotemeta($pattern);
  print "Matched4\n" if $text =~ /$pattern/;      # now pattern don't match, returns nothing.
}

sub ro1 {
  ### Regular Expressions ###
  my $matchtext = "ball,bell";
  print "Matched!\n" if $matchtext =~ /b.ll/;
  # match 'ball', 'bell', 'bill', 'boll', 'bull', ...
  my @array = ( $matchtext =~ m/b.ll/g );
  printArray( '@array', @array );

### This interpolation can be an expensive process, so we also have means to optimize it. ###
  # Eagerness: it will try to match as soon as possible
  # Greediness: it will try to match as much as possible
  # Relentlessness: it will try every possible combination before giving up

### Matching and Substitution ###
  my @particles = ( 'proton', 'electron', 'neutron' );
  foreach (@particles) {
    # page 347
    /proton/   and print("A positive match \n")   and last;
    /electron/ and print("Negative influence \n") and last;
    /neutron/  and print("Ambivalent \n")         and last;
  }

  # next if /^\s*#/; # test $_ and reject comments

  # split text into pieces around commas plus whitespace
  my $text   = "this is , a, test,";
  my @values = split( '\s*,\s*', $text );
  printArray( '@values', @values );
  # the same statement written in a more regexp style
  @values = split /\s*,\s*/, $text;
  printArray( '@values', @values );

  # split $_ on whitespace, explicitly (leading whitespace returns an empty value)
  # @words = split /\s+/,$_;
  # split $_ on whitespace, implicitly (leading whitespace does not return an empty value)
  # @words = split;
  # The same as 'split' on its own
  # @words = split ' ';

### Pre-compiled Regular Expressions ###
  # an arbitrary complex regexp, precompiled into $re
  my $complex = "xyz";
  #my $re      = qr/^a.*?\b ([l|L]ong)\s+(and|&)\s+(?:$complex\spattern)/igsm;
  my $re = qr/^a.*?\b ([l|L]ong)\s+(and|&)\s+(?:$complex\spattern)/ism;
  $text = "abc long and xyz pattern";
  # 'if' statement is much more legible.
  if ( $text =~ $re ) {
    print("matched 1 = $1\n");
    print("matched 2 = $2\n");
    # print("matched = $3\n");
  } else {
    print("do not match\n");
  }
### Regular Expression Delimiters ###
  my $atom = 'proton';
  print("matched 1 \n") if $atom =~ /proton/;             # traditional match, no 'm'
  print("matched 2 \n") if $atom =~ m|proton|;            # match with pipes
  print("matched 3 \n") if $atom =~ m ?proton?;           # match with a space and question marks
  print("matched 4 \n") if $atom =~ s/proton/neutron/;    # traditional substitution
  $atom = 'proton';
  print("substitution 5 $atom \n") if $atom =~ s|proton|neutron|;    # substitution with pipes
  $atom = 'proton';
  print("substitution 6 $atom \n") if $atom =~ s'proton'neutron';    # substitution with single quotes
                                                                     #', for humanized
  my @items = split m|\s+|, $text;                                   # split using pipes
  printArray( '@items', @items );
  @items = split( ',', $text );                                      # traditional split using quotes
  printArray( '@items', @items );

  $atom = 'proton';
  print("substitution 7 $atom \n") if ( $atom =~ s#proton#neutron# );    # substitution with '#' signs
  $atom = 'proton';
  print("substitution 8 $atom \n") if $atom =~ s{proton} {neutron};      # the pattern and the replacement
  $atom = 'proton';
  print("substitution 9 $atom \n") if $atom =~ s[proton]<neutron>;

### Elements of Regular Expressions ###
  # Metacharacters
  # Pattern match modifiers
  # Anchors
  # Extended Patterns

  # $match = $colors =~ /red/; # literal pattern 'red'
  # $match = $colors =~ / red /; # match ' red '
  # $match = $colors =~ /\sred\s/; # match ' red ', '<tab>red\n' ...
  # $match = $colors =~ /\bred\b/;
  # $match = $colors =~ /\bred\b/i; # match 'red', 'RED', 'rEd' ...
  # $match = $colors =~ /^red/; # match 'red' at the start of the string
  # $match = $colors =~ /red$/; # match 'red' at the end of the string
  # $match = $colors =~ /^red$/; # match whole line to 'red'
  # $match = ($colors eq 'red'); # the same thing, with 'eq'

### More Advanced Patterns ###

  # $matchtext =~ /b.ll/; # match 'ball', 'bell', 'bill', 'boll', 'bull'...
  # $matchtext =~ /b[aeiou]ll/;
  # only match 'ball', 'bell', 'bill', 'boll', or 'bull'
  # $hasadigit =~ /[0123456789]/; # match 0 to 9
  # $hasdigit =~ /[0-9]/; # also match 0 to 9 (as does the \d metacharacter)

### Repetition and Grouping ###

  my ( $min, $max ) = ( 2, 4 );
  my $sheep = "baaa!";
  if ( $sheep =~ /ba{$min,$max}!/ ) {    # equivalent to '/ba{2,4}!/'
    print "match : $sheep\n";
  }

  $text = "one:two:three:four:five";
  # extract the 4th field of colon separated data
  $text =~ /(([^:]*):?){4}/;
  print "Got: $2\n";                     # print 'Got: four'

### Eagerness, Greediness, and Relentlessness ###
  my $match = '';
  $sheep = "baa baaaaaaaaaa";
  while ( $sheep =~ /(baa+)/g ) {
    $match = $1 if length($1) > length($match);
  }
  # print 'The loudest sheep said 'baaaaaaaaaa''
  print "The loudest sheep said '$match' \n";

### Lean (Non-Greedy) Matches ###
  #    (word)?? Match zero or one occurrence
  #    (word)*? Match zero or more occurrences
  #    (word)+? Match one or more occurrence
  #    (word){1,3}? Match one to three occurrences
  #    (word){0,}? Match zero or more occurrences (same as *?)

  ### Repetition and Anchors ###
  repanchor1_pl();
  repanchor2_pl();

### Matching Sequential and Overlapping Terms ###
  $text = '/proton|neutron/';
  print("matched!\n") if $text =~ /proton|neutron/;    # true if either proton or neutron present

  ### Pattern Match Modifiers ###
  # Modifier Description
  # /i Case-insensitive: match regardless of case
  # /g Global match: match as many times as possible
  # /m Treat text as multiple lines: allow anchors to match before and after newline
  # /o Compile once: interpolate and compile the search pattern only once
  # /s Treat text as single line: allow newlines to match
  # /x Expanded regular expression: allow documentation within search pattern
  my $matched = 'the fullmonty';
  print("full monty!\n") if $matched =~ /fullmonty/igmosx;    # the full monty!
  ### Regular Expressions versus Wildcards ###
  # wildre1_pl();
  # wildre2_pl();

  $re = 'file[0-9]*.*';
  $re =~ s/([^\w\s])/($1 eq '?')?'.'
:($1 eq '*')?'.*' :($1 eq '[' || $1 eq ']')?$1
:"\\$1"/eg;
  print "^$re\$\n";    #anchor at both ends

  $re = 'file[0-9]*.*';
  $re =~ s/(.)/($1 eq '?')?'.'
:($1 eq '*')?'.*'
:($1 eq '[' || $1 eq ']')?$1
:"\Q$1"/eg;
  print "^$re\$\n";    #anchor at both ends

  ### Metacharacters ###
  ### Character Class Metacharacters ###
  # Metacharacter Match Property
  # \d Match any digit - equivalent to the character class [0..9].
  # \D Match any non-digit - equivalent to the character class [^0-9].
  # \s Match any whitespace character - equivalent to the character class [ \t\r\n].
  # \S Match any non-whitespace character - equivalent to the character class [^\t\r\n] or [^\s].
  # \w Match any 'word' or alphanumeric character, which is the set of all upper and
  # lower case letters, the numbers 0..9 and the underscore character _, usually
  # equivalent to the character class [a-zA-Z0-9_].
  # The definition of 'word' is also affected by the locale if use locale has been
  # used, so an e will also be considered a match for \w if we are working in
  # French, but not if we are working in English.

  # \W The inverse of \w, matches any 'non-word' character. Equivalent to the
  # character class [^a-zA-Z0-9_] or [^\w].
  # [:class:] POSIX character class, for example, [:alpha:] for alphanumeric characters.

  # \p Match a property, for example, \p{IsAlpha} for alphanumeric characters.
  # \P Match a non-property, for example, \P{IsUpper} for non-uppercase characters.
  # \X Match a multi-byte Unicode character ('combining character sequence').
  # \C Match a single octet, even if interpretation of multi-byte characters is enabled(with use utf8).

### Description POSIX Character Classes Property Metacharacter ###
  # Alphabetical character [:alpha:] \p{IsAlpha}
  # Alphanumeric character [:alnum:] \p{IsAlnum}
  # ASCII character [:ascii:] \p{IsASCII} (equivalent to [\x00-\x7f])
  # Control character [:cntrl:] \p{IsCntrl} (equivalent to [\x00-\x20])
  # Numeric [:digit:] \p{IsDigit} (equivalent to \d)
  # Graphical character [:graph:] \p{IsGraph} (equivalent to [[:alnum:][:punct:]])
  # Lower case character [:lower:] \p{IsLower}
  # Printable character [:print:] \p{IsPrint} (equivalent to [[:alnum:][:punct:][:space:]])
  # Punctuation [:punct:] \p{IsPunct}
  # Whitespace [:space:] \p{IsSpace} (equivalent to \s)
  # Upper case character [:upper:] \p{IsUpper}
  # Word character [:word:] \p{IsWord} (equivalent to \w)
  # Hexadecimal digit [:xdigit:] \p{IsXDigit} (equivalent to [/0-9a-fA-F/])

### Zero-Width Metacharacters ###

### Extracting Matched Text ###
### Special Variables ###
  special_pl();
  substr_pl();

### Parentheses and Numbered Variables ###
  parentheses_pl();
  extended_pl();

  overwrite1_pl();
  overwrite2_pl();
  repeat3_pl();

### Backreferences ###
  $text = '"text"';
  $text =~ /('|")(.*?)$1/;    # do not match single or double quoted strings
                              #', for humanized
  print "Found 1 quote:$1$2$1\n";
  $text =~ /('|")(.*?)\1/;    # do match single or double quoted strings
                              #', for humanized
  print "Found 2 quote:$1$2$1\n";
  $text =~ /\1(.*?)('|")/;    # ERROR: backreference before backreference definition!
                              #', for humanized
  print "Found 3 quote:$1$2$1\n";
  $text =~ /('|")([^\1]*)\1/;
  #', for humanized
  print "Found 4 quote:$1$2$1\n";

  $text = "a\b\b\b\b\b\b\b\b\b\b";
  print("matched\n") if $text =~ /^(.)(.)(.)(.)(.)(.)(.)(.)(.)(.)\x08/;    # match 10 chrs followed by a backspace

### Extracting Lines with the Range Operator ###
  # The /g pattern match modifier to extract all the matches
  # The /s pattern match modifier to allow newlines to match the dot
  # The /m pattern match modifier so the ^ and $ anchors will match newlines within the text
  # (note that this can be combined with /s) and makes the extracted text pattern non-greedy
  $text = "START\nabc\nFINISH\n";
  print("matched = $1\n") if $text =~ /^START$(.*?)^FINISH$/msg;
  range_pl();
  # header_pl();
}

sub repanchor1_pl {
  # repanchor1.pl
  use warnings;
  use strict;
  my @input_lines = ( "line 1\n", "\n", "line 2\n", "line 3\n", );
  while (<@input_lines>) {
    chomp;                       # strip trailing linefeed from $_
    next if /^(\s*(#.*)?)?$/;    # skip blank lines and comments
    print "Got: $_ \n";
  }
}

sub repanchor2_pl {
  # repanchor2.pl
  use warnings;
  use strict;
  my @input_lines = ( "line 1\n", "\n", "line 2\n", "line 3\n", );
  while (<@input_lines>) {
    chomp;                       # strip trailing linefeed from $_
    next if /^\s*($|#)/;         # skip blank lines and comments
    print "Got: $_ \n";
  }
}

sub wildre1_pl {
  # wildre.pl
  use warnings;
  use strict;
  $| = 1;                        # enable autoflush for prompt display of prompt (sic)
  print "Wildcard: \n";
  my @input_lines = ( 'file[0-9]*.*' . "\n" );
  while (<@input_lines>) {
    print $_, "\n";
    chomp;
    print "Regular Expression: ", wild2re1($_), "\n";
    print "Wildcard: \n";
  }

  sub wild2re1 {
    my $re = shift;
    $re =~ s/([^\w\s])/($1 eq '?')?'.'
:($1 eq '*')?'.*' :($1 eq '[' || $1 eq ']')?$1
:"\\$1"/eg;
    return "^$re\$";    #anchor at both ends
  }
}

sub wildre2_pl {
  # wildre.pl
  use warnings;
  use strict;
  $| = 1;               # enable autoflush for prompt display of prompt (sic)
  print "Wildcard: \n";
  my @input_lines = ( 'file[0-9]*.*' . "\n" );
  while (<@input_lines>) {
    print $_, "\n";
    chomp;
    print "Regular Expression: ", wild2re2($_), "\n";
    print "Wildcard: \n";
  }

  sub wild2re2 {
    my $re = shift;
    $re =~ s/(.)/($1 eq '?')?'.'
:($1 eq '*')?'.*'
:($1 eq '[' || $1 eq ']')?$1
:"\Q$1"/eg;
    return "^$re\$";    #anchor at both ends
  }
}

### Special Variables ###
sub special_pl {
  # special.pl
  use warnings;
  use strict;
  my $text = "One Two Three 456 Seven Eight 910 Eleven Twelve";
  while ( $text =~ /[0-9]+/g ) {
    print " \$& = $& \n \$` = $` \n \$' = $' \n";
  }
}

sub substr_pl {
  # substr.pl
  use warnings;
  use strict;
  my $text = "One Two Three 456 Seven Eight 910 Eleven Twelve";
  $text =~ /[0-9]+/;
  while ( $text =~ /[0-9]+/g ) {
    my $prefix = substr( $text, 0,     $-[0] );            # equals $`
    my $match  = substr( $text, $-[0], $+[0] - $-[0] );    # equals $&
    my $suffix = substr( $text, $+[0] );                   # equals $'
    print " \$match = $match \n \$prefix = $prefix \n \$suffix = $suffix \n";
  }
}

sub parentheses_pl {
  # parentheses.pl
  use warnings;
  use strict;
  my $text = "Testing";
  if ( $text =~ /((T|N)est(ing|er))/ ) {
    print " \$1 = $1 \n" if ($1);
    print " \$2 = $2 \n" if ($2);
    print " \$3 = $3 \n" if ($3);
    print " \$4 = $4 \n" if ($4);
    print "count = $#- \n";
  }
}

sub extended_pl {
  # extended.pl
  use warnings;
  use strict;
  my $text = "Testing";
  if ( $text =~ /((?:T|N)est(ing|er))/ ) {
    print " \$1 = $1 \n" if ($1);
    print " \$2 = $2 \n" if ($2);
    print " \$3 = $3 \n" if ($3);
    print " \$4 = $4 \n" if ($4);
    print "count = $#- \n";
  }
}

sub overwrite1_pl {
  # overwrite1.pl
  use warnings;
  use strict;
  my $text = "one:two:three:four:five";
  # match non-colon characters optionally followed by a colon, 3 times
  if ( $text =~ /(([^:]+):?){3}/ ) {
    print " \$1 = $1 \n \$2 = $2 \n";
  }
}

sub overwrite2_pl {
  # overwrite2.pl
  use warnings;
  use strict;
  my $text = "one:two:three:four:five";
  # match non-colon characters optionally followed by a colon, 3 times
  if ( $text =~ /^(([^:]+):?)(([^:]+):?)(([^:]+):?)/ ) {
    print " \$2 = $2 \n \$4 = $4 \n \$6 = $6 \n";
  }
}

sub repeat3_pl {
  # repeat3.pl
  use warnings;
  use strict;
  my $text = "one:two:three:four:five";
  while ( $text =~ /(([^:]+):?)/g ) {
    print " \$1 = $1 \n \$2 = $2 \n";
  }
}

sub range_pl {
  # range.pl
  use warnings;
  use strict;
  my @records;    # list of found records
  my $collect     = "";                                                         # collection variable for records
  my $in          = 0;                                                          # flag to check if we've just completed a record
  my @input_lines = ( "START\nabc\nFINISH\n", "START\nxyz\nFINISH\n", "out" );
  while (<@input_lines>) {
    print "Considering:$_\n";
    if ( /^START/ ... /^FINISH/ ) {
      # range is true - we are inside a record
      print "In \n";
      # collect lines for record
      $collect .= $_;
      $in = 1;
    } else {
      # false - we are outside a record
      if ( not $in ) {
        # we were already outside
        print "Out \n";
      } else {
        # we have just left, found a collect
        print "In -> Out \n";
        # add collected lines to list
        push @records, $collect;
        # clear the collection variable
        $collect = "";
        # set flag to say we are out
        $in = 0;
      }
    }
  }
  foreach ( 0 .. $#records ) {
    print "Record $_: \n$records[$_] \n";
  }
}

sub header_pl {
  # header.pl
  use warnings;
  use strict;
  my ( @head, @body );
  my @input_lines = ( "<head>HEAD</head>\n", "<body>BODY</body>\n", );
  $. = 0;
  while (<@input_lines>) {
    if ( 1 .. /^$/ ) {
      push @head, $_;
    } else {
      push @body, $_;
      last;    # found start of body, quit loop
    }
  }
  push @body, <>;
  print "Head: \n", join( '', @head );
  print "Body: \n", join( '', @body );
}

sub ro2 {
  ### Matching More than Once ###
  ### Regular Expressions and Loops ###
  my $text    = "one two three";
  my $matched = $text =~ /\b(\w+)\b/g;    # match once...
  print $1, "\n";                         # print first word found which is 'one'
  my @matches = $text =~ /\b\w+\b/g;      # collect all words

  @matches = $text =~ /\b\w+\b/g;
  foreach (@matches) {
    print "matches:", $_, "\n";
  }
  globalloop_pl();

  ### Nested Regular Expression Loops ###
  nest1_pl();
  nest2_pl();
  nest3_pl();

### Position ###
  position_pl();

### Moving the Start Anchor to the Current Position ###
  $text = "\t \t \tabc";
  print("matched = $text\n") if $text =~ s/^(\s+)/'-' x length($1)/mge;
  $text = "\t \t \tabc";
  pos($text) = 0;
  print("matched = $text\n") if $text =~ s/\G\s/-/mg;

### Retaining Position between Regular Expressions ###
  liftoff_pl();

### Matching In and Across Multiple Lines ###
  mflag_pl();
  sflag_pl();

  ### Counting the Total Number of Matches ###
  my $count = 0;
  my $atom  = "\bproton\b;\bproton\b";
  while ( $atom =~ /\bproton\b/g ) {
    $count++;
  }
  print("count = $count\n");
  $count = scalar( $atom =~ /\bproton\b/g );
  print("count = $count\n");

  ### Overlapping Matches and Zero-Width Patterns ###
  vowels1_pl();
  zerowidthloop_pl();
  vowels2_pl();
  greely_pl();
}

sub globalloop_pl {
  # globalloop.pl
  use warnings;
  use strict;
  my $text = "one, two, three, four";
  # iterate over matches with foreach and $_
  foreach ( $text =~ /\b\w+\b/g ) {
    print $_, "\n";
  }
  # iterate over matches with while and $1
  while ( $text =~ /\b(\w+)\b/g ) {
    print $1, "\n";
  }
}

sub nest1_pl {
  # nest1.pl
  use warnings;
  use strict;
  my $text = "one, two, three, four";
  # iterate over matches with foreach and $_
  foreach ( $text =~ /\b(\w+)\b/g ) {
    print "outer: got: $_, matched: $&, extracted: $1 \n";
    foreach (/(\w)/g) {
      print "\tinner: got: $_, matched $&, extracted $1 \n";
    }
  }
}

sub nest2_pl {
  # nest2.pl
  use warnings;
  use strict;
  my $text = "one, two, three, four";
  # iterate over matches with foreach and $_
  while ( $text =~ /\b(\w+)\b/g ) {
    print "outer: matched: $&, extracted: $1 \n";
    while ( $1 =~ /(\w)/g ) {
      print "\tinner: matched $&, extracted $1 \n";
    }
  }
}

sub nest3_pl {
  # nest3.pl
  use warnings;
  use strict;
  my $text = "one, two, three, four";
  # iterate over matches with foreach and $_
  while ( $text =~ /\b(\w+)\b/g ) {
    print "outer: matched: $&, extracted: $1 \n";
    my $inner = $1;
    while ( $inner =~ /(\w)/g ) {
      print "\tinner: matched $&, extracted $1 \n";
    }
  }
}

sub position_pl {
  # position.pl
  use warnings;
  use strict;
  my $text = "one, two, three, four";
  # display matches with their positions
  while ( $text =~ /\b(\w+)\b/g ) {
    print "matched $1 at position ", pos($text), "\n";
    last if pos($text) > 15;    # add by church
    pos($text) = 0 if pos($text) > 15;
  }
}

sub liftoff_pl {
  # liftoff.pl
  use warnings;
  use strict;
  my $text = "3 2 1 liftoff";
  # use /gc to remember position
  while ( $text =~ /(\d)/gc ) {
    print "$1...\n";
  }
  # use \G to match rest of text
  if ( $text =~ /\G\s*(.+)$/ ) {
    print ucfirst($1), "!\n";
  }
}

sub mflag_pl {
  # mflag.pl
  use warnings;
  use strict;
  # put <> into slurp mode
  undef $/;
  # read configuration file supplied on command line into string
  my @input_lines   = ( "name1 = value1 \n", "name2 = value2 \n", "name3 = value3 \n", );
  my $configuration = <@input_lines>;
  my %config;
  # read all configuration options from config string
  while ( $configuration =~ /^\s*(\w+)\s* = \s*(.+?)\s*$/mg ) {
    $config{$1} = $2;
  }
  print "Got: $_ => '$config{$_}'\n" foreach ( sort keys %config );
}

sub sflag_pl {
  # sflag.pl
  use warnings;
  use strict;
  undef $/;
  my @input_lines = ( "item:value1\n", "item:value2\n", "item:value3\n", );
  my $database    = <@input_lines>;
  my @records;
  while ( $database =~ /item:(.*?)(?=item:|$)/sg ) {
    my $record = $1;
    $record =~ s/\n/ /g;
    push @records, $record;
  }
  print "Got: $_\n" foreach @records;
}

sub vowels1_pl {
  # vowels1.pl
  use warnings;
  use strict;
  my $text = "beautiful creature";
  # find adjacent vowels
  while ( $text =~ /([aeiou]{2})/g ) {
    print "Found adjacent '$1' at position ", pos($text), "\n";
  }
}

sub zerowidthloop_pl {
  # zerowidthloop.pl
  use warnings;
  use strict;
  my $text = "proton";
  while ( $text =~ /(?=(.))/g ) {
    print "[$1]";
  }
}

sub vowels2_pl {
  # vowels2.pl
  use warnings;
  use strict;
  my $text = "beautiful creature";
  # find adjacent vowels
  while ( $text =~ /(?=([aeiou]{2}))/g ) {
    print "Found adjacent '$1' at position ", pos($text), "\n";
  }
}

sub greely_pl {
  # Greely.pl
  use warnings;
  use strict;
  my $company = 'Greely Greely & Spatz';
  my $match   = $company;                  #set to longest possible match
  while ( $company =~ /(Greely)(?=(.*?Spatz))/g ) {
    my $got = $1 . $2;                     #assemble match from both parts
    $match = $got if length($got) < length($match);
  }
  print "Shortest possible match is '$match' \n";
}

sub ro3 {
  ### Extended Patterns ###
### Documenting Regular Expressions ###
### Writing Efficient Regular Expressions ###
  my $text = 'name = value';
  print("matched 1: $1 = $2\n") if $text =~ /(.*) = (.*)/;       # bad
  print("matched 1: $1 = $2\n") if $text =~ /(\w*) = (\S*)/;     # better
  print("matched 1: $1 = $2\n") if $text =~ /^(\w+) = (\S+)/;    # even better

  $text = 'startswith\?';
  print("matched: greedy $1\n")     if $text =~ /^(.*)\\?/;      # greedy match
  print("matched: non-greedy $1\n") if $text =~ /^(.*?)\\?/;     # non-greedy match

### Avoiding Recompilation with the Empty Pattern ###
### Avoiding Recompilation with the 'once-only' Modifier ###
  # while (/($search_pattern)/g) { ... } # reinterpolates each time
  # while (/($search_pattern)/go) { ... } # quicker - interpolates once
### Generating Regular Expressions with 'eval' ###
  system("perl multisearch.pl -t one -t two search.txt");
  system("perl multifind.pl -t one -t two search.txt");
  system("perl multifind.pl -t one -t two -a search.txt");

### Predefining Search Patterns with 'qr' ###
  # $re = qr/^a.*?pattern/; # define a regexp
  # if ($re){ ... } # use regexp without delimiters
  # if (/$re/o) { ... } # use regexp with delimiters and modifier

### Using Pattern Match Modifiers with 'qr' ###
### Using 'qr' as a Replacement for the 'once-only' Modifier ###
  regb_pl();

### Checking the Validity of Regular Expressions ###
  checkre1_pl();
  checkre2_pl();
  quote_pl();

### Understanding and Debugging the Regular Expression Engine ###
  debugre_pl();
}

sub regb_pl {
  # regb.pl
  use strict;
  undef $/;
  my @input_lines = ( 'red', 'green', 'blue' );
  my $text        = <@input_lines>;
  my ( $this, $that, $other ) = ( 'red', 'green', 'blue' );
  my $pattern = qr/($this|$that)/;
  while ( $text =~ /$pattern/g ) {
    if ( $1 eq $this ) {
      print "Found '$this' - rotating\n";
      ( $this, $that, $other ) = ( $that, $other, $this );
      $pattern = qr/($this|$that)/;
    } else {
      print "Found '$that' - staying put\n";
    }
  }
}

sub checkre1_pl {
  # checkre1.pl
  use warnings;
  use strict;
  my @input_lines = ( 'red', 'green', 'blue' );
  while (<@input_lines>) {
    chomp;
    eval { qr/$_/; };
    print $@? "Error in '$_': $@\n" : "'$_' is legal \n";
  }
}

sub checkre2_pl {
  # checkre2.pl
  use warnings;
  use strict;
  my @input_lines = ( 'red', 'green', 'blue' );
  while (<@input_lines>) {
    chomp;
    if ( my $re = compile_re($_) ) {
      print "Pattern ok: $re \n";
    } else {
      print "Illegal pattern: $@ \n";
    }
  }

  sub compile_re {
    my $pattern = shift;
    my $re;    # local package variable
    eval { $re = qr/$pattern/; };
    return $re;    #undef on error
  }
}

sub quote_pl {
  # quote.pl
  use warnings;
  use strict;
  $| = 1;
  print "Enter a pattern: \n";
  # my $pattern = <>;
  my $pattern = 'pattern';
  chomp $pattern;
  print "Enter some search text: \n";
  #my $input = <>;
  my $input = 'I have the pattern!';
  if ( $input =~ /\Q$pattern\E/ ) {
    print "'$&' found! \n";
  }
}

sub debugre_pl {
  # debugre.pl
  use warnings;
  use strict;
  use re 'debug';
  my $matchtext = "helium contains two protons, two neutrons and two electrons";
  my $re        = qr/(\w+\s(?:proton|neutron)s?)/;
  while ( $matchtext =~ /$re/g ) {
    print "Found $1 \n";
  }
  no re 'debug';
}

sub ro4 {
  ### Substitution ###
  my $text = 'one. two. three.';
  print("new: $text\n") if $text =~ s/\.[ ]+/.\n/;    # put each sentence on a new line

### Evaluating the Replacement String ###
  quality_pl();

### Transliteration ###
  $text = 'abc';
  print("tr1: $text\n") if $text =~ tr/abc/zyx/;

  my $vowel_count = 0;
  $text = "\t\naeiou\t \nxyz\n";
  print("tr2: $text,$vowel_count\n") if ( $vowel_count = $text =~ tr/aeiou/aeiou/ );
  print("tr3: $text\n") if $text =~ tr/a-fz/A-FZ/;

  print("tr4: $text\n") if $text =~ tr/\t\n/ /;

  $text = "HAL";
  $text =~ tr/\x00-\xfe/\x01-\xff/;
  # \x00 is a long way of saying \0 but it looks better here
  print $text, "\n";    # produces 'IBM'

  $text = 'abcdefghijklmn';
  # Finally, here is an implementation of ROT-13,
  # which swaps the first half of the alphabet with the second:
  print("tr5: $text\n") if $text =~ tr/a-nA-Nm-zM-Z/m-zM-Za-nA-N/;

### Transliteration Modifiers ###
  print("tr6: $text\n") if $text =~ tr/a-zA-Z\t\n/?/c;
  # uppercase a-z and delete existing A-Z
  print("tr7: $text\n") if $text =~ tr/a-zA-Z/A-Z/d;

  # translate any whitespace to literal space and remove resulting duplicates
  print("tr8: $text\n") if $text =~ tr/\t\n//s;

  # remove duplicate alphanumeric characters
  print("tr9: $text\n") if $text =~ tr/a-zA-Z0-9/s/;

  # here is an improved duplicate character eliminator that works for any character at all:
  print("tr10: $text\n") if $text =~ tr///cs;

}

sub quality_pl {
  # quality.pl
  use warnings;
  use strict;
  my $text = "3 Stumps, 2 Bails, and 0 Vogons";
  $text =~ s/\b(\d+)\b/$1 > 0?$1 > 1?$1 > 2? "Several":"A pair of":"One":"No"/ge;
  print $text, "\n";
}

# https://perldoc.perl.org/perlre

sub example {
  ro4();
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
# chapter11:Chapter 11 Regular Expressions
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example11.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
