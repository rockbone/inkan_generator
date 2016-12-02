#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
no warnings qw(utf8);
use Encode;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my ($help, $size, $type, $font, $output);
GetOptions(
    "help|h"        => \$help,
    "size|s=s"      => \$size,
    "type|t=s"      => \$type,
    "font|f=s"      => \$font,
    "output|o=s"    => \$output,
);

usage() if $help;

my $text = decode(utf8 => $ARGV[0]||"");
my @char = split//, $text;

if (!$type && defined $output){
    ($type) = $output =~ /\.(jpe?g|png|gif|pdf)$/i;
}

# Default
defined $size or $size = 100;
defined $type or $type = "png";
defined $font or $font = "Mincho";
defined $output or $output = "-";

$type = lc($type);
$font = decode(utf8 => $font) if !utf8::is_utf8($font);

usage("Invalid size range '$size'") if $size =~ /[^0-9]/ || $size < 64 || 512 < $size;
usage("Invalid image type '$type'") if $type !~ /^(?:jpe?g|png|gif|pdf)$/;
usage("No text entry") if !@char;
usage("Input text length is too long '$text'") if @char > 4;

my %PROP = (
    1 => [0.48, [[0,0]]],
    2 => [0.40, [[0,-0.2],[0,0.2]]],
    3 => [0.30, [[0,-0.27],[0,0],[0,0.27]]],
    4 => [0.24, [[0,-0.34],[0,-0.112],[0,0.112],[0,0.34]]],
);

my $prop = $PROP{scalar @char};
$prop->[0] *= $size;
for my $pos (@{$prop->[1]}){
    $_ *= $size for @$pos;
}

my $radius = $size/2;
my $stroke_width = $size < 128 ? 1 : $size < 256 ? 2 : 3;

my $cmd = qq{convert -size ${size}x${size} xc:transparent -font "$font" -draw "stroke #c70f11 fill transparent stroke-width $stroke_width circle $radius,$radius,$radius,2"};

for (my $i=0; $i<@char; $i++){
    $cmd .= sprintf q{ -draw "font-size %s font-weight bold gravity center fill #c70f11 text %s '%s'"}, $prop->[0], join(",", @{$prop->[1][$i]}), $char[$i];
}

$cmd .= " $type:-";

if ($ENV{DEBUG}){
    warn <<EOM;
---------------------------------------
TEXT:     $text
SIZE:     $size
TYPE:     $type
FONT:     $font
FONTSIZE: $prop->[0]
CMD:      $cmd
---------------------------------------
EOM
}

open my $pipe, "$cmd|"
    or die $!;

my $output_handle;
if ($output eq '-'){
    $output_handle = \*STDOUT;
}
else {
    open $output_handle, ">", $output
        or die "Cannot open output file '$output': $!\n";
}

while (<$pipe>){
    print {$output_handle} $_;
}

close $pipe;

exit();

sub usage {
    for my $msg (@_){
        warn "*** $msg\n";
    }
    die <<USAGE;
---------- INKAN Generator ----------
Usage:
$0 TEXT

    TEXT            the text for inkan. allow 1~4 characters.

    --size      [s] image square size. allow 64~512. [DEFAULT=100]
                    e.g.)   --size=128 (128x128)

    --type      [t] image type. allow <jpeg|png|gif|pdf> [DEFAULT=png]
                    e.g.)   --type=pdf

    --font      [f] font family or font file path. [DEFAULT Mincho]A
                    available font list ... fc-list, convert -list font
                    e.g.    --font="/System/Library/Fonts/ヒラギノ明朝 ProN W6.ttc"

    --output    [o] output file name. [DEFAULT=-] *STDOUT
                    auto detect image type from output file name if no image type was given.
                    e.g.    --output=inkan.png

USAGE
}
