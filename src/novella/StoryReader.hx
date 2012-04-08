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
                    // Show the next screen
                    show(_cursor.nextScreen);
                } else {
                    // Story's over, go back to the main menu
                    System.root.get(Director).unwindToScene(MainScene.create(_ctx));
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
            var sprite = createActor(screen.actor);
            sprite.setXY(50, System.stage.height - sprite.getNaturalHeight());
            _actorEntity.add(sprite);
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
            sprite.y._ = System.stage.height - sprite.getNaturalHeight();
            _modeLayer.addChild(box);

            var name = getActorName(_aggregator.actor);
            box.addChild(new Entity()
                .add(new TextSprite(_ctx.georgia24, name).setXY(5, -20)));

            var padding = 10;
            var y = 20;
            var width = System.stage.width;
            var lines = _ctx.georgia32.splitLines(text, System.stage.width - 2*padding);
            var seq = [];
            for (line in lines) {
                var label = new TextSprite(_ctx.georgia32);
                label.setXY(padding, y);
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

            var heading = new TextSprite(_ctx.georgia32, heading);
            box.addChild(new Entity().add(heading));

            var y = 60.0;
            for (option in options) {
                var box = new Entity()
                    .add(new FillSprite(0x000000, System.stage.width - 40, 50));
                var sprite = box.get(Sprite);
                sprite.alpha._ = 0.8;
                sprite.setXY(20, y);
                sprite.pointerDown.connect(function (event) {
                    show(option.branch);
                    _ignoreEvent = event; // Flag that this event shouldn't be handled above
                });
                y += sprite.getNaturalHeight() + 10;
                _modeLayer.addChild(box);

                var label = new TextSprite(_ctx.georgia32, option.text);
                label.setXY(sprite.getNaturalWidth()/2 - label.getNaturalWidth()/2,
                    sprite.getNaturalHeight()/2 - label.font.size/2);
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
    private var _disposer :Disposer;
    private var _ignoreEvent :PointerEvent;

    private var _cursor :Screen;
    private var _aggregator :Screen;

    private var _music :Playback;

    private var _actorEntity :Entity;
    private var _backdropEntity :Entity;
    private var _modeLayer :Entity;
}
