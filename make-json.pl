#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Table::Readable 'read_table';
use Deploy 'older';
use FindBin;
use JSON::Parse;
use JSON::Create;
use Devel::Peek;
use boolean;

my $outfile = "$FindBin::Bin/lib/Lingua/EN/ABC/abc.json";
my $infile = "$FindBin::Bin/abc.txt";

#if (! older ($outfile, $infile)) {
#    exit;
#}

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
    if ($bits{m}) {
	$bits{bam} = true;
    }
    if ($bits{n}) {
	$bits{aam} = true;
    }
    push @stuff, \%bits;
}
my $jc = JSON::Create->new ();
$jc->bool ('boolean');
my $json = $jc->run (\@stuff);
open my $out, ">", $outfile or die $!;
print $out $json;
close $out or die $!;

