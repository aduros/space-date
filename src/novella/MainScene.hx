package novella;

import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

class MainScene
{
    public static function create (ctx :NovellaCtx) :Entity
    {
        var scene = new Entity();

        var background = new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("title.jpg")));
        scene.addChild(background);

        background.get(Sprite).pointerDown.connect(function (_) {
            System.root.get(Director).unwindToScene(StoryScene.create(ctx));
        });

        var unlockedEndings = Math.min(ctx.endings.length, 4);
        scene.addChild(new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("endings" + unlockedEndings + ".png"))
                .setXY(23, 434)));

        return scene;
    }
}
