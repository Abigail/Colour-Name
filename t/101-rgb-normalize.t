#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

use Colour::Name;

my @tests = (
    [yellow  =>  qw [Yellow YELLOW yeLLow Y-elL!oW?], 'Ye LL ow--'],
);

foreach my $test (@tests) {
    my $base = shift @$test;
    my $exp_rgb = rgb $base;
    foreach my $variant (@$test) {
        my $got_rgb = rgb $variant;
        is $got_rgb, $exp_rgb, "rgb ('$base') eq rgb ('$variant')";
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
