|森|鈴木|佐々木|勅使河原|
|:--:|:--:|:--:|:--:|
|![森](https://raw.githubusercontent.com/wiki/rockbone/inkan_generator/img/sample/mori.png)|![鈴木](https://raw.githubusercontent.com/wiki/rockbone/inkan_generator/img/sample/suzuki.png)|![佐々木](https://raw.githubusercontent.com/wiki/rockbone/inkan_generator/img/sample/sasaki.png)|![勅使河原](https://raw.githubusercontent.com/wiki/rockbone/inkan_generator/img/sample/teshigawara.png)|

# NAME

inkan_generator.pl - 印鑑生成ツール【inkan(seal) generator】

# USAGE

inkan_generator TEXT

    TEXT            the text for inkan. allow 1~4 characters.

    --size   [s]    image square size. allow 64~512. [DEFAULT=100]
                    e.g.)   --size=128 (128x128)

    --type   [t]    image type. allow <jpeg|png|gif|pdf> [DEFAULT=png]
                    e.g.)   --type=pdf

    --font   [f]    font family or font file path. [DEFAULT Mincho]
                    available font list ... fc-list, convert -list font
                    e.g.    --font="/System/Library/Fonts/ヒラギノ明朝 ProN W6.ttc"

    --output [o]    output file name. [DEFAULT=-] *STDOUT
                       auto detect image type from output file name if no image type was given.
                       e.g.    --output=inkan.png

# DEPENDENCIES

[ImageMagick®](https://www.imagemagick.org)

# LICENSE

Copyright (C) Tooru Tsurukawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Tooru Tsurukawa <rockbone.g at gmail.com>
