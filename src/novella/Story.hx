package novella;

class Story
{
    public static var begin = [
        screen().at(Office).with(MarkBashful).saying("This is a test!"),
        screen().with(MarkHappy).saying("This text is very, very long and should automatically"
            + " wrap into multiple lines. Cuz it's long."),
        screen(),
        screen().with(MarkMigraine).choice("Welcome to Mark's mind. Do you accept the charges?",
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
