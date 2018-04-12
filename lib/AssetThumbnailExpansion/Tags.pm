package AssetThumbnailExpansion::Tags;
use strict;
use warnings;
use utf8;

sub _hdlr_asset_thumbnail_expansion_url {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return '' unless $a->has_thumbnail;

    my %arg;
    foreach ( keys %$args ) {
        $arg{$_} = $args->{$_};
    }
    $arg{Width}  = $args->{width}  if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale}  = $args->{scale}  if $args->{scale};
    $arg{Square} = $args->{square} if $args->{square};
    $arg{Rectangle} = $args->{rectangle} if $args->{rectangle};

    foreach my $modifier (qw( Width Height )) {
        return $ctx->error(
            MT->translate( "_ASSET_THUMBNAIL_EXPANSION_MODIFIER_REQUIRE", $modifier ) )
            if ( $arg{Rectangle} and !$arg{$modifier} );

        return $ctx->error(
            MT->translate( "[_1] must be a number.", $modifier ) )
            if ( defined $arg{$modifier} && $arg{$modifier} !~ /^\d+$/ );
    }

    if ( !$arg{Rectangle} and !$args->{force} ) {
        delete $arg{Width}  if $arg{Width} > $a->image_width;
        delete $arg{Height} if $arg{Height} > $a->image_height;
    }

    my ( $url, $w, $h );
    if ($arg{Rectangle}) {
        require AssetThumbnailExpansion::Asset;
        ( $url, $w, $h ) = AssetThumbnailExpansion::Asset->thumbnail_url($a, %arg);
    } else {
        ( $url, $w, $h ) = $a->thumbnail_url(%arg);
    }

    return $url || '';
}

sub _hdlr_asset_thumbnail_expansion_link {
    my ( $ctx, $args ) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    my $class = ref($a);
    return '' unless UNIVERSAL::isa( $a, 'MT::Asset::Image' );

    my %arg;
    $arg{Width}  = $args->{width}  if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale}  = $args->{scale}  if $args->{scale};
    $arg{Square} = $args->{square} if $args->{square};
    $arg{Rectangle} = $args->{rectangle} if $args->{rectangle};

    foreach my $modifier (qw( Width Height )) {
        return $ctx->error(
            MT->translate( "_ASSET_THUMBNAIL_EXPANSION_MODIFIER_REQUIRE", $modifier ) )
            if ( $arg{Rectangle} and !$arg{$modifier} );

        return $ctx->error(
            MT->translate( "[_1] must be a number.", $modifier ) )
            if ( defined $arg{$modifier} && $arg{$modifier} !~ /^\d+$/ );
    }

    if ( !$arg{Rectangle} and !$args->{force} ) {
        delete $arg{Width}  if $arg{Width} > $a->image_width;
        delete $arg{Height} if $arg{Height} > $a->image_height;
    }

    my ( $url, $w, $h );
    if ($arg{Rectangle}) {
        require AssetThumbnailExpansion::Asset;
        ( $url, $w, $h ) = AssetThumbnailExpansion::Asset->thumbnail_url($a, %arg);
    } else {
        ( $url, $w, $h ) = $a->thumbnail_url(%arg);
    }
    my $ret = sprintf qq(<a href="%s"), $a->url;
    if ( $args->{new_window} ) {
        $ret .= qq( target="_blank");
    }
    $ret .= sprintf qq(><img src="%s" width="%d" height="%d" alt="" /></a>),
        $url, $w, $h;
    $ret;
}

1;
