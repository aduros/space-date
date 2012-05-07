package novella;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.scene.Director;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.sound.Playback;
import flambe.sound.Sound;
import flambe.System;

import novella.Screen;

class StoryReader extends Component
{
    public function new (ctx :NovellaCtx, story :Screen)
    {
        _ctx = ctx;
        _cursor = story.rewind();
        _disposer = new Disposer();
    }

    override public function onAdded ()
    {
        _disposer.add(_backdropEntity = new Entity());
        owner.addChild(_backdropEntity);

        _disposer.add(_actorEntity = new Entity());
        owner.addChild(_actorEntity);

        _disposer.add(_modeLayer = new Entity());
        owner.addChild(_modeLayer);

        _aggregator = new Screen();

        _disposer.connect1(System.pointer.down, function (event) {
            if (event == _ignoreEvent) {
                return;
            }
            _ignoreEvent = null;

            switch (_cursor.mode) {
            case Blank, Speech(_):
                if (_cursor.nextScreen != null) {
                    // Advance to the next screen
                    show(_cursor.nextScreen);
                } else {
                    _ctx.unwindToScene(MainScene.create(_ctx));
                }
            default:
                // Do nothing
            }
        });
        show(_cursor);
    }

    override public function onRemoved ()
    {
        // Clean up all the listeners and entities assigned to our disposer
        _disposer.dispose();
    }

    private function show (screen :Screen)
    {
        if (screen.backdrop != null && screen.backdrop != _aggregator.backdrop) {
            _backdropEntity.add(createBackdrop(screen.backdrop));
            _aggregator.backdrop = screen.backdrop;
        }

        if (screen.actor != null && screen.actor != _aggregator.actor) {
            var fadeDuration = 0.2;
            if (screen.actor == Actor.Nobody && _actorEntity.has(Sprite)) {
                // Simply fade out the current actor
                _actorEntity.get(Sprite).alpha.animate(1, 0, fadeDuration);

            } else {
                // Swap in the new actor
                var sprite = createActor(screen.actor);
                sprite.setXY(50, NovellaConsts.HEIGHT - sprite.getNaturalHeight());
                _actorEntity.add(sprite);

                // And fade if there was nobody on screen previously
                if (_aggregator.actor == Actor.Nobody) {
                    sprite.alpha.animate(0, 1, fadeDuration);
                }
            }
            _aggregator.actor = screen.actor;
        }

        if (screen.music != null && screen.music != _aggregator.music) {
            if (_music != null) {
                _disposer.remove(_music);
                _music.dispose();
            }

            // Play the new music, adding it to the _disposer so it will automatically stop when this
            // entity is disposed
            var sound = createMusic(screen.music);
            if (sound != null) {
                _music = sound.loop();
                _disposer.add(_music);
            }
        }

        _modeLayer.disposeChildren();

        switch (screen.mode) {
        case Blank:
            // Nothing

        case Speech(text):
            var box = new Entity()
                .add(new ImageSprite(_ctx.pack.loadTexture("wordbox.png")));
            var sprite = box.get(Sprite);
            sprite.y._ = NovellaConsts.HEIGHT - sprite.getNaturalHeight();
            _modeLayer.addChild(box);

            var name = getActorName(_aggregator.actor);
            box.addChild(new Entity()
                .add(new TextSprite(_ctx.fontFixed, name).setXY(5, -20)));

            var padding = 10;
            var y = 5;
            var width = System.stage.width;
            var lines = _ctx.fontMangal.splitLines(text, NovellaConsts.WIDTH - 2*padding);
            var seq = [];
            for (line in lines) {
                var label = new TextSprite(_ctx.fontMangal);
                label.setXY(padding, y);
                y += label.font.size;
                seq.push(new TypeAction(line, 15, label));
                box.addChild(new Entity().add(label));
            }
            var script = new Script();
            script.run(new Sequence(seq));
            box.add(script);

        case Choice(options):
            var width = NovellaConsts.WIDTH - 40;
            var height = 80;
            var padding = 50;
            var x = 20;
            var y = NovellaConsts.HEIGHT/2 - (options.length*(height+padding) - padding)/2;
            var animFromLeft = true;
            var animDuration = 0.5;

            for (option in options) {
                var box = new Entity()
                    .add(new Sprite());
                var sprite = box.get(Sprite);
                if (animFromLeft) {
                    sprite.x.animate(-width, x, animDuration);
                } else {
                    sprite.x.animate(NovellaConsts.WIDTH, x, animDuration);
                }
                sprite.y._ = y;
                y += height + padding;
                animFromLeft = !animFromLeft;

                var background = new Entity()
                    .add(new FillSprite(0x000000, width, height));
                var sprite = background.get(Sprite);
                sprite.alpha._ = 0.8;
                sprite.pointerDown.connect(function (event) {
                    show(option.branch);
                    _ignoreEvent = event; // Flag that this event shouldn't be handled above
                });
                box.addChild(background);

                var label = new TextSprite(_ctx.fontMangal, option.text);
                label.setXY(width/2 - label.getNaturalWidth()/2,
                    height/2 - label.getNaturalHeight()/2);
                box.addChild(new Entity().add(label));

                _modeLayer.addChild(box);
            }

        case Ending(ending, text):
            _ctx.unlockEnding(ending);
            var count = _ctx.endings.length;
            var extra  = (count < 4) ?
                "You have unlocked " + count + " out of 4 endings. Find them all for a bonus epilogue!" :
                "You have unlocked all 4 endings!";
            show(new Screen().at(TheEnd).with(Nobody).saying(text + ". " + extra));
            return;
        }
        _aggregator.mode = screen.mode;

        _cursor = screen;
    }

    private function createActor (actor :Actor) :Sprite
    {
        switch (actor) {
        case Nobody:
            return new Sprite();
        default:
            var name = Type.enumConstructor(actor);
            return new ImageSprite(_ctx.pack.loadTexture("actors/" + name + ".png"));
        }
    }

    private function createBackdrop (backdrop :Backdrop) :Sprite
    {
        var name = Type.enumConstructor(backdrop);
        return new ImageSprite(_ctx.pack.loadTexture("backdrops/" + name + ".jpg"));
    }

    private function createMusic (music :Music) :Sound
    {
        return null;
        // switch (music) {
        // case Silence:
        //     return null;
        // default:
        //     var name = Type.enumConstructor(music);
        //     return _ctx.pack.loadSound("music/" + name);
        // }
    }

    private function getActorName (actor :Actor) :String
    {
        return switch (actor) {
            case Dan, DanHappy, DanUhh, DanWorried: "Dan";
            case Lori, LoriHappy, LoriPout, LoriWorried: "Lori";
            case Mark, MarkHappy, MarkBashful, MarkMigraine,
                MarkCasual, MarkCasualHappy, MarkCasualBashful, MarkCasualMigraine: "Mark";
            case Nobody: "";
            case Sarah, SarahHappy, SarahBashful, SarahSad, SarahAngry,
                SarahCasual, SarahCasualHappy, SarahCasualBashful, SarahCasualSad,
                SarahCasualAngry: "Sarah";
        }
    }

    private var _ctx :NovellaCtx;
    private var _disposer :Disposer;
    private var _ignoreEvent :PointerEvent;

    private var _cursor :Screen;
    private var _aggregator :Screen;

    private var _music :Playback;

    private var _actorEntity :Entity;
    private var _backdropEntity :Entity;
    private var _modeLayer :Entity;
}
