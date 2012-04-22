package novella;

import flambe.scene.Director;
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

        System.root.add(new Director());
        System.stage.lockOrientation(Landscape);

        var preloader = PreloaderScene.create();
        System.root.get(Director).unwindToScene(preloader);
    }
}
