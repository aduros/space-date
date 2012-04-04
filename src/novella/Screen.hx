package novella;

class Screen
{
    public var actor :Actor;
    public var backdrop :Backdrop;
    public var music :Music;
    public var mode :ScreenMode;

    public function new ()
    {
        mode = Blank;
    }

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

    public function playing (music :Music)
    {
        this.music = music;
        return this;
    }

    public function choice (heading :String,
        textA :String, branchA :Array<Screen>, textB :String, branchB :Array<Screen>)
    {
        this.mode = Choice(heading, [new Option(textA, branchA), new Option(textB, branchB)]);
        return this;
    }
}

enum ScreenMode
{
    // Don't show any UI
    Blank;

    // Show the actor saying something
    Speech (text :String);

    // Show a branch in the story
    Choice (heading :String, choices :Array<Option>);
}

class Option
{
    public var text :String;
    public var branch :Array<Screen>;

    public function new (text :String, branch :Array<Screen>)
    {
        this.text = text;
        this.branch = branch;
    }
}
