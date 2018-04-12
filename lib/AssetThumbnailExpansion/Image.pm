package AssetThumbnailExpansion::Image;

use strict;
use warnings;

sub inscribe_rectangle {
    my ( $image, %params ) = @_;
    my ( $w, $h ) = @params{qw( Width Height )};

    my ( $x, $y );

    $x = int( ( $image->{width}  - $w ) / 2 );
    $y = int( ( $image->{height} - $h ) / 2 );

    if ($image->{width} < $w) {
    	$x = 0;
    	$w = $image->{width};
    }
    if ($image->{height} < $h) {
    	$y = 0;
    	$h = $image->{height};
    }

    return ( Width => $w, Height => $h,  X => $x, Y => $y );
}

sub make_rectangle {
    my ( $image, %params ) = @_;
    my ( $width, $height ) = @params{qw( width height )};
    my %rectangle = inscribe_rectangle($image, ( Width  => $width, Height => $height ) );
    $image->crop_rectangle(%rectangle);
}

1;
