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
    public function new (text :String, timePerChar :Float, ?spriteOverride :TextSprite)
    {
        _text = text;
        _timePerChar = timePerChar;
        _spriteOverride = spriteOverride;

        reset();
    }

    public function update (dt :Float, actor :Entity) :Float
    {
        var sprite = _spriteOverride;
        if (sprite == null) {
            sprite = actor.get(TextSprite);
        }

        _elapsed += dt;
        while (_elapsed >= _delay) {
            _elapsed -= _delay;

            if (_charIdx >= _text.length) {
                var overtime = _elapsed;
                reset();
                return overtime;
            }
            sprite.text = _text.substr(0, _charIdx+1);
            _delay = _timePerChar * charDelay(_text.fastCodeAt(_charIdx));
            ++_charIdx;
        }

        return -1;
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
    private var _timePerChar :Float;

    private var _elapsed :Float;
    private var _delay :Float;
    private var _charIdx :Int;
}
