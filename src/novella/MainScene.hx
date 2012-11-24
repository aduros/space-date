//
// Space Date - A short visual novel
// https://github.com/aduros/space-date/blob/master/LICENSE.txt

package novella;

import flambe.animation.Ease;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.scene.SlideTransition;
import flambe.Entity;
import flambe.System;

class MainScene
{
    public static function create (ctx :NovellaContext) :Entity
    {
        var scene = new Entity();

        var background = new Entity()
            .add(new ImageSprite(ctx.pack.getTexture("title")));
        scene.addChild(background);

        var planet = new Entity()
            .add(new ImageSprite(ctx.pack.getTexture("planet")).centerAnchor())
            .add(new PlanetMotion());
        planet.get(PlanetMotion).onUpdate(5000); // Start a few seconds in
        scene.addChild(planet);

        var logo = new Entity()
            .add(new ImageSprite(ctx.pack.getTexture("logo"))
                .centerAnchor().setXY(NovellaConsts.WIDTH/2, 150));
        var sprite = logo.get(Sprite);
        sprite.scaleX.animate(0, 1, 0.8, Ease.backOut);
        sprite.scaleY.animate(0, 1, 0.8, Ease.backOut);
        scene.addChild(logo);

        var unlockedEndings = Math.min(ctx.endings.length, 4);
        scene.addChild(new Entity()
            .add(new ImageSprite(ctx.pack.getTexture("endings" + unlockedEndings))
                .setXY(23, 434)));

        var startButton = new Entity()
            .add(new ImageSprite(ctx.pack.getTexture("start"))
                .setXY(209, 286));
        startButton.get(Sprite).pointerDown.connect(function (_) {
            Metrics.trackEvent("Gameplay", "Start");
            ctx.unwindToScene(StoryScene.create(ctx), new SlideTransition(0.5).left());
        });
        scene.addChild(startButton);

        var gamesButton = new Entity()
            .add(new ImageSprite(ctx.pack.getTexture("games"))
                .setXY(243, 380));
        gamesButton.get(Sprite).pointerDown.connect(function (_) {
            Metrics.trackEvent("Gameplay", "More Games");
            System.callNative("moreGames");
        });
        scene.addChild(gamesButton);

        return scene;
    }
}

private class PlanetMotion extends flambe.Component
{
    public function new ()
    {
        _elapsed = 0;
    }

    override public function onUpdate (dt :Float)
    {
        _elapsed += dt;

        var speed = 0.1;
        var sprite = owner.get(Sprite);
        sprite.x._ = NovellaConsts.WIDTH/2 + 200*Math.sin(1.5*speed*_elapsed);
        sprite.y._ = 250 + 100*Math.sin(speed*_elapsed);
        sprite.scaleX._ = sprite.scaleY._ = 1 + 0.2*Math.sin(speed*_elapsed);
    }

    private var _elapsed :Float;
}
