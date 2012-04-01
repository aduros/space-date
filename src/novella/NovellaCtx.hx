package novella;

import flambe.asset.AssetPack;
import flambe.display.Font;

class NovellaCtx
{
    public var pack (default, null) :AssetPack;

    public var mainFont (default, null) :Font;

    public function new (pack :AssetPack)
    {
        this.pack = pack;
        mainFont = new Font(pack, "myfont");
    }
}
