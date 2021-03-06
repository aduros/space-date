//
// Space Date - A short visual novel
// https://github.com/aduros/space-date/blob/master/LICENSE.txt

package novella;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.scene.Director;
import flambe.scene.Transition;

using Lambda;

private typedef NovellaCookie = {
    endings :Array<Int>,
}

class NovellaContext
{
    public var pack (default, set) :AssetPack;

    public var fontFixed (default, null) :Font;
    public var fontMangal (default, null) :Font;

    public var endings (default, null) :Array<Int>;

    public function new (viewport :Entity)
    {
        if (!viewport.has(Director)) {
            viewport.add(new Director().setSize(NovellaConsts.WIDTH, NovellaConsts.HEIGHT));
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

    public function unwindToScene (scene :Entity, ?trans :Transition)
    {
        _viewport.get(Director).unwindToScene(scene, trans);
    }

    private function saveConfig ()
    {
        var cookie :NovellaCookie = {
            endings: endings,
        };
        System.storage.set("novella", cookie);
    }

    private function set_pack (pack :AssetPack) :AssetPack
    {
        this.pack = pack;
        fontFixed = new Font(pack, "fonts/fixedsys");
        fontMangal = new Font(pack, "fonts/mangal");
        return pack;
    }

    private var _viewport :Entity;
}
