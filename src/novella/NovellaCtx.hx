package novella;

import haxe.Json;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

using Lambda;

private typedef NovellaConfig = {
    endings :Array<Int>,
}

class NovellaCtx
{
    public var pack (default, setPack) :AssetPack;

    public var fontFixed (default, null) :Font;
    public var fontMangal (default, null) :Font;

    public var endings (default, null) :Array<Int>;

    public function new (viewport :Entity)
    {
        if (!viewport.has(Director)) {
            viewport.add(new Director());
        }
        _viewport = viewport;

        endings = [];
        try {
            var config :NovellaConfig = Json.parse(System.storage.get("config"));
            endings = config.endings;
        } catch (_ :Dynamic) {
            // Swallow errors from corrupted save data
        }
    }

    public function unlockEnding (ending :Int)
    {
        if (!endings.has(ending)) {
            endings.push(ending);
            saveConfig();
        }
    }

    public function unwindToScene (scene :Entity)
    {
        _viewport.get(Director).unwindToScene(scene);
    }

    private function saveConfig ()
    {
        var config :NovellaConfig = {
            endings: endings,
        };
        System.storage.set("config", Json.stringify(config));
    }

    private function setPack (pack :AssetPack) :AssetPack
    {
        this.pack = pack;
        fontFixed = new Font(pack, "fonts/fixedsys");
        fontMangal = new Font(pack, "fonts/mangal");
        return pack;
    }

    private var _viewport :Entity;
}
