#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Table::Readable 'read_table';
use FindBin '$Bin';
use JSON::Parse;
use JSON::Create;
use boolean;

my $outfile = "$Bin/lib/Lingua/EN/ABC/abc.json";
my $infile = "$Bin/abc.txt";

my @entries = read_table ($infile);

my @stuff;

for my $entry (@entries) {
    my %bits;
    $bits{a} = $entry->{a};
    $bits{b} = $entry->{b};
    $bits{ca} = ($entry->{c} eq 'a') ? true : false;
    if ($entry->{o} && $entry->{o} eq 't') {
	$bits{oxford} = true;
    }
    if ($entry->{m}) {
	$bits{bam} = true;
    }
    if ($entry->{n}) {
	$bits{aam} = true;
    }
    if ($entry->{s}) {
	$bits{s} = true;
    }
    else {
	$bits{s} = false;
    }
    push @stuff, \%bits;
}
my $jc = JSON::Create->new ();
$jc->bool ('boolean');
my $json = $jc->run (\@stuff);
open my $out, ">", $outfile or die $!;
print $out $json;
close $out or die $!;

