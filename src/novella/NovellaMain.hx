package novella;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

class NovellaMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        System.root.add(new Director());

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
        var ctx = new NovellaCtx(pack);
        var mainScene = MainScene.create(ctx);

        System.root.get(Director).unwindToScene(mainScene);
    }
}
