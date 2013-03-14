=encoding UTF-8

=head1 NAME

Lingua::EN::ABC - American, British, and Canadian English

=head1 SYNOPSIS

    use Lingua::EN::ABC ':all';
    my $colour = a2b ('color');

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 a2b

    my $british = a2b ('color');
    # $british = 'colour'.

Convert British spellings into American spellings.

=head2 b2a

=head2 a2c

=head2 c2a

=head2 b2c

=head2 c2b

=cut
package Lingua::EN::ABC;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/a2b b2a a2c c2a b2c c2b/;
%EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
use warnings;
use strict;
use Carp;
use JSON::Parse 'json_file_to_perl';

our $VERSION = 0.01;

# Load the data from the file.

my $json = __FILE__;
$json =~ s!\.pm$!/abc.json!;
my $abc = json_file_to_perl ($json);

sub a2b
{
    my ($text, %options) = @_;
    my $oxford = $options{oxford};
    for my $e (@$abc) {
	if ($oxford && $e->{oxford}) {
	    # Skip spellings marked as Oxford.
	    next;
	}
	my $american = $e->{a};
	my $british = $e->{b};
	if ($e->{bam}) {
	    # The British spelling is ambiguous, e.g. metre/meter,
	    # programme/program.
	    $british .= "/$e->{a}";
	}
	$text =~ s/\b$american\b/$british/g;
    }
    return $text;
}

sub b2a
{
    my ($text) = @_;
    return $text;
}

sub a2c
{
    my ($text) = @_;
    return $text;
}

sub c2a
{
    my ($text) = @_;
    for my $e (@$abc) {
	if ($e->{oxford} || $e->{ca}) {
	    # Skip spellings marked as Oxford and spellings where
	    # Canadian is the same as American.
	    next;
	}
	my $american = $e->{a};
	my $canadian = $e->{b};
	if ($e->{bam}) {
	    # The British spelling is ambiguous, e.g. metre/meter,
	    # programme/program.
	    $canadian .= "/$e->{a}";
	}
	$text =~ s/\b$american\b/$canadian/g;
    }
    return $text;
}

sub c2b
{
my ($text) = @_;
return $text;
}

sub b2c
{
my ($text) = @_;
return $text;
}

1;
