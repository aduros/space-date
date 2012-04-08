package novella;

import flambe.script.Action;
import flambe.display.TextSprite;
import flambe.Entity;

using StringTools;

/**
 * An Action that animates text being typed character by character.
 */
class TypeAction implements Action
{
    public function new (text :String, msPerChar :Int, ?spriteOverride :TextSprite)
    {
        _text = text;
        _msPerChar = msPerChar;
        _spriteOverride = spriteOverride;

        reset();
    }

    public function update (dt :Int, actor :Entity) :Bool
    {
        var sprite = _spriteOverride;
        if (sprite == null) {
            sprite = actor.get(TextSprite);
        }

        _elapsed += dt;
        while (_elapsed >= _delay) {
            _elapsed -= _delay;

            if (_charIdx >= _text.length) {
                reset();
                return true;
            }
            sprite.text = _text.substr(0, _charIdx+1);
            _delay = _msPerChar * charDelay(_text.fastCodeAt(_charIdx));
            ++_charIdx;
        }

        return false;
    }

    public function reset ()
    {
        _elapsed = 0;
        _delay = 0;
        _charIdx = -1;
    }

    public static function charDelay (charCode :Int) :Int
    {
        // Sentence delimitters cause the animation to pause for a moment
        switch (charCode) {
            case '.'.code, '!'.code, '?'.code: return 20;
            default: return 1;
        }
    }

    private var _text :String;
    private var _spriteOverride :TextSprite;
    private var _msPerChar :Int;

    private var _elapsed :Int;
    private var _delay :Int;
    private var _charIdx :Int;
}
