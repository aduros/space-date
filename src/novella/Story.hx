package novella;

class Story
{
    public static var begin = [
        screen().at(Office).with(MarkBashful).saying("This is a test!"),
        screen().with(Narrator).saying("Previous settings are rolled into following screens"),
        screen().choice("Welcome to Mark's mind. Do you accept the charges?",
        "Yes", [
            screen().with(MarkHappy).saying("Finally, it's over!"),
            screen().saying("Thanks for playing"),
        ],
        "Nope", [
            screen().at(Graveyard).with(Narrator).saying("GAME OVER"),
        ]),
    ];

    private static function screen ()
    {
        return new Screen();
    }
}
