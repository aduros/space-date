package novella;

import flambe.scene.Director;
import flambe.System;

class NovellaMain
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        System.root.add(new Director());
        System.stage.lockOrientation(Landscape);

        var preloader = PreloaderScene.create();
        System.root.get(Director).unwindToScene(preloader);
    }
}
