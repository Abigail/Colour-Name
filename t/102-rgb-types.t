#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

use Colour::Name;

is rgb ('Grey76'),               '#c2c2c2', 'Colours default to RGB type';
is rgb ('Grey76', undef, 'SGI'), '#c1c1c1', 'Use the SGI type';
is rgb ('Grey76', undef, 'RGB'), '#c2c2c2', 'Use the RGB type';
is rgb ('SGI:Grey76'),           '#c1c1c1', 'Use the SGI type prefix';
is rgb ('RGB:Grey76'),           '#c2c2c2', 'Use the RGB type prefix';


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
