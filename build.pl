#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Perl::Build;
perl_build (
    pod => ['lib/Lingua/EN/ABC.pod',],
    pre => './make-data-pod.pl',
);
exit;
