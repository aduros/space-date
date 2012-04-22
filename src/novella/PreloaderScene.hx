package novella;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

class PreloaderScene
{
    public static function create () :Entity
    {
        var scene = new Entity();

        var background = new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height));
        scene.addChild(background);

        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);

        var progressWidth = 500;
        var progressBar = new Entity()
            .add(new FillSprite(0x000000, progressWidth, 20)
                .centerAnchor()
                .setXY(System.stage.width/2, System.stage.height/2));
        scene.addChild(progressBar);

        var barFill = new Entity().add(new FillSprite(0xffffff, 0, 20));
        loader.progressChanged.connect(function () {
            var ratio = loader.progress/loader.total;
            barFill.get(FillSprite).width._ = ratio*progressWidth;
        });
        progressBar.addChild(barFill);

        // Track the download time and if any errors happened during loading
        var startTime = Date.now().getTime();
        loader.get(function (_) {
            var loadTime = Std.int(Date.now().getTime() - startTime);
            trace("Loaded in " + loadTime + "ms");
            Metrics.trackEvent("Preloader", "Finished", loadTime);
        });
        loader.error.connect(function (message :String) {
            Metrics.trackError("Preloader", message);
        });

        return scene;
    }

    private static function onSuccess (pack :AssetPack)
    {
        var ctx = new NovellaCtx(pack);
        var mainScene = MainScene.create(ctx);

        System.root.get(Director).unwindToScene(mainScene);
    }
}
