package novella;

import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

class MainScene
{
    public static function create (ctx :NovellaCtx) :Entity
    {
        var scene = new Entity();

        var background = new Entity()
            .add(new FillSprite(0x202020, System.stage.width, System.stage.height));
        scene.addChild(background);

        background.addChild(new Entity().add(new TextSprite(ctx.georgia32, "Click to begin")));

        background.get(Sprite).pointerDown.connect(function (_) {
            System.root.get(Director).unwindToScene(StoryScene.create(ctx));
        });

        return scene;
    }
}
