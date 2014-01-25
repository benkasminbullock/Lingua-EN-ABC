use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/Lingua/EN/ABC.pm';
my $repo = 'https://github.com/benkasminbullock/Lingua-EN-ABC';

WriteMakefile (
    NAME => 'Lingua::EN::ABC',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
	'JSON::Parse' => '0.23',
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
    INST_SCRIPT => 'script',
    # Speculated necessary version of Perl. I have no test results
    # which say otherwise.
    MIN_PERL_VERSION => '5.006001',
);
