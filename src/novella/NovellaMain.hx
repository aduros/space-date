package novella;

import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;

class NovellaMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Track some important info on Google Analytics
        Metrics.setCustomVar(1, "Version", "1.0");
        System.uncaughtError.connect(function (message) {
            Metrics.trackEvent("Uncaught", message);
        });

        System.stage.lockOrientation(Landscape);

        var viewport = new Entity().add(new Sprite());
        System.root.addChild(viewport);

        var ctx = new NovellaCtx(viewport);
        ctx.unwindToScene(PreloaderScene.create(ctx));

        var borderN = new FillSprite(0x000000, 0, 0);
        var borderE = new FillSprite(0x000000, 0, 0);
        var borderS = new FillSprite(0x000000, 0, 0);
        var borderW = new FillSprite(0x000000, 0, 0);
        var layoutBorders = function () {
            var w = System.stage.width;
            var h = System.stage.height;
            if ((w != NovellaConsts.WIDTH || h != NovellaConsts.HEIGHT) && borderN.owner == null) {
                System.root.addChild(new Entity().add(borderN));
                System.root.addChild(new Entity().add(borderE));
                System.root.addChild(new Entity().add(borderS));
                System.root.addChild(new Entity().add(borderW));
            }

            var scaleX = w / NovellaConsts.WIDTH;
            var scaleY = h / NovellaConsts.HEIGHT;
            var scale = Math.min(scaleX, scaleY);

            var viewportSprite = viewport.get(Sprite);
            viewportSprite.x._ = 0.5*w - 0.5*scale*NovellaConsts.WIDTH;
            viewportSprite.y._ = 0.5*h - 0.5*scale*NovellaConsts.HEIGHT;
            viewportSprite.setScale(scale);

            borderN.setXY(0, 0);
            borderN.width._ = w;
            borderN.height._ = viewportSprite.y._;

            borderE.setXY(w - viewportSprite.x._, viewportSprite.y._);
            borderE.width._ = viewportSprite.x._;
            borderE.height._ = h - 2*viewportSprite.y._;

            borderS.setXY(0, h - viewportSprite.y._);
            borderS.width._ = w;
            borderS.height._ = viewportSprite.y._;

            borderW.setXY(0, viewportSprite.y._);
            borderW.width._ = viewportSprite.x._;
            borderW.height._ = h - 2*viewportSprite.y._;
        };
        System.stage.resize.connect(layoutBorders);
        layoutBorders();
    }
}
