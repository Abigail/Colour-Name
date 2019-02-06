#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

BEGIN {
    use_ok ('Colour::Name') or
        BAIL_OUT ("Loading of 'Colour::Name' failed");
}

ok defined $Colour::Name::VERSION, "VERSION is set";

ok defined &rgb, "rgb() exported";

ok defined $RGB_HEX,         '$RGB_HEX exported';
ok defined $RGB_HEX_TRIPLET, '$RGB_HEX_TRIPLET exported';
ok defined $RGB_TRIPLET,     '$RGB_TRIPLET exported';
ok defined $RGB_RGB,         '$RGB_RGB exported';

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
