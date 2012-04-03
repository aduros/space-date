package novella;

import flambe.asset.AssetPack;
import flambe.display.Font;

class NovellaCtx
{
    public var pack (default, null) :AssetPack;

    public var georgia24 (default, null) :Font;
    public var georgia32 (default, null) :Font;

    public function new (pack :AssetPack)
    {
        this.pack = pack;
        georgia24 = new Font(pack, "georgia24");
        georgia32 = new Font(pack, "georgia32");
    }
}
