//
// Space Date - A short visual novel
// https://github.com/aduros/space-date/blob/master/LICENSE.txt

package novella;

class Screen
{
    public var actor :Actor;
    public var backdrop :Backdrop;
    public var mode :ScreenMode;
    public var music :Music;
    public var transitionType :Transition;

    public var prevScreen :Screen;
    public var nextScreen :Screen;

    public function new ()
    {
        mode = Blank;
    }

    public function transition (transitionType :Transition)
    {
        this.transitionType = transitionType;
        return this;
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

    public function then ()
    {
        nextScreen = new Screen();
        nextScreen.prevScreen = this;
        return nextScreen;
    }

    public function rewind ()
    {
        var screen = this;
        while (screen.prevScreen != null) {
            screen = screen.prevScreen;
        }
        return screen;
    }

    public function choice (textA :String, branchA :Screen, textB :String, branchB :Screen)
    {
        this.mode = Choice([new Option(textA, branchA), new Option(textB, branchB)]);
        return this;
    }

    public function theEnd (ending :Int, text :String)
    {
        this.mode = Ending(ending, text);
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
    Choice (choices :Array<Option>);

    // Reach an ending
    Ending (ending :Int, text :String);
}

class Option
{
    public var text :String;
    public var branch :Screen;

    public function new (text :String, branch :Screen)
    {
        this.text = text;
        this.branch = branch.rewind();
    }
}
