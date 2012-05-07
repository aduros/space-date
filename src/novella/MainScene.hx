package novella;

import flambe.animation.Easing;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;

class MainScene
{
    public static function create (ctx :NovellaCtx) :Entity
    {
        var scene = new Entity();

        var background = new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("title.jpg")));
        scene.addChild(background);

        var planet = new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("planet.png")).centerAnchor())
            .add(new PlanetMotion());
        planet.get(PlanetMotion).onUpdate(5000); // Start a few seconds in
        scene.addChild(planet);

        var logo = new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("logo.png"))
                .centerAnchor().setXY(NovellaConsts.WIDTH/2, 150));
        var sprite = logo.get(Sprite);
        sprite.scaleX.animate(0, 1, 0.8, Easing.backOut);
        sprite.scaleY.animate(0, 1, 0.8, Easing.backOut);
        scene.addChild(logo);

        var unlockedEndings = Math.min(ctx.endings.length, 4);
        scene.addChild(new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("endings" + unlockedEndings + ".png"))
                .setXY(23, 434)));

        var startButton = new Entity()
            .add(new ImageSprite(ctx.pack.loadTexture("start.png"))
                .setXY(209, 286));
        startButton.get(Sprite).pointerDown.connect(function (_) {
            ctx.unwindToScene(StoryScene.create(ctx));
        });
        scene.addChild(startButton);

        return scene;
    }
}

private class PlanetMotion extends flambe.Component
{
    public function new ()
    {
        _elapsed = 0;
    }

    override public function onUpdate (dt :Int)
    {
        _elapsed += dt;

        var speed = 0.0001;
        var sprite = owner.get(Sprite);
        sprite.x._ = NovellaConsts.WIDTH/2 + 200*Math.sin(1.5*speed*_elapsed);
        sprite.y._ = 250 + 100*Math.sin(speed*_elapsed);
        sprite.scaleX._ = sprite.scaleY._ = 1 + 0.2*Math.sin(speed*_elapsed);
    }

    private var _elapsed :Int;
}
