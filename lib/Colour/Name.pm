package Colour::Name;

use 5.028;
use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Exporter ();
our @ISA    = qw [Exporter];
our @EXPORT = qw [rgb $RGB_HEX $RGB_HEX_TRIPLE $RGB_TRIPLE $RGB_RGB];

our $VERSION = '2019020401';

our $RGB_HEX         = 0;
our $RGB_HEX_TRIPLE  = 1;
our $RGB_TRIPLE      = 2;
our $RGB_RGB         = 3;

my $RED   = 0;
my $GREEN = 1;
my $BLUE  = 2;

my @data;
my %colour;
foreach my $line (@data) {
    $line =~ /^\s* \# (?<red>   \p{Hex}{2})
                      (?<green> \p{Hex}{2})
                      (?<blue>  \p{Hex}{2}) \s+ (?<colour>\S+)/x or
                      die "Failed to parse $line\n";

    $colour {$+ {colour}} = [@+ {qw [red green blue]}];
}

################################################################################
#
# rgb ($colour, $style)
#
# Given a colour, returns the RGB values. The (optional) style determines
# in which format the values are returned.
#
# The colour names are case insensitive. Non word characters are ignored.
# For shades of 'gray', both "grey" and "gray" can be used.
#
# The following styles can be used:
#
#   - $RGB_HEX (default): Return a string in the form '#RRGGBB', with
#          the values in hex.
#   - $RGB_HEX_TRIPLE: Return a triple of values (red, green, blue).
#          Each value is a 2 character hex string. In list context,
#          a 3-element list is returned, else a reference to a 3-element
#          array is returned.
#   - $RGB_TRIPLE: Return a triple of values (red, green, blue). Each
#          value is an integer. In list context, a 3-element list is
#          returned, else a reference to a 3-element array is returned.
#   - $RGB_RGB: Return a string in the form 'rgb(RRR,GGG,BBB)'. The values
#          are in decimal.
#
################################################################################

sub rgb ($colour, $style = $RGB_HEX) {
    my $norm = lc $colour =~ s/\W+//gr;
       $norm =~ s/\D\K1$//;
       $norm =~ s/grey/gray/;

    my $RGB = $colour {$norm} or return;

    if ($style == $RGB_HEX) {
        return sprintf "#%s%s%s" => @$RGB;
    }
    elsif ($style == $RGB_HEX_TRIPLE) {
        return wantarray ? [@$RGB] : @$RGB;
    }
    elsif ($style == $RGB_TRIPLE) {
        my @triple = map {hex} @$RGB;
        return wantarray ? [@triple] : @triple;
    }
    elsif ($style == $RGB_RGB) {
        return sprintf "rgb(%d,%d,%d)" => map {hex} @$RGB;
    }
    else {
        die "No such style";
    }
}


BEGIN {
    @data = split /\n/ => <<~ "--";
        #000000 black
        #000000 gray0
        #000000 sgigray0
        #000080 navy
        #000080 navyblue
        #00008b blue4
        #00008b darkblue
        #0000cd blue3
        #0000cd mediumblue
        #0000ee blue2
        #0000ff blue
        #006400 darkgreen
        #00688b deepskyblue4
        #00868b turquoise4
        #008b00 green4
        #008b45 springgreen4
        #008b8b cyan4
        #008b8b darkcyan
        #009acd deepskyblue3
        #00b2ee deepskyblue2
        #00bfff deepskyblue
        #00c5cd turquoise3
        #00cd00 green3
        #00cd66 springgreen3
        #00cdcd cyan3
        #00ced1 darkturquoise
        #00e5ee turquoise2
        #00ee00 green2
        #00ee76 springgreen2
        #00eeee cyan2
        #00f5ff turquoise
        #00fa9a mediumspringgreen
        #00ff00 green
        #00ff7f springgreen
        #00ffff cyan
        #030303 gray
        #050505 gray2
        #080808 gray3
        #0a0a0a gray4
        #0a0a0a sgigray4
        #0d0d0d gray5
        #0f0f0f gray6
        #104e8b dodgerblue4
        #121212 gray7
        #141414 gray8
        #141414 sgigray8
        #171717 gray9
        #1874cd dodgerblue3
        #191970 midnightblue
        #1a1a1a gray10
        #1c1c1c gray11
        #1c86ee dodgerblue2
        #1e1e1e sgigray12
        #1e90ff dodgerblue
        #1f1f1f gray12
        #20b2aa lightseagreen
        #212121 gray13
        #218868 indigo2
        #228b22 forestgreen
        #242424 gray14
        #262626 gray15
        #27408b royalblue4
        #282828 sgigray16
        #282828 sgiverydarkgray
        #292929 gray16
        #2b2b2b gray17
        #2e2e2e gray18
        #2e8b57 seagreen
        #2e8b57 seagreen4
        #2f4f4f darkslategray
        #303030 gray19
        #32cd32 limegreen
        #333333 gray20
        #333333 sgigray20
        #363636 gray21
        #36648b steelblue4
        #383838 gray22
        #388e8e sgiteal
        #3a5fcd royalblue3
        #3b3b3b gray23
        #3cb371 mediumseagreen
        #3d3d3d gray24
        #3d3d3d sgigray24
        #404040 gray25
        #40e0d0 turquoise
        #4169e1 royalblue
        #424242 gray26
        #436eee royalblue2
        #43cd80 seagreen3
        #454545 gray27
        #458b00 chartreuse4
        #458b74 aquamarine4
        #4682b4 steelblue
        #473c8b slateblue4
        #474747 gray28
        #474747 sgigray28
        #483d8b darkslateblue
        #4876ff royalblue
        #48d1cc mediumturquoise
        #4a4a4a gray29
        #4a708b skyblue4
        #4b0082 indigo
        #4d4d4d gray30
        #4eee94 seagreen2
        #4f4f4f gray31
        #4f94cd steelblue3
        #515151 sgigray32
        #525252 gray32
        #528b8b darkslategray4
        #53868b cadetblue4
        #545454 gray33
        #548b54 palegreen4
        #54ff9f seagreen
        #551a8b purple4
        #555555 sgidarkgray
        #556b2f darkolivegreen
        #575757 gray34
        #595959 gray35
        #5b5b5b sgigray36
        #5c5c5c gray36
        #5cacee steelblue2
        #5d478b mediumpurple4
        #5e5e5e gray37
        #5f9ea0 cadetblue
        #607b8b lightskyblue4
        #616161 gray38
        #636363 gray39
        #63b8ff steelblue
        #6495ed cornflowerblue
        #666666 gray40
        #666666 sgigray40
        #668b8b paleturquoise4
        #66cd00 chartreuse3
        #66cdaa aquamarine3
        #66cdaa mediumaquamarine
        #68228b darkorchid4
        #68838b lightblue4
        #6959cd slateblue3
        #696969 dimgray
        #696969 gray41
        #698b22 olivedrab4
        #698b69 darkseagreen4
        #6a5acd slateblue
        #6b6b6b gray42
        #6b8e23 olivedrab
        #6c7b8b slategray4
        #6ca6cd skyblue3
        #6e6e6e gray43
        #6e7b8b lightsteelblue4
        #6e8b3d darkolivegreen4
        #707070 gray44
        #707070 sgigray44
        #708090 slategray
        #7171c6 sgislateblue
        #71c671 sgichartreuse
        #737373 gray45
        #757575 gray46
        #76ee00 chartreuse2
        #76eec6 aquamarine2
        #778899 lightslategray
        #787878 gray47
        #79cdcd darkslategray3
        #7a378b mediumorchid4
        #7a67ee slateblue2
        #7a7a7a gray48
        #7a7a7a sgigray48
        #7a8b8b lightcyan4
        #7ac5cd cadetblue3
        #7b68ee mediumslateblue
        #7ccd7c palegreen3
        #7cfc00 lawngreen
        #7d26cd purple3
        #7d7d7d gray49
        #7d9ec0 sgilightblue
        #7ec0ee skyblue2
        #7f7f7f gray50
        #7fff00 chartreuse
        #7fffd4 aquamarine
        #828282 gray51
        #836fff slateblue
        #838b83 honeydew4
        #838b8b azure4
        #8470ff lightslateblue
        #848484 sgigray52
        #848484 sgimediumgray
        #858585 gray52
        #878787 gray53
        #87ceeb skyblue
        #87cefa lightskyblue
        #87ceff skyblue
        #8968cd mediumpurple3
        #8a2be2 blueviolet
        #8a8a8a gray54
        #8b0000 darkred
        #8b0000 red4
        #8b008b darkmagenta
        #8b008b magenta4
        #8b0a50 deeppink4
        #8b1a1a firebrick4
        #8b1c62 maroon4
        #8b2252 violetred4
        #8b2323 brown4
        #8b2500 orangered4
        #8b3626 tomato4
        #8b3a3a indianred4
        #8b3a62 hotpink4
        #8b3e2f coral4
        #8b4500 darkorange4
        #8b4513 chocolate4
        #8b4513 saddlebrown
        #8b4726 sienna4
        #8b475d palevioletred4
        #8b4789 orchid4
        #8b4c39 salmon4
        #8b5742 lightsalmon4
        #8b5a00 orange4
        #8b5a2b tan4
        #8b5f65 lightpink4
        #8b636c pink4
        #8b6508 darkgoldenrod4
        #8b668b plum4
        #8b6914 goldenrod4
        #8b6969 rosybrown4
        #8b7355 burlywood4
        #8b7500 gold4
        #8b7765 peachpuff4
        #8b795e navajowhite4
        #8b7b8b thistle4
        #8b7d6b bisque4
        #8b7d7b mistyrose4
        #8b7e66 wheat4
        #8b814c lightgoldenrod4
        #8b8378 antiquewhite4
        #8b8386 lavenderblush4
        #8b864e khaki4
        #8b8682 seashell4
        #8b8878 cornsilk4
        #8b8970 lemonchiffon4
        #8b8989 snow4
        #8b8b00 yellow4
        #8b8b7a lightyellow4
        #8b8b83 ivory4
        #8c8c8c gray55
        #8db6cd lightskyblue3
        #8deeee darkslategray2
        #8e388e sgibeet
        #8e8e38 sgiolivedrab
        #8e8e8e sgigray56
        #8ee5ee cadetblue2
        #8f8f8f gray56
        #8fbc8f darkseagreen
        #90ee90 lightgreen
        #90ee90 palegreen2
        #912cee purple2
        #919191 gray57
        #9370db mediumpurple
        #9400d3 darkviolet
        #949494 gray58
        #969696 gray59
        #96cdcd paleturquoise3
        #97ffff darkslategray
        #98f5ff cadetblue
        #98fb98 palegreen
        #9932cc darkorchid
        #999999 gray60
        #999999 sgigray60
        #9a32cd darkorchid3
        #9ac0cd lightblue3
        #9acd32 olivedrab3
        #9acd32 yellowgreen
        #9aff9a palegreen
        #9b30ff purple
        #9bcd9b darkseagreen3
        #9c9c9c gray61
        #9e9e9e gray62
        #9f79ee mediumpurple2
        #9fb6cd slategray3
        #a020f0 purple
        #a0522d sienna
        #a1a1a1 gray63
        #a2b5cd lightsteelblue3
        #a2cd5a darkolivegreen3
        #a3a3a3 gray64
        #a3a3a3 sgigray64
        #a4d3ee lightskyblue2
        #a52a2a brown
        #a6a6a6 gray65
        #a8a8a8 gray66
        #a9a9a9 darkgray
        #aaaaaa sgilightgray
        #ab82ff mediumpurple
        #ababab gray67
        #adadad gray68
        #adadad sgigray68
        #add8e6 lightblue
        #adff2f greenyellow
        #aeeeee paleturquoise2
        #afeeee paleturquoise
        #b03060 maroon
        #b0b0b0 gray69
        #b0c4de lightsteelblue
        #b0e0e6 powderblue
        #b0e2ff lightskyblue
        #b22222 firebrick
        #b23aee darkorchid2
        #b2dfee lightblue2
        #b3b3b3 gray70
        #b3ee3a olivedrab2
        #b452cd mediumorchid3
        #b4cdcd lightcyan3
        #b4eeb4 darkseagreen2
        #b5b5b5 gray71
        #b7b7b7 sgigray72
        #b8860b darkgoldenrod
        #b8b8b8 gray72
        #b9d3ee slategray2
        #ba55d3 mediumorchid
        #bababa gray73
        #bbffff paleturquoise
        #bc8f8f rosybrown
        #bcd2ee lightsteelblue2
        #bcee68 darkolivegreen2
        #bdb76b darkkhaki
        #bdbdbd gray74
        #bebebe gray
        #bf3eff darkorchid
        #bfbfbf gray75
        #bfefff lightblue
        #c0ff3e olivedrab
        #c1c1c1 sgigray76
        #c1cdc1 honeydew3
        #c1cdcd azure3
        #c1ffc1 darkseagreen
        #c2c2c2 gray76
        #c4c4c4 gray77
        #c5c1aa sgibrightgray
        #c67171 sgisalmon
        #c6e2ff slategray
        #c71585 mediumvioletred
        #c7c7c7 gray78
        #c9c9c9 gray79
        #cae1ff lightsteelblue
        #caff70 darkolivegreen
        #cccccc gray80
        #cccccc sgigray80
        #cd0000 red3
        #cd00cd magenta3
        #cd1076 deeppink3
        #cd2626 firebrick3
        #cd2990 maroon3
        #cd3278 violetred3
        #cd3333 brown3
        #cd3700 orangered3
        #cd4f39 tomato3
        #cd5555 indianred3
        #cd5b45 coral3
        #cd5c5c indianred
        #cd6090 hotpink3
        #cd6600 darkorange3
        #cd661d chocolate3
        #cd6839 sienna3
        #cd6889 palevioletred3
        #cd69c9 orchid3
        #cd7054 salmon3
        #cd8162 lightsalmon3
        #cd8500 orange3
        #cd853f peru
        #cd853f tan3
        #cd8c95 lightpink3
        #cd919e pink3
        #cd950c darkgoldenrod3
        #cd96cd plum3
        #cd9b1d goldenrod3
        #cd9b9b rosybrown3
        #cdaa7d burlywood3
        #cdad00 gold3
        #cdaf95 peachpuff3
        #cdb38b navajowhite3
        #cdb5cd thistle3
        #cdb79e bisque3
        #cdb7b5 mistyrose3
        #cdba96 wheat3
        #cdbe70 lightgoldenrod3
        #cdc0b0 antiquewhite3
        #cdc1c5 lavenderblush3
        #cdc5bf seashell3
        #cdc673 khaki3
        #cdc8b1 cornsilk3
        #cdc9a5 lemonchiffon3
        #cdc9c9 snow3
        #cdcd00 yellow3
        #cdcdb4 lightyellow3
        #cdcdc1 ivory3
        #cfcfcf gray81
        #d02090 violetred
        #d15fee mediumorchid2
        #d1d1d1 gray82
        #d1eeee lightcyan2
        #d2691e chocolate
        #d2b48c tan
        #d3d3d3 lightgray
        #d4d4d4 gray83
        #d6d6d6 gray84
        #d6d6d6 sgigray84
        #d6d6d6 sgiverylightgray
        #d8bfd8 thistle
        #d9d9d9 gray85
        #da70d6 orchid
        #daa520 goldenrod
        #db7093 palevioletred
        #dbdbdb gray86
        #dc143c crimson
        #dcdcdc gainsboro
        #dda0dd plum
        #deb887 burlywood
        #dedede gray87
        #e066ff mediumorchid
        #e0e0e0 gray88
        #e0e0e0 sgigray88
        #e0eee0 honeydew2
        #e0eeee azure2
        #e0ffff lightcyan
        #e3e3e3 gray89
        #e5e5e5 gray90
        #e6e6fa lavender
        #e8e8e8 gray91
        #e9967a darksalmon
        #eaeaea sgigray92
        #ebebeb gray92
        #ededed gray93
        #ee0000 red2
        #ee00ee magenta2
        #ee1289 deeppink2
        #ee2c2c firebrick2
        #ee30a7 maroon2
        #ee3a8c violetred2
        #ee3b3b brown2
        #ee4000 orangered2
        #ee5c42 tomato2
        #ee6363 indianred2
        #ee6a50 coral2
        #ee6aa7 hotpink2
        #ee7600 darkorange2
        #ee7621 chocolate2
        #ee7942 sienna2
        #ee799f palevioletred2
        #ee7ae9 orchid2
        #ee8262 salmon2
        #ee82ee violet
        #ee9572 lightsalmon2
        #ee9a00 orange2
        #ee9a49 tan2
        #eea2ad lightpink2
        #eea9b8 pink2
        #eead0e darkgoldenrod2
        #eeaeee plum2
        #eeb422 goldenrod2
        #eeb4b4 rosybrown2
        #eec591 burlywood2
        #eec900 gold2
        #eecbad peachpuff2
        #eecfa1 navajowhite2
        #eed2ee thistle2
        #eed5b7 bisque2
        #eed5d2 mistyrose2
        #eed8ae wheat2
        #eedc82 lightgoldenrod2
        #eedd82 lightgoldenrod
        #eedfcc antiquewhite2
        #eee0e5 lavenderblush2
        #eee5de seashell2
        #eee685 khaki2
        #eee8aa palegoldenrod
        #eee8cd cornsilk2
        #eee9bf lemonchiffon2
        #eee9e9 snow2
        #eeee00 yellow2
        #eeeed1 lightyellow2
        #eeeee0 ivory2
        #f08080 lightcoral
        #f0e68c khaki
        #f0f0f0 gray94
        #f0f8ff aliceblue
        #f0fff0 honeydew
        #f0ffff azure
        #f2f2f2 gray95
        #f4a460 sandybrown
        #f4f4f4 sgigray96
        #f5deb3 wheat
        #f5f5dc beige
        #f5f5f5 gray96
        #f5f5f5 whitesmoke
        #f5fffa mintcream
        #f7f7f7 gray97
        #f8f8ff ghostwhite
        #fa8072 salmon
        #faebd7 antiquewhite
        #faf0e6 linen
        #fafad2 lightgoldenrodyellow
        #fafafa gray98
        #fcfcfc gray99
        #fdf5e6 oldlace
        #ff0000 red
        #ff00ff magenta
        #ff1493 deeppink
        #ff3030 firebrick
        #ff34b3 maroon
        #ff3e96 violetred
        #ff4040 brown
        #ff4500 orangered
        #ff6347 tomato
        #ff69b4 hotpink
        #ff6a6a indianred
        #ff6eb4 hotpink
        #ff7256 coral
        #ff7f00 darkorange
        #ff7f24 chocolate
        #ff7f50 coral
        #ff8247 sienna
        #ff82ab palevioletred
        #ff83fa orchid
        #ff8c00 darkorange
        #ff8c69 salmon
        #ffa07a lightsalmon
        #ffa500 orange
        #ffa54f tan
        #ffaeb9 lightpink
        #ffb5c5 pink
        #ffb6c1 lightpink
        #ffb90f darkgoldenrod
        #ffbbff plum
        #ffc0cb pink
        #ffc125 goldenrod
        #ffc1c1 rosybrown
        #ffd39b burlywood
        #ffd700 gold
        #ffdab9 peachpuff
        #ffdead navajowhite
        #ffe1ff thistle
        #ffe4b5 moccasin
        #ffe4c4 bisque
        #ffe4e1 mistyrose
        #ffe7ba wheat
        #ffebcd blanchedalmond
        #ffec8b lightgoldenrod
        #ffefd5 papayawhip
        #ffefdb antiquewhite
        #fff0f5 lavenderblush
        #fff5ee seashell
        #fff68f khaki
        #fff8dc cornsilk
        #fffacd lemonchiffon
        #fffaf0 floralwhite
        #fffafa snow
        #ffff00 yellow
        #ffffe0 lightyellow
        #fffff0 ivory
        #ffffff gray100
        #ffffff sgigray100
        #ffffff white
    --
}

1;

__END__

=head1 NAME

Colour::Name - Abstract

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/Colour-Name.git >>.

=head1 AUTHOR

Abigail, L<< mailto:cpan@abigail.be >>.

=head1 COPYRIGHT and LICENSE

Copyright (C) 2019 by Abigail.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),   
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 INSTALLATION

To install this module, run, after unpacking the tar-ball, the 
following commands:

   perl Makefile.PL
   make
   make test
   make install

=cut
