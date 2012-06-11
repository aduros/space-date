package novella;

import flambe.animation.Easing;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.scene.Director;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.sound.Playback;
import flambe.sound.Sound;
import flambe.System;

import novella.Screen;
import novella.Transition;

class StoryReader extends Component
{
    public function new (ctx :NovellaContext, story :Screen)
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

        _disposer.add(_overlayLayer = new Entity());
        owner.addChild(_overlayLayer);

        _aggregator = new Screen();

        _ignoreEventId = -1;
        _disposer.connect1(System.pointer.down, function (event) {
            if (event.id == _ignoreEventId) {
                return;
            }
            _ignoreEventId = -1;

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
        // Merge some of this screen's attributes into the aggregator
        if (screen.backdrop != null) {
            _aggregator.backdrop = screen.backdrop;
        }
        if (screen.actor != null) {
            _aggregator.actor = screen.actor;
        }

        _aggregator.mode = screen.mode;
        _cursor = screen;

        if (screen.transitionType == null) {
            showAggregatedScreen();

        } else switch (screen.transitionType) {
        case Fade(color):
            var overlay = new Entity()
                .add(new FillSprite(color, NovellaConsts.WIDTH, NovellaConsts.HEIGHT))
                .add(new Script());
            var sprite = overlay.get(Sprite);
            sprite.alpha._ = 0;
            overlay.get(Script).run(new Sequence([
                new AnimateTo(sprite.alpha, 1, 0.5, Easing.linear),
                new CallFunction(showAggregatedScreen),
                new AnimateTo(sprite.alpha, 0, 0.5, Easing.linear),
                new CallFunction(overlay.dispose),
            ]));
            _overlayLayer.addChild(overlay);
        }
    }

    public function showAggregatedScreen ()
    {
        _modeLayer.disposeChildren();

        _backdropEntity.add(createBackdrop(_aggregator.backdrop));

        var sprite = createActor(_aggregator.actor);
        sprite.setXY(50, NovellaConsts.HEIGHT - sprite.getNaturalHeight());
        _actorEntity.add(sprite);

        if (_aggregator.music != null) {
            if (_music != null) {
                _disposer.remove(_music);
                _music.dispose();
            }

            // Play the new music, adding it to the _disposer so it will automatically stop when this
            // entity is disposed
            var sound = createMusic(_aggregator.music);
            if (sound != null) {
                _music = sound.loop();
                _disposer.add(_music);
            }
        }

        switch (_aggregator.mode) {
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
                seq.push(new TypeAction(line, 15/1000, label));
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
                    _ignoreEventId = event.id; // Flag that this event shouldn't be handled above
                });
                box.addChild(background);

                var label = new TextSprite(_ctx.fontMangal, option.text);
                label.setXY(width/2 - label.getNaturalWidth()/2,
                    height/2 - label.getNaturalHeight()/2);
                box.addChild(new Entity().add(label));

                _modeLayer.addChild(box);
            }

        case Ending(ending, text):
            Metrics.trackEvent("Gameplay", "Ending", "#" + ending);
            _ctx.unlockEnding(ending);

            var count = _ctx.endings.length;
            var showEpilogue = (count >= 4);
            var extraText = showEpilogue ? "You have unlocked all 4 endings!" :
                "You have unlocked " + count + " out of 4 endings. Find them all for a bonus epilogue!";
            var screen = new Screen()
                .transition(Fade(0x000000)).at(TheEnd)
                .with(Nobody).saying(text + ". " + extraText);
            if (showEpilogue) {
                screen.nextScreen = Story.epilogue.rewind();
            }
            show(screen);
            return;
        }
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
                MarkCasual, MarkCasualHappy, MarkCasualBashful: "Mark";
            case Nobody: "";
            case Sarah, SarahHappy, SarahBashful, SarahSad, SarahAngry,
                SarahCasual, SarahCasualHappy, SarahCasualBashful, SarahCasualSad,
                SarahCasualAngry: "Sarah";
        }
    }

    private var _ctx :NovellaContext;
    private var _disposer :Disposer;
    private var _ignoreEventId :Int;

    private var _cursor :Screen;
    private var _aggregator :Screen;

    private var _music :Playback;

    private var _actorEntity :Entity;
    private var _backdropEntity :Entity;

    private var _modeLayer :Entity;
    private var _overlayLayer :Entity;
}
