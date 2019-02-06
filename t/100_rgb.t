#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

use Colour::Name;

my @tests = (
    [cyan         =>  '00ffff'],
    [springgreen  =>  '00ff7f'],
    [seagreen     =>  '2e8b57'],
    [seagreen4    =>  '2e8b57'],
    [steelblue    =>  '4682b4'],
    [deeppink1    =>  'ff1493'],
);

foreach my $test (@tests) {
    my ($name, $exp_rgb) = @$test;

    my $got_rgb = rgb $name;
    is $got_rgb, "#$exp_rgb", "rgb ('$name') eq '#$exp_rgb'";

       $got_rgb = rgb $name, $RGB_HEX;
    is $got_rgb, "#$exp_rgb", "rgb ('$name', \$RGB_HEX) eq '#$exp_rgb'";

    my ($exp_red, $exp_green, $exp_blue) = $exp_rgb =~ /(..)(..)(..)/;

    $got_rgb = rgb $name => $RGB_HEX_TRIPLET;
    is_deeply $got_rgb, [$exp_red, $exp_green, $exp_blue],
       "rgb ('$name', \$RGB_HEX_TRIPLET) is " .
           "['$exp_red', '$exp_green', '$exp_blue'] (scalar context)";

    my @got_rgb = rgb $name => $RGB_HEX_TRIPLET;
    is_deeply \@got_rgb, [$exp_red, $exp_green, $exp_blue],
       "rgb ('$name', \$RGB_HEX_TRIPLET) is " .
           "('$exp_red', '$exp_green', '$exp_blue') (list context)";

    $got_rgb = rgb $name => $RGB_TRIPLET;
    is_deeply $got_rgb, [map {hex} $exp_red, $exp_green, $exp_blue],
       "rgb ('$name', \$RGB_TRIPLET) is " .
           "[" . (hex $exp_red) . ", " . (hex $exp_green) . ", " .
                 (hex $exp_blue) . "] (scalar context)";

    @got_rgb = rgb $name => $RGB_TRIPLET;
    is_deeply \@got_rgb, [map {hex} $exp_red, $exp_green, $exp_blue],
       "rgb ('$name', \$RGB_TRIPLET) is " .
           "(" . (hex $exp_red) . ", " . (hex $exp_green) . ", " .
                 (hex $exp_blue) . ") (list context)";

    $got_rgb = rgb $name => $RGB_RGB;
    my $exp_rgb_rgb = sprintf "rgb(%d,%d,%d)" => map {hex} $exp_red,
                                                           $exp_green,
                                                           $exp_blue;
    is_deeply $got_rgb, $exp_rgb_rgb,
       "rgb ('$name', \$RGB_RGB) eq '$exp_rgb_rgb'";
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
