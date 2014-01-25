=encoding UTF-8

=head1 NAME

Lingua::EN::ABC - American, British, and Canadian English

=head1 SYNOPSIS

    use Lingua::EN::ABC ':all';
    my $colour = a2b ('color');

=head1 DESCRIPTION

This is an experimental module. This module offers functions to
convert between the spellings and vocabulary of American, British, and
Canadian versions of English. The interface is described below.

=head1 FUNCTIONS

=head2 a2b

    my $british = a2b ('color');
    # $british = 'colour'.

An option C<oxford> controls whether to use Oxford spelling (realize
rather than realise):

    my $oxford_british = a2b ('realize', oxford => 1);

=head2 b2a

    my $american = b2a ('the colour of my pyjamas');
    # $american = 'the color of my pajamas'

Convert British spellings into American spellings.

=head2 a2c

    my $canadian = a2c ('the color');
    # $canadian = 'the colour'

Convert American to Canadian spelling.

=head2 c2a

    my $american = c2a ('the color');
    # $american = 'the colour'

Convert Canadian to American spelling.

=head2 b2c

    my $canadian = b2c ('the programme');
    # $canadian = 'the program'

Convert British to Canadian spelling.

=head2 c2b

    my $british = c2b ($canadian);

Convert Canadian to British spelling. An option C<oxford> controls
whether to use Oxford spelling (realize rather than realise):

    my $oxford_british = c2b ($canadian, oxford => 1);

=head1 SEE ALSO

This module's design is up for discussion. You can either use the
Github issues page at
L<https://github.com/benkasminbullock/Lingua-EN-ABC/issues> or the
Prepan site at L<http://prepan.org/module/nXWEF3to2nu>.

The file containing the spelling variations is "abc.txt" in the top
directory of the distribution.

=head1 AUTHOR

Ben Bullock, <bkb@cpan.org>

=head1 LICENCE

This program and associated files may be used, copied, distributed,
and modified under the same terms as Perl itself.

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

our $VERSION = 0.03;

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
    for my $e (@$abc) {
	my $american = $e->{a};
	my $british = $e->{b};
	if ($e->{aam}) {
	    $american .= "/$e->{b}";
	}
	$text =~ s/\b$british\b/$american/g;
    }
    return $text;
}

sub a2c
{
    my ($text) = @_;
    for my $e (@$abc) {
	if ($e->{ca} || $e->{o}) {
	    next;
	}
	my $american = $e->{a};
	my $canadian = $e->{b};
	if ($e->{bam}) {
	    $canadian .= "/$e->{a}";
	}
	$text =~ s/\b$american\b/$canadian/g;
    }
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
	$text =~ s/\b$canadian\b/$american/g;
    }
    return $text;
}

sub c2b
{
    my ($text, %options) = @_;
    for my $e (@$abc) {
	if ($options{oxford} && $e->{oxford}) {
	    # Do not convert Oxford spellings.
	    next;
	}
	# Here we do not check the value of ca, but just convert any
	# American spellings which may be found in the Canadian text.
	my $canadian = $e->{a};
	my $british = $e->{b};
	$text =~ s/\b$canadian\b/$british/g;
    }
    return $text;
}

sub b2c
{
    my ($text) = @_;
    for my $e (@$abc) {
	if ($e->{ca}) {
	    # Convert the word if this is spelt differently in Canada
	    # and the UK.
	    my $canadian = $e->{a};
	    my $british = $e->{b};
	    $text =~ s/\b$british\b/$canadian/g;
	}
    }
    return $text;
}

1;
