package novella;

import flambe.Entity;

class StoryScene
{
    public static function create (ctx :NovellaCtx) :Entity
    {
        var scene = new Entity();

        var reader = new StoryReader(ctx, Story.intro);
        scene.addChild(new Entity().add(reader));

        return scene;
    }
}
