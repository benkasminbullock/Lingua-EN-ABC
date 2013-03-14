# This is a test for module Lingua::EN::ABC.

use warnings;
use strict;
use Test::More;
use Lingua::EN::ABC ':all';

my $american = 'I realize the color and flavor in the center of my pajamas';
my $british = a2b ($american);
is ($british, 'I realise the colour and flavour in the centre of my pyjamas');
$american = 'I realize you like this flavor';
$british = a2b ($american, oxford => 1);
is ($british, 'I realize you like this flavour'); 
done_testing ();
# Local variables:
# mode: perl
# End:
