package Colour::Name;

use 5.028;
use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Exporter ();
our @ISA     = qw [Exporter];
our @EXPORT  = qw [rgb $RGB_HEX $RGB_HEX_TRIPLET $RGB_TRIPLET $RGB_RGB];

our $VERSION = '2019020401';

our $RGB_HEX          = 0;
our $RGB_HEX_TRIPLET  = 1;
our $RGB_TRIPLET      = 2;
our $RGB_RGB          = 3;

my $RED   = 0;
my $GREEN = 1;
my $BLUE  = 2;

my @data;
my %colour;
foreach my $line (@data) {
    next unless $line =~ /\S/;
    $line =~ /^\s* \# (?<red>   \p{Hex}{2})
                      (?<green> \p{Hex}{2})
                      (?<blue>  \p{Hex}{2}) \s+
                     ((?<class>[^:]+):\s*)?
                      (?<colour>.*\S) \s* $/x or
                      die "Failed to parse $line\n";

    my @RGB    = @+ {qw [red green blue]};
    my $class  = $+ {class} // "RGB";
    my $colour = $+ {colour};

    $colour    =~ s/[^a-zA-Z0-9]+//;
    $colour    =  lc $colour;

    $colour {$colour}        //= \@RGB;
    $colour {"$class:$colour"} = \@RGB;
}


################################################################################
#
# rgb ($colour, $style)
#
# Given a colour, returns the RGB values. The (optional) style determines
# in which format the values are returned.
#
# The colour names are case insensitive. Non word characters are ignored.
# For shades of 'grey', both "gray" and "grey" can be used.
#
# The following styles can be used:
#
#   - $RGB_HEX (default): Return a string in the form '#RRGGBB', with
#          the values in hex.
#   - $RGB_HEX_TRIPLET: Return a triple of values (red, green, blue).
#          Each value is a 2 character hex string. In list context,
#          a 3-element list is returned, else a reference to a 3-element
#          array is returned.
#   - $RGB_TRIPLET: Return a triple of values (red, green, blue). Each
#          value is an integer. In list context, a 3-element list is
#          returned, else a reference to a 3-element array is returned.
#   - $RGB_RGB: Return a string in the form 'rgb(RRR,GGG,BBB)'. The values
#          are in decimal.
#
################################################################################

sub rgb ($colour, $style = $RGB_HEX, $class = undef) {
    if (!$class && $colour =~ s/^([a-zA-Z]+)://) {
        $class = $1;
    }
    my $norm = (lc $colour) =~ s/[^a-z0-9]+//gr;
       $norm =~ s/gray/grey/;

    my $RGB = $class ? $colour {"$class:$norm"} : $colour {$norm} or return;

    if (!$style || $style == $RGB_HEX) {
        return sprintf "#%s%s%s" => @$RGB;
    }
    elsif ($style == $RGB_HEX_TRIPLET) {
        return wantarray ? @$RGB : [@$RGB];
    }
    elsif ($style == $RGB_TRIPLET) {
        my @triple = map {hex} @$RGB;
        return wantarray ? @triple : [@triple];
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
        #000000 Black
        #000000 Grey0
        #000080 Navy
        #000080 Navy Blue
        #00008b Blue4
        #00008b Dark Blue
        #0000cd Blue3
        #0000cd Medium Blue
        #0000ee Blue2
        #0000ff Blue
        #0000ff Blue1
        #006400 Dark Green
        #00688b Deep Sky Blue4
        #00868b Turquoise4
        #008b00 Green4
        #008b45 Spring Green4
        #008b8b Cyan4
        #008b8b Dark Cyan
        #009acd Deep Sky Blue3
        #00b2ee Deep Sky Blue2
        #00bfff Deep Sky Blue
        #00bfff Deep Sky Blue1
        #00c5cd Turquoise3
        #00cd00 Green3
        #00cd66 Spring Green3
        #00cdcd Cyan3
        #00ced1 Dark Turquoise
        #00e5ee Turquoise2
        #00ee00 Green2
        #00ee76 Spring Green2
        #00eeee Cyan2
        #00f5ff Turquoise1
        #00fa9a Medium Spring Green
        #00ff00 Green
        #00ff00 Green1
        #00ff7f Spring Green
        #00ff7f Spring Green1
        #00ffff Cyan
        #00ffff Cyan1
        #030303 Grey1
        #050505 Grey2
        #080808 Grey3
        #0a0a0a Grey4
        #0d0d0d Grey5
        #0f0f0f Grey6
        #104e8b Dodger Blue4
        #121212 Grey7
        #141414 Grey8
        #171717 Grey9
        #1874cd Dodger Blue3
        #191970 Midnight Blue
        #1a1a1a Grey10
        #1c1c1c Grey11
        #1c86ee Dodger Blue2
        #1e90ff Dodger Blue
        #1e90ff Dodger Blue1
        #1f1f1f Grey12
        #20b2aa Light Sea Green
        #212121 Grey13
        #228b22 Forest Green
        #242424 Grey14
        #262626 Grey15
        #27408b Royal Blue4
        #292929 Grey16
        #2b2b2b Grey17
        #2e2e2e Grey18
        #2e8b57 Sea Green
        #2e8b57 Sea Green4
        #2f4f4f Dark Slate Grey
        #303030 Grey19
        #32cd32 Lime Green
        #333333 Grey20
        #363636 Grey21
        #36648b Steel Blue4
        #383838 Grey22
        #3a5fcd Royal Blue3
        #3b3b3b Grey23
        #3cb371 Medium Sea Green
        #3d3d3d Grey24
        #404040 Grey25
        #40e0d0 Turquoise
        #4169e1 Royal Blue
        #424242 Grey26
        #436eee Royal Blue2
        #43cd80 Sea Green3
        #454545 Grey27
        #458b00 Chartreuse4
        #458b74 Aquamarine4
        #4682b4 Steel Blue
        #473c8b Slate Blue4
        #474747 Grey28
        #483d8b Dark Slate Blue
        #4876ff Royal Blue1
        #48d1cc Medium Turquoise
        #4a4a4a Grey29
        #4a708b Sky Blue4
        #4d4d4d Grey30
        #4eee94 Sea Green2
        #4f4f4f Grey31
        #4f94cd Steel Blue3
        #525252 Grey32
        #528b8b Dark Slate Grey4
        #53868b Cadet Blue4
        #545454 Grey33
        #548b54 Pale Green4
        #54ff9f Sea Green1
        #551a8b Purple4
        #556b2f Dark Olive Green
        #575757 Grey34
        #595959 Grey35
        #5c5c5c Grey36
        #5cacee Steel Blue2
        #5d478b Medium Purple4
        #5e5e5e Grey37
        #5f9ea0 Cadet Blue
        #607b8b Light Sky Blue4
        #616161 Grey38
        #636363 Grey39
        #63b8ff Steel Blue1
        #6495ed Cornflower Blue
        #666666 Grey40
        #668b8b Pale Turquoise4
        #66cd00 Chartreuse3
        #66cdaa Aquamarine3
        #66cdaa Medium Aquamarine
        #68228b Dark orchid4
        #68838b Light Blue4
        #6959cd Slate Blue3
        #696969 Dim Grey
        #696969 Grey41
        #698b22 Olive Drab4
        #698b69 Dark Sea Green4
        #6a5acd Slate Blue
        #6b6b6b Grey42
        #6b8e23 Olive Drab
        #6c7b8b Slate Grey4
        #6ca6cd Sky Blue3
        #6e6e6e Grey43
        #6e7b8b Light Steel Blue4
        #6e8b3d Dark Olive Green4
        #707070 Grey44
        #708090 Slate Grey
        #737373 Grey45
        #757575 Grey46
        #76ee00 Chartreuse2
        #76eec6 Aquamarine2
        #778899 Light Slate Grey
        #787878 Grey47
        #79cdcd Dark Slate Grey3
        #7a378b Medium Orchid4
        #7a67ee Slate Blue2
        #7a7a7a Grey48
        #7a8b8b Light Cyan4
        #7ac5cd Cadet Blue3
        #7b68ee Medium Slate Blue
        #7ccd7c Pale Green3
        #7cfc00 Lawn Green
        #7d26cd Purple3
        #7d7d7d Grey49
        #7ec0ee sky Blue2
        #7f7f7f Grey50
        #7fff00 Chartreuse
        #7fff00 Chartreuse1
        #7fffd4 Aquamarine
        #7fffd4 Aquamarine1
        #828282 Grey51
        #836fff Slate Blue1
        #838b83 Honeydew4
        #838b8b Azure4
        #8470ff Light Slate Blue
        #858585 Grey52
        #878787 Grey53
        #87ceeb Sky Blue
        #87cefa Light Sky Blue
        #87ceff Sky Blue1
        #8968cd Medium Purple3
        #8a2be2 Blue Violet
        #8a8a8a Grey54
        #8b0000 Dark Red
        #8b0000 Red4
        #8b008b Dark Magenta
        #8b008b Magenta4
        #8b0a50 Deep Pink4
        #8b1a1a Firebrick4
        #8b1c62 Maroon4
        #8b2252 Violet Red4
        #8b2323 Brown4
        #8b2500 Orange Red4
        #8b3626 Tomato4
        #8b3a3a Indian Red4
        #8b3a62 Hot Pink4
        #8b3e2f Coral4
        #8b4500 Dark Orange4
        #8b4513 Chocolate4
        #8b4513 Saddle Brown
        #8b4726 Sienna4
        #8b475d Pale Violet Red4
        #8b4789 Orchid4
        #8b4c39 Salmon4
        #8b5742 Light Salmon4
        #8b5a00 Orange4
        #8b5a2b Tan4
        #8b5f65 Light Pink4
        #8b636c Pink4
        #8b6508 Dark Goldenrod4
        #8b668b Plum4
        #8b6914 Goldenrod4
        #8b6969 Rosy Brown4
        #8b7355 Burly Wood4
        #8b7500 Gold4
        #8b7765 Peach Puff4
        #8b795e Navajo White4
        #8b7b8b Thistle4
        #8b7d6b Bisque4
        #8b7d7b Misty Rose4
        #8b7e66 Wheat4
        #8b814c Light Goldenrod4
        #8b8378 Antique White4
        #8b8386 Lavender Blush4
        #8b864e Khaki4
        #8b8682 Sea Shell4
        #8b8878 Corn Silk4
        #8b8970 Lemon Chiffon4
        #8b8989 Snow4
        #8b8b00 Yellow4
        #8b8b7a Light Yellow4
        #8b8b83 Ivory4
        #8c8c8c Grey55
        #8db6cd Light Sky Blue3
        #8deeee Dark Slate Grey2
        #8ee5ee Cadet Blue2
        #8f8f8f Grey56
        #8fbc8f Dark Sea Green
        #90ee90 Light Green
        #90ee90 Pale Green2
        #912cee Purple2
        #919191 Grey57
        #9370db Medium Purple
        #9400d3 Dark Violet
        #949494 Grey58
        #969696 Grey59
        #96cdcd Pale Turquoise3
        #97ffff Dark Slate Grey1
        #98f5ff Cadet Blue1
        #98fb98 Pale Green
        #9932cc Dark Orchid
        #999999 Grey60
        #9a32cd Dark Orchid3
        #9ac0cd Light Blue3
        #9acd32 Olive Drab3
        #9acd32 Yellow Green
        #9aff9a Pale Green1
        #9b30ff Purple1
        #9bcd9b Dark Sea Green3
        #9c9c9c Grey61
        #9e9e9e Grey62
        #9f79ee Medium Purple2
        #9fb6cd Slate Grey3
        #a020f0 Purple
        #a0522d Sienna
        #a1a1a1 Grey63
        #a2b5cd Light Steel Blue3
        #a2cd5a Dark Olive Green3
        #a3a3a3 Grey64
        #a4d3ee Light Sky Blue2
        #a52a2a Brown
        #a6a6a6 Grey65
        #a8a8a8 Grey66
        #a9a9a9 Dark Grey
        #ab82ff Medium Purple1
        #ababab Grey67
        #adadad Grey68
        #add8e6 Light Blue
        #adff2f Green Yellow
        #aeeeee Pale Turquoise2
        #afeeee Pale Turquoise
        #b03060 Maroon
        #b0b0b0 Grey69
        #b0c4de Light Steel Blue
        #b0e0e6 Powder Blue
        #b0e2ff Light Sky Blue1
        #b22222 Firebrick
        #b23aee Dark Orchid2
        #b2dfee Light Blue2
        #b3b3b3 Grey70
        #b3ee3a Olive Drab2
        #b452cd Medium Orchid3
        #b4cdcd Light Cyan3
        #b4eeb4 Dark Sea Green2
        #b5b5b5 Grey71
        #b8860b Dark Goldenrod
        #b8b8b8 Grey72
        #b9d3ee Slate Grey2
        #ba55d3 Medium Orchid
        #bababa Grey73
        #bbffff Pale Turquoise1
        #bc8f8f Rosy Brown
        #bcd2ee Light Steel Blue2
        #bcee68 Dark Olive Green2
        #bdb76b Dark Khaki
        #bdbdbd Grey74
        #bebebe Grey
        #bf3eff Dark Orchid1
        #bfbfbf Grey75
        #bfefff Light Blue1
        #c0ff3e Olivedrab1
        #c1cdc1 Honeydew3
        #c1cdcd Azure3
        #c1ffc1 Dark Sea Green1
        #c2c2c2 Grey76
        #c4c4c4 Grey77
        #c6e2ff Slate Grey1
        #c71585 Medium Violet Red
        #c7c7c7 Grey78
        #c9c9c9 Grey79
        #cae1ff Light Steel Blue1
        #caff70 Dark Olive Green1
        #cccccc Grey80
        #cd0000 Red3
        #cd00cd Magenta3
        #cd1076 Deep Pink3
        #cd2626 Firebrick3
        #cd2990 Maroon3
        #cd3278 Violet Red3
        #cd3333 Brown3
        #cd3700 Orange Red3
        #cd4f39 Tomato3
        #cd5555 Indian Red3
        #cd5b45 Coral3
        #cd5c5c Indian Red
        #cd6090 Hot Pink3
        #cd6600 Dark Orange3
        #cd661d Chocolate3
        #cd6839 Sienna3
        #cd6889 Pale Violet Red3
        #cd69c9 Orchid3
        #cd7054 Salmon3
        #cd8162 Light Salmon3
        #cd8500 Orange3
        #cd853f Peru
        #cd853f Tan3
        #cd8c95 Light Pink3
        #cd919e Pink3
        #cd950c Dark Goldenrod3
        #cd96cd Plum3
        #cd9b1d Golden Rod3
        #cd9b9b Rosy Brown3
        #cdaa7d Burly Wood3
        #cdad00 Gold3
        #cdaf95 Peach Puff3
        #cdb38b Navajo White3
        #cdb5cd Thistle3
        #cdb79e Bisque3
        #cdb7b5 Misty Rose3
        #cdba96 Wheat3
        #cdbe70 Light Goldenrod3
        #cdc0b0 Antique White3
        #cdc1c5 Lavender Blush3
        #cdc5bf Sea Shell3
        #cdc673 Khaki3
        #cdc8b1 Corn Silk3
        #cdc9a5 Lemon Chiffon3
        #cdc9c9 Snow3
        #cdcd00 Yellow3
        #cdcdb4 Light Yellow3
        #cdcdc1 Ivory3
        #cfcfcf Grey81
        #d02090 Violet Red
        #d15fee Medium Orchid2
        #d1d1d1 Grey82
        #d1eeee Light Cyan2
        #d2691e Chocolate
        #d2b48c Tan
        #d3d3d3 Light Grey
        #d4d4d4 Grey83
        #d6d6d6 Grey84
        #d8bfd8 Thistle
        #d9d9d9 Grey85
        #da70d6 Orchid
        #daa520 Goldenrod
        #db7093 Pale Violet Red
        #dbdbdb Grey86
        #dcdcdc Gainsboro
        #dda0dd Plum
        #deb887 Burly Wood
        #dedede Grey87
        #e066ff Medium Orchid1
        #e0e0e0 Grey88
        #e0eee0 Honey Dew2
        #e0eeee Azure2
        #e0ffff Light Cyan
        #e0ffff Light Cyan1
        #e3e3e3 Grey89
        #e5e5e5 Grey90
        #e6e6fa Lavender
        #e8e8e8 Grey91
        #e9967a Dark Salmon
        #ebebeb Grey92
        #ededed Grey93
        #ee0000 Red2
        #ee00ee Magenta2
        #ee1289 Deep Pink2
        #ee2c2c Firebrick2
        #ee30a7 Maroon2
        #ee3a8c Violet Red2
        #ee3b3b Brown2
        #ee4000 Orange Red2
        #ee5c42 Tomato2
        #ee6363 Indian Red2
        #ee6a50 Coral2
        #ee6aa7 Hot Pink2
        #ee7600 Dark Orange2
        #ee7621 Chocolate2
        #ee7942 Sienna2
        #ee799f Pale Violet Red2
        #ee7ae9 Orchid2
        #ee8262 Salmon2
        #ee82ee Violet
        #ee9572 Light Salmon2
        #ee9a00 Orange2
        #ee9a49 Tan2
        #eea2ad Light Pink2
        #eea9b8 Pink2
        #eead0e Dark Goldenrod2
        #eeaeee Plum2
        #eeb422 Goldenrod2
        #eeb4b4 Rosy Brown2
        #eec591 Burly Wood2
        #eec900 Gold2
        #eecbad Peach Puff2
        #eecfa1 Navajo White2
        #eed2ee Thistle2
        #eed5b7 Bisque2
        #eed5d2 Mistyrose2
        #eed8ae Wheat2
        #eedc82 Light Goldenrod2
        #eedd82 Light Goldenrod
        #eedfcc Antique White2
        #eee0e5 Lavender Blush2
        #eee5de Sea Shell2
        #eee685 Khaki2
        #eee8aa Pale Goldenrod
        #eee8cd Corn Silk2
        #eee9bf Lemon Chiffon2
        #eee9e9 Snow2
        #eeee00 Yellow2
        #eeeed1 Light Yellow2
        #eeeee0 Ivory2
        #f08080 Light Coral
        #f0e68c Khaki
        #f0f0f0 Grey94
        #f0f8ff Alice Blue
        #f0fff0 Honey Dew
        #f0fff0 Honey Dew1
        #f0ffff Azure
        #f0ffff Azure1
        #f2f2f2 Grey95
        #f4a460 Sandy Brown
        #f5deb3 Wheat
        #f5f5dc Beige
        #f5f5f5 Grey96
        #f5f5f5 White Smoke
        #f5fffa Mint Cream
        #f7f7f7 Grey97
        #f8f8ff Ghost White
        #fa8072 Salmon
        #faebd7 Antique White
        #faf0e6 Linen
        #fafad2 Light Goldenrod Yellow
        #fafafa Grey98
        #fcfcfc Grey99
        #fdf5e6 Old Lace
        #ff0000 Red
        #ff0000 Red1
        #ff00ff Magenta
        #ff00ff Magenta1
        #ff1493 Deep Pink
        #ff1493 Deep Pink1
        #ff3030 Firebrick1
        #ff34b3 Maroon1
        #ff3e96 Violet Red1
        #ff4040 Brown1
        #ff4500 Orange Red
        #ff4500 Orange Red1
        #ff6347 Tomato
        #ff6347 Tomato1
        #ff69b4 Hot Pink
        #ff6a6a Indian Red1
        #ff6eb4 Hot Pink1
        #ff7256 Coral1
        #ff7f00 Dark Orange1
        #ff7f24 Chocolate1
        #ff7f50 Coral
        #ff8247 Sienna1
        #ff82ab Pale Violet Red1
        #ff83fa Orchid1
        #ff8c00 Dark Orange
        #ff8c69 Salmon1
        #ffa07a Light Salmon
        #ffa07a Light Salmon1
        #ffa500 Orange
        #ffa500 Orange1
        #ffa54f Tan1
        #ffaeb9 Light Pink1
        #ffb5c5 Pink1
        #ffb6c1 Light Pink
        #ffb90f Dark Goldenrod1
        #ffbbff Plum1
        #ffc0cb Pink
        #ffc125 Golden Rod1
        #ffc1c1 Rosy Brown1
        #ffd39b Burly Wood1
        #ffd700 Gold
        #ffd700 Gold1
        #ffdab9 Peach Puff
        #ffdab9 Peach Puff1
        #ffdead Navajo White
        #ffdead Navajo White1
        #ffe1ff Thistle1
        #ffe4b5 Moccasin
        #ffe4c4 Bisque
        #ffe4c4 Bisque1
        #ffe4e1 Misty Rose
        #ffe4e1 Misty Rose1
        #ffe7ba Wheat1
        #ffebcd Blancheda Almond
        #ffec8b Light Goldenrod1
        #ffefd5 Papaya Whip
        #ffefdb Antique White1
        #fff0f5 Lavender Blush
        #fff0f5 Lavender Blush1
        #fff5ee Sea Shell
        #fff5ee Sea Shell1
        #fff68f Khaki1
        #fff8dc Corn Silk
        #fff8dc Corn Silk1
        #fffacd Lemon Chiffon
        #fffacd Lemon Chiffon1
        #fffaf0 Floral White
        #fffafa Snow
        #fffafa Snow1
        #ffff00 Yellow
        #ffff00 Yellow1
        #ffffe0 Light Yellow
        #ffffe0 Light Yellow1
        #fffff0 Ivory
        #fffff0 Ivory1
        #ffffff Grey100
        #ffffff White

        #000000 SGI:Grey0
        #0a0a0a SGI:Grey4
        #141414 SGI:Grey8
        #1e1e1e SGI:Grey12
        #218868 SGI:indigo2
        #282828 SGI:Grey16
        #282828 SGI:Very Dark Grey
        #333333 SGI:Grey20
        #388e8e SGI:Teal
        #3d3d3d SGI:Grey24
        #474747 SGI:Grey28
        #4b0082 SGI:indigo
        #515151 SGI:Grey32
        #555555 SGI:Dark Grey
        #5b5b5b SGI:Grey36
        #666666 SGI:Grey40
        #707070 SGI:Grey44
        #7171c6 SGI:Slate Blue
        #71c671 SGI:Chartreuse
        #7a7a7a SGI:Grey48
        #7d9ec0 SGI:Light Blue
        #848484 SGI:Grey52
        #848484 SGI:Medium Grey
        #8e388e SGI:Beet
        #8e8e38 SGI:Olive Drab
        #8e8e8e SGI:Grey56
        #999999 SGI:Grey60
        #a3a3a3 SGI:Grey64
        #aaaaaa SGI:Light Grey
        #adadad SGI:Grey68
        #b7b7b7 SGI:Grey72
        #c1c1c1 SGI:Grey76
        #c5c1aa SGI:Bright Grey
        #c67171 SGI:Salmon
        #cccccc SGI:Grey80
        #d6d6d6 SGI:Grey84
        #d6d6d6 SGI:Very Light Grey
        #dc143c SGI:Crimson
        #e0e0e0 SGI:Grey88
        #eaeaea SGI:Grey92
        #f4f4f4 SGI:Grey96
        #ffffff SGI:Grey100
    --
}

1;

__END__

=head1 NAME

Colour::Name - Return RGB values given colour names.

=head1 SYNOPSIS

  use Colour::Name;

  printf "The rgb value for %s is %s" => 'tomato', rgb 'tomato', $RGB_HEX;

=head1 DESCRIPTION

This module exports one subroutine C<< rgb >>, which takes an colour
name, and an optional style parameter as arguments. It returns the
RGB (I<< red >>, I<< green >>, I<< blue >>) values for that colour.

The colour names (and their RGB values) come from the F<< rgb.txt >>
file from the old I<< X11 >> distribution. We've also added some
values from I<< SGI >>, mostly shades of gray.

Colour names are case insensitive, and any non ASCII letter or digit
is ignored. That is, C<< yellow >>, C<< YelLow >>, and C<< y.E__llo!w? >>
are all considered identical.

The following styles can be used (they're all exported when using
C<< Colour::Name >>):

=over 2

=item C<< $RGB_HEX >>

Returns a seven character string, starting with a C<< # >>, followed by
six hex digits, encoding the RGB value as a hex value. This is the 
default if no style parameter is given.

  rgb (Maroon => $RGB_HEX);          # Returns '#ff34b3'

=item C<< $RGB_HEX_TRIPLET >>

Returns a list (in list context) or an arrayref (in scalar context)
with three elements; each element is a two character hex string with
the red, green, and blue values.

  rgb (Gold   => $RGB_HEX_TRIPLET);  # Returns ["ff", "d7", "00"]

=item C<< $RGB_TRIPLET >>

Returns a list (in list context) or an arrayref (in scalar context)
with three elements; each element is an integer of the
the red, green, and blue values.

  rgb (Tan    => $RGB_TRIPLET);      # Returns [210, 180, 140]

=item C<< $RGB_RGB >>

Returns a string in the form of C<< rgb(RRR,GGG,BBB) >>, suitable
to be used in I<< CSS >>, I<< SVG >>, etc. The values inside the
string are in decimal.

  rgb (Purple => $RGB_RGB);          # Returns 'rgb(155,48,255)'

=back

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 MOTIVATION

I just wanted a simple module mapping names to RGB values, and
nothing else. There are quite a bunch of modules on CPAN to handle
RGB values, and while a few could be used to map colours to RGB
values, it wasn't clear which colours. It was simpler to write a
module than to figure it out.

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
