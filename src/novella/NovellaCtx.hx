package novella;

import haxe.Json;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.System;

using Lambda;

private typedef NovellaConfig = {
    endings :Array<Int>,
}

class NovellaCtx
{
    public var pack (default, null) :AssetPack;

    public var georgia24 (default, null) :Font;
    public var georgia32 (default, null) :Font;

    public var endings (default, null) :Array<Int>;

    public function new (pack :AssetPack)
    {
        this.pack = pack;
        georgia24 = new Font(pack, "georgia24");
        georgia32 = new Font(pack, "georgia32");

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

    private function saveConfig ()
    {
        var config :NovellaConfig = {
            endings: endings,
        };
        System.storage.set("config", Json.stringify(config));
    }
}
