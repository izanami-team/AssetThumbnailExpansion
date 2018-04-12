package AssetThumbnailExpansion::Asset;

use strict;
use warnings;
@AssetThumbnailExpansion::Asset::ISA = qw( MT::Asset );

sub thumbnail_url {
    my $class = shift;
    my ( $asset, %param ) = @_;

    require File::Basename;
    if ( my ( $thumbnail_file, $w, $h ) = _thumbnail_file($asset, %param) ) {
        return $asset->stock_icon_url(%param) if !defined $thumbnail_file;
        my $file            = File::Basename::basename($thumbnail_file);
        my $asset_file_path = $asset->column('file_path');
        my $site_url;
        my $blog = $asset->blog;
        if ( !$blog ) {
            $site_url
                = $param{Pseudo} ? '%s' : MT->instance->support_directory_url;
        }
        elsif ( $asset_file_path =~ m/^%a/ ) {
            $site_url = $param{Pseudo} ? '%a' : $blog->archive_url;
        }
        else {
            $site_url = $param{Pseudo} ? '%r' : $blog->site_url;
        }

        if ( $file && $site_url ) {
            require MT::Util;
            my $path = $param{Path};
            if ( !defined $path ) {
                $path = MT::Util::caturl( MT->config('AssetCacheDir'),
                    unpack( 'A4A2', $asset->created_on ) );
            }
            else {
                require File::Spec;
                my @path = File::Spec->splitdir($path);
                $path = '';
                for my $p (@path) {
                    $path = MT::Util::caturl( $path, $p );
                }
            }
            $file = MT::Util::encode_url($file);
            $site_url = MT::Util::caturl( $site_url, $path, $file );
            $site_url .= '?ts=' . $asset->modified_on if $param{Ts};
            return ( $site_url, $w, $h );
        }
    }

    # Use a stock icon
    return $asset->stock_icon_url(%param);
}

sub _thumbnail_file {
    my  ( $asset, %param ) = @_;
    my $fmgr;
    my $blog = $param{Blog} || $asset->blog;

    require MT::FileMgr;
    $fmgr ||= $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
    return undef unless $fmgr;

    my $file_path = $asset->file_path;
    return undef unless $fmgr->file_size($file_path);

    require MT::Util;
    my $asset_cache_path = $asset->_make_cache_path( $param{Path} );
    my ( $i_h, $i_w ) = ( $asset->image_height, $asset->image_width );
    return undef unless $i_h && $i_w;

    # find the longest dimension of the image:
    my $n_h = $param{Height} > $i_h ? $i_h : $param{Height};
    my $n_w = $param{Width}  > $i_w ? $i_w : $param{Width};

    my $file = $asset->thumbnail_filename(%param) or return;
    my $thumbnail = File::Spec->catfile( $asset_cache_path, $file );

    # thumbnail file exists and is dated on or later than source image
    if ($fmgr->exists($thumbnail)
        && ( $fmgr->file_mod_time($thumbnail)
            >= $fmgr->file_mod_time($file_path) )
        )
    {
        return ( $thumbnail, $n_w, $n_h );
    }

    # stale or non-existent thumbnail. let's create one!
    return undef unless $fmgr->can_write($asset_cache_path);

    my $data;
    # create a thumbnail for this file
    require MT::Image;
    require AssetThumbnailExpansion::Image;
    my $img = new MT::Image( Filename => $file_path )
        or return $asset->error( AssetThumbnailExpansion::Image->errstr );
    # Really make the image square, so our scale calculation works out.
    ($data) = AssetThumbnailExpansion::Image::make_rectangle( $img,  (width => $n_w, height => $n_h) )
        or return $asset->error(
        MT->translate( "Error cropping image: [_1]", $img->errstr ) );

    if ( my $type = $param{Type} ) { 
        ($data) = $img->convert( Type => $type )
            or return $asset->error(
            MT->translate( "Error converting image: [_1]", $img->errstr )
            );  
    }

    $fmgr->put_data( $data, $thumbnail, 'upload' )
        or return $asset->error(
        MT->translate( "Error creating thumbnail file: [_1]", $fmgr->errstr )
        );

    # Remove metadata from thumbnail file.
    require MT::Image;
    MT::Image->remove_metadata($thumbnail)
        or return $asset->error( AssetThumbnailExpansion::Image->errstr );

    return ( $thumbnail, $n_w, $n_h );
}

1;
