#!perl
#ugly1.pl

my $lines  = 0; # checksum: #lines
my $bytes  = 0; # checksum: #bytes
my $sum  = 0; # checksum: system V sum
my $patchdata = 0; # saw patch data
my $pos  = 0; # start of patch data
my $endkit = 0; # saw end of kit
my $fail  = 0; # failed
