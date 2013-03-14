# This is a test for module Lingua::EN::ABC.

use warnings;
use strict;
use Test::More;
use Lingua::EN::ABC ':all';

my $american = 'The color and flavor in the center of my pajamas';
my $british = a2b ($american);
is ($british, 'The colour and flavour in the centre of my pyjamas');
done_testing ();
# Local variables:
# mode: perl
# End:
