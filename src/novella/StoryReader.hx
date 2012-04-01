package novella;

import flambe.Component;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.System;

class StoryReader extends Component
{
    public function new (ctx :NovellaCtx, screens :Array<Screen>)
    {
        _ctx = ctx;
        _screens = screens;
        _screenIdx = 0;
    }

    override public function onAdded ()
    {
        var disposer = owner.get(Disposer);
        if (disposer == null) {
            disposer = new Disposer();
            owner.add(disposer);
        }

        _backdropEntity = new Entity();
        disposer.add(_backdropEntity);
        owner.addChild(_backdropEntity);

        _actorEntity = new Entity();
        disposer.add(_actorEntity);
        owner.addChild(_actorEntity);

        disposer.connect1(System.pointer.down, function (_) {
            ++_screenIdx;
            createScreen();
        });
        createScreen();
    }

    private function createScreen ()
    {
        var screen = _screens[_screenIdx];

        if (screen.backdrop != null) {
            _backdropEntity.add(createBackdrop(screen.backdrop));
        }
        if (screen.actor != null) {
            _actorEntity.add(createActor(screen.actor));
        }

        switch (screen.mode) {
        case Speech(text):
            trace(screen.actor + " says, \"" + text + "\"");
        case Choice(heading, textA, outcomeA, textB, outcomeB):
            trace("Choice: " + heading);
            trace("--> " + textA);
            trace("    " + textB);
            _screens = outcomeA;
            _screenIdx = 0;
            createScreen();
        }
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

    // All the screens in the story
    private var _screens :Array<Screen>;

    // The current position into the story we're in
    private var _screenIdx :Int;

    private var _actorEntity :Entity;
    private var _backdropEntity :Entity;
}
