#!/home/ben/software/install/bin/perl

# Read the lists of words from respell.

use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Path::Tiny;
my $respelldir = '/home/ben/software/respell/respell-0.1';
my $file = path("$respelldir/american");
my @lines = $file->lines ();
for (@lines) {
    chomp;
    if (/^\s*$/) {
	next;
    }
    print "$_\n";
}
