package novella;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

using Lambda;

private typedef NovellaCookie = {
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

        var cookie :NovellaCookie = System.storage.get("novella");
        if (cookie != null) {
            endings = cookie.endings;
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
        var cookie :NovellaCookie = {
            endings: endings,
        };
        System.storage.set("novella", cookie);
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
