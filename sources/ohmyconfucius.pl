#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Path::Tiny;
use JSON::Parse 'json_file_to_perl';
my $have = json_file_to_perl ("$Bin/../lib/Lingua/EN/ABC/abc.json");
my %american;
my %british;
for my $words (@$have) {
    $american{$words->{a}} = 1;
    $british{$words->{b}} = 1;
}
my $in = "$Bin/Ohconfucius.txt";
my $text = path($in)->slurp_utf8 ();
if (! utf8::is_utf8 ($text)) {
    die "Fucked up";
}
# Strip unnecessary formatting
my $newtext = $text;
$newtext =~ s/(\|-?\s*)?(?:valign|width|height)="[^"]*"//g;
$newtext =~ s/\{\|.*//g;
$newtext =~ s/.*\|\}//g;
$newtext =~ s/^#.*//g;
$newtext =~ s/^.*'''.*'''.*$//gm;
#print $newtext;
my $matchre = qr/((?:\s*\|(?:.*)\n){4})/;
while ($newtext =~ /$matchre/g) {
    my $match = $1;
    $match =~ s/^(?:\||\s+)+//;
    my @words = split /(?:\||\s+)+/, $match;
    @words = map {s/\s+//gr} @words;
    my ($am, $br, $ca) = @words;
    $ca =~ s/\*$//;
    # Reject bad entries
    if ($br =~ /(?:
		    sapour
		|
		    naivety
		|
		    chilli
		|
		    \(noun\)
		|
		    yogurt
		)/x
	||
	$am =~ /(?:
		    supercalif
	       )/x) {
	next;
    }
    if (! $american{$am} || ! $british{$br}) {
	if ($ca eq $am) {
	    $ca = 'a';
	}
	elsif ($ca eq $br) {
	    $ca = 'b';
	}
	# Oxford spelling
	my $o = '';
	if ($br =~ /s[ey]$/ && $am =~ /z[ey]$/) {
	    $o = "o: t\n";
	}
	print <<EOF;
b: $br
a: $am
c: $ca
$o
EOF
#	print "WORDS ", join (', ', @words), "\n";
    }
    else {
#	print "Already have @words\n";
    }
}
$newtext =~ s/$matchre//g;
$newtext =~ s/\s+//g;
if (length $newtext != 0) {
    print "Final is $newtext\n";
}
my @stuff;
