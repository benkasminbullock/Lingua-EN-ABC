use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Test::More;
my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";
binmode STDOUT, ":encoding(utf8)";
binmode STDERR, ":encoding(utf8)";
use Perl::Build::Pod qw/pod_checker pod_link_checker/;
for my $file ("$Bin/../lib/Lingua/EN/ABC.pod", "$Bin/../lib/Lingua/EN/ABC/Data.pod") {
    my $errors = pod_checker ($file);
    ok (@$errors == 0, "No errors in $file");
    my $linkerrors = pod_link_checker ($file);
    ok (@$linkerrors == 0, "No link errors in $file");
    if (@$linkerrors > 0) {
	for (@$linkerrors) {
	    print "$_\n";
	}
    }
}
done_testing ();
