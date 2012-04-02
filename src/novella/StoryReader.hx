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
import flambe.System;

import novella.Screen;

class StoryReader extends Component
{
    public function new (ctx :NovellaCtx, screens :Array<Screen>)
    {
        _ctx = ctx;
        _screens = screens;
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

        _screenIdx = 0;
        _current = new Screen();

        disposer.connect1(System.pointer.down, function (_) {
            switch (_current.mode) {
            case Blank, Speech(_):
                ++_screenIdx;
                createScreen();
            default:
                // Do nothing
            }
        });
        createScreen();
    }

    private function createScreen ()
    {
        var next = _screens[_screenIdx];

        if (next.backdrop != null && next.backdrop != _current.backdrop) {
            _backdropEntity.add(createBackdrop(next.backdrop));
            _current.backdrop = next.backdrop;
        }

        if (next.actor != null && next.actor != _current.actor) {
            var sprite = createActor(next.actor);
            sprite.setXY(50, System.stage.height - sprite.getNaturalHeight());
            _actorEntity.add(sprite);
            _current.actor = next.actor;
        }

        _modeLayer.disposeChildren();

        switch (next.mode) {
        case Blank:
            // Nothing

        case Speech(text):
            var box = new Entity()
                .add(new FillSprite(0x000000, System.stage.width, 100));
            var sprite = box.get(Sprite);
            sprite.y._ = System.stage.height - sprite.getNaturalHeight();
            sprite.alpha._ = 0.8;
            _modeLayer.addChild(box);

            var y = 0;
            var width = System.stage.width;
            var lines = _ctx.mainFont.splitLines(
                _current.actor + " says, \"" + text + "\"", System.stage.width);
            var seq = [];
            for (line in lines) {
                var label = new TextSprite(_ctx.mainFont);
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

            var label = new TextSprite(_ctx.mainFont, heading);
            box.addChild(new Entity().add(label));

            var y = 60.0;
            for (option in options) {
                var box = new Entity()
                    .add(new FillSprite(0x000000, System.stage.width - 40, 50));
                var sprite = box.get(Sprite);
                sprite.alpha._ = 0.8;
                sprite.setXY(20, y);
                sprite.pointerDown.connect(function (_) {
                    _screens = option.branch;
                    _screenIdx = 0;
                    createScreen();
                });
                y += sprite.getNaturalHeight() + 10;
                _modeLayer.addChild(box);

                var label = new TextSprite(_ctx.mainFont, option.text);
                box.addChild(new Entity().add(label));
            }
        }
        _current.mode = next.mode;
    }

    private function createActor (actor :Actor) :Sprite
    {
        var name = Type.enumConstructor(actor);
        return new ImageSprite(_ctx.pack.loadTexture("actors/" + name + ".png"));
    }

    private function createBackdrop (backdrop :Backdrop) :Sprite
    {
        var name = Type.enumConstructor(backdrop);
        return new ImageSprite(_ctx.pack.loadTexture("backdrops/" + name + ".jpg"));
    }

    private var _ctx :NovellaCtx;

    private var _current :Screen;

    // All the screens in the story
    private var _screens :Array<Screen>;

    // The current position into the story we're in
    private var _screenIdx :Int;

    private var _actorEntity :Entity;
    private var _backdropEntity :Entity;
    private var _modeLayer :Entity;
}
