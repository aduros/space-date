//
// Space Date - A short visual novel
// https://github.com/aduros/space-date/blob/master/LICENSE.txt

package novella;

import flambe.Entity;

class StoryScene
{
    public static function create (ctx :NovellaContext) :Entity
    {
        var scene = new Entity();

        var reader = new StoryReader(ctx, Story.begin);
        scene.addChild(new Entity().add(reader));

        return scene;
    }
}
