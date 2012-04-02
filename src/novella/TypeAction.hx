package novella;

import flambe.script.Action;
import flambe.display.TextSprite;
import flambe.Entity;

/**
 * An Action that animates text being typed character by character.
 */
class TypeAction implements Action
{
    public function new (text :String, msPerChar :Int, ?spriteOverride :TextSprite)
    {
        _text = text;
        _duration = text.length * msPerChar;
        _spriteOverride = spriteOverride;
    }

    public function update (dt :Int, actor :Entity) :Bool
    {
        var sprite = _spriteOverride;
        if (sprite == null) {
            sprite = actor.get(TextSprite);
        }

        _elapsed += dt;
        if (_elapsed >= _duration) {
            sprite.text = _text;
            _elapsed = 0;
            return true;
        }

        var n = Std.int(_text.length * _elapsed/_duration);
        if (n != sprite.text.length) {
            sprite.text = _text.substr(0, n);
        }
        return false;
    }

    private var _text :String;
    private var _spriteOverride :TextSprite;
    private var _elapsed :Int;
    private var _duration :Int;
}
