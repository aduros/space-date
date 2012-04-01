package novella;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;

class NovellaMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        var background = new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height));
        System.root.addChild(background);

        var begin = Story.begin;
    }
}
