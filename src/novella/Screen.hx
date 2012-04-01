package novella;

class Screen
{
    public var actor :Actor;
    public var backdrop :Backdrop;
    public var mode :ScreenMode;

    public function new () { }

    public function at (backdrop :Backdrop)
    {
        this.backdrop = backdrop;
        return this;
    }

    public function with (actor :Actor)
    {
        this.actor = actor;
        return this;
    }

    public function saying (text :String)
    {
        this.mode = Speech(text);
        return this;
    }

    public function choice (text :String,
        textA :String, outcomeA :Array<Screen>, textB :String, outcomeB :Array<Screen>)
    {
        this.mode = Choice(text, textA, outcomeA, textB, outcomeB);
        return this;
    }
}

enum ScreenMode
{
    Speech (text :String);
    Choice (heading :String,
        textA :String, outcomeA :Array<Screen>, textB :String, outcomeB :Array<Screen>);
}
