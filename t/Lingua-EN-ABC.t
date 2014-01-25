# This is a test for module Lingua::EN::ABC.

use warnings;
use strict;
use Test::More;
use Lingua::EN::ABC ':all';

my $american;
my $british;

$american = 'I realize the color and flavor in the center of my pajamas';
$british = a2b ($american);
is ($british, 'I realise the colour and flavour in the centre of my pyjamas');
$american = 'I realize you like this flavor';
$british = a2b ($american, oxford => 1);
is ($british, 'I realize you like this flavour'); 

my $canadian = 'the centre of the program is ten metres';
$american = c2a ($canadian);
like ($american, qr/center/);
$british = c2b ($canadian);
like ($british, qr/programme/);

my $canadian2 = a2c ($american);

is ($canadian2, $canadian);

$canadian2 = b2c ($british);

is ($canadian2, $canadian);

done_testing ();


# Local variables:
# mode: perl
# End:
