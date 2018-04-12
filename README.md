# AssetThumbnailRectangleLink
「MTAssetThumbnailLink」を拡張したサムネイル画像出力タグです。  
"rectangle"モディフィアを指定することで、width, height両方をサイズ指定してサムネイル画像を作成することが出来ます。  
なお、"rectangle"モディフィアを指定しない場合の挙動は、「MTAssetThumbnailLink」と同様です。

## 使い方
    <mt:If tag="AssetCount">
        <mt:Assets type="image" lastn="10">
            <mt:AssetsHeader>
    <div class="widget-recent-assets widget">
        <h3 class="widget-header">アイテム</h3>
        <div class="widget-content">
            <ul>
            </mt:AssetsHeader>
            <li class="item"><a class="asset-image" href="<$mt:AssetURL$>"><$mt:MTAssetThumbnailExpansionLink height="100" width="300" rectangle="1" $></a></li>
            <mt:AssetsFooter>
            </ul>
        </div>
    </div>
            </mt:AssetsFooter>
        </mt:Assets>
    </mt:If>

## モディファイア
> rectangle="1"

rectangle="1"を指定すると、指定したwidth, heightでトリミング（中央寄せ）されたサムネイルが作成されます。  
本モディフィアを指定した場合、width, heightはいずれも必須です。  
> width="value_foo"

画像のサムネイルの幅を指定値 (px) でトリミング（中央寄せ）します。元画像のサイズより大きな値を指定した場合は、元画像サイズの値となります。
> height="value_foo"

画像のサムネイルの高さを指定値 (px) でトリミング（中央寄せ）します。元画像のサイズより大きな値を指定した場合は、元画像サイズの値となります。

"rectangle"モディフィアを指定しない場合に利用可能なモディフィアについては、「MTAssetThumbnailLink（https://www.movabletype.jp/documentation/appendices/tags/assetthumbnaillink.html）」を参照してください。

---

# AssetThumbnailRectangleUrl
「MTAssetThumbnailUrl」を拡張したサムネイル画像URL出力タグです。  
"rectangle"モディフィアを指定することで、width, height両方をサイズ指定してサムネイル画像を作成することが出来ます。  
なお、"rectangle"モディフィアを指定しない場合の挙動は、「MTAssetThumbnailLink」と同様です。

## 使い方
    <mt:If tag="AssetCount">
        <mt:Assets type="image" lastn="10">
            <mt:AssetsHeader>
    <div class="widget-recent-assets widget">
        <h3 class="widget-header">アイテム</h3>
        <div class="widget-content">
            <ul>
            </mt:AssetsHeader>
            <li class="item"><a class="asset-image" href="<$mt:AssetURL$>"><$mt:MTAssetThumbnailExpansionUrl height="100" width="300" rectangle="1" $></a></li>
            <mt:AssetsFooter>
            </ul>
        </div>
    </div>
            </mt:AssetsFooter>
        </mt:Assets>
    </mt:If>

## モディファイア
> rectangle="1"

rectangle="1"を指定すると、指定したwidth, heightでトリミング（中央寄せ）されたサムネイルが作成されます。  
本モディフィアを指定した場合、width, heightはいずれも必須です。  
> width="value_foo"

画像のサムネイルの幅を指定値 (px) でトリミング（中央寄せ）します。元画像のサイズより大きな値を指定した場合は、元画像サイズの値となります。
> height="value_foo"

画像のサムネイルの高さを指定値 (px) でトリミング（中央寄せ）します。元画像のサイズより大きな値を指定した場合は、元画像サイズの値となります。

"rectangle"モディフィアを指定しない場合に利用可能なモディフィアについては、「MTAssetThumbnailUrl（https://www.movabletype.jp/documentation/appendices/tags/assetthumbnailurl.html）」を参照してください。
