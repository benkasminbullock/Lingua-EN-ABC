#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Path::Tiny;
use JSON::Parse 'json_file_to_perl';
use Text::Table::Tiny '0.04', 'generate_table';
system ("$Bin/make-json.pl");
my $in = "$Bin/lib/Lingua/EN/ABC/abc.json";
my $out = "$Bin/lib/Lingua/EN/ABC/Data.pod";
my $words = json_file_to_perl ($in);
my $headers = [qw/American British Canadian BrAmbig? AmAmbig? Oxford?/];
my @words = sort {lc $a->{a} cmp lc $b->{a}} @$words;
my @table;
push @table, $headers;
for my $word (@words) {
    my @row;
    push @row, $word->{a}, $word->{b};
    my $ca = $word->{ca};
    if ($ca) {
	push @row, $word->{a};
    }
    else {
	push @row, $word->{b};
    }
    for my $field (qw/bam aam oxford/) {
	if ($word->{$field}) {
	    push @row, 'Y';
	}
	else {
	    push @row, '';
	}
    }
    push @table, \@row;
}
my $tabletxt =<<EOF;
=head1 NAME

Lingua::EN::ABC::Data

=head1 DESCRIPTION

This is the underlying data file for L<Lingua::EN::ABC>. It is put
here to make it easy to find, search, and check.

The headings "BrAmbig" and "AmAmbig" are for words where the British
or American version of the word is ambiguous, like "metre" and "meter"
in British English, or "vice" and "vise" in American English.

=head1 TABLE

EOF
my $table = generate_table (rows => \@table, header_row => 1);
# podify
$table =~ s/(^|\n)/$1    /g;
$tabletxt .= $table . "\n";
path($out)->spew_utf8 ($tabletxt);

