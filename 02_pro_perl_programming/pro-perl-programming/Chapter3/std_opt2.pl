#!perl
#std_opt2.pl

use Getopt::Std;

getopts('abc');

print "$opt_a\n";
print "$opt_b\n";
print "$opt_c\n";
print "@ARGV\n"

