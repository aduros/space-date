package novella;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
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
    }

    override public function onAdded ()
    {
        var disposer = owner.get(Disposer);
        if (disposer == null) {
            disposer = new Disposer();
            owner.add(disposer);
        }

        disposer.add(_backdropEntity = new Entity());
        owner.addChild(_backdropEntity);

        disposer.add(_actorEntity = new Entity());
        owner.addChild(_actorEntity);

        disposer.add(_modeLayer = new Entity());
        owner.addChild(_modeLayer);

        _aggregator = new Screen();

        disposer.connect1(System.pointer.down, function (_) {
            switch (_aggregator.mode) {
            case Blank, Speech(_):
                if (_cursor.nextScreen != null) {
                    show(_cursor.nextScreen);
                } else {
                    trace("GAME OVER!");
                }
            default:
                // Do nothing
            }
        });
        show(_cursor);
    }

    private function show (screen :Screen)
    {
        if (screen.backdrop != null && screen.backdrop != _aggregator.backdrop) {
            _backdropEntity.add(createBackdrop(screen.backdrop));
            _aggregator.backdrop = screen.backdrop;
        }

        if (screen.actor != null && screen.actor != _aggregator.actor) {
            var sprite = createActor(screen.actor);
            sprite.setXY(50, System.stage.height - sprite.getNaturalHeight());
            _actorEntity.add(sprite);
            _aggregator.actor = screen.actor;
        }

        if (screen.music != null && screen.music != _aggregator.music) {
            if (_music != null) {
                _music.dispose();
            }
            var sound = createMusic(screen.music);
            if (sound != null) {
                _music = sound.loop();
            }
        }

        _modeLayer.disposeChildren();

        switch (screen.mode) {
        case Blank:
            // Nothing

        case Speech(text):
            var box = new Entity()
                .add(new FillSprite(0x000000, System.stage.width, 100));
            var sprite = box.get(Sprite);
            sprite.y._ = System.stage.height - sprite.getNaturalHeight();
            sprite.alpha._ = 0.8;
            _modeLayer.addChild(box);

            var name = getActorName(_aggregator.actor);
            box.addChild(new Entity()
                .add(new TextSprite(_ctx.georgia24, name).setXY(5, -20)));

            var y = 0;
            var width = System.stage.width;
            var lines = _ctx.georgia32.splitLines(text, System.stage.width);
            var seq = [];
            for (line in lines) {
                var label = new TextSprite(_ctx.georgia32);
                label.y._ = y;
                y += label.font.size;
                seq.push(new TypeAction(line, 15, label));
                box.addChild(new Entity().add(label));
            }
            var script = new Script();
            script.run(new Sequence(seq));
            box.add(script);

        case Choice(heading, options):
            var box = new Entity()
                .add(new FillSprite(0x000000, System.stage.width, 50));
            var sprite = box.get(Sprite);
            sprite.alpha._ = 0.8;
            _modeLayer.addChild(box);

            var label = new TextSprite(_ctx.georgia32, heading);
            box.addChild(new Entity().add(label));

            var y = 60.0;
            for (option in options) {
                var box = new Entity()
                    .add(new FillSprite(0x000000, System.stage.width - 40, 50));
                var sprite = box.get(Sprite);
                sprite.alpha._ = 0.8;
                sprite.setXY(20, y);
                sprite.pointerDown.connect(function (_) {
                    show(option.branch);
                });
                y += sprite.getNaturalHeight() + 10;
                _modeLayer.addChild(box);

                var label = new TextSprite(_ctx.georgia32, option.text);
                box.addChild(new Entity().add(label));
            }
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
        switch (music) {
        case Silence:
            return null;
        default:
            var name = Type.enumConstructor(music);
            return _ctx.pack.loadSound("music/" + name);
        }
    }

    private function getActorName (actor :Actor) :String
    {
        return switch (actor) {
            case Mark, MarkHappy, MarkBashful, MarkMigraine: "Mark";
            case Sarah, SarahHappy, SarahBashful, SarahSad, SarahAngry: "Sarah";
            case Nobody: "";
        }
    }

    private var _ctx :NovellaCtx;

    private var _cursor :Screen;
    private var _aggregator :Screen;

    private var _music :Playback;

    private var _actorEntity :Entity;
    private var _backdropEntity :Entity;
    private var _modeLayer :Entity;
}
