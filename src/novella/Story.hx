package novella;

class Story
{
    public static var begin = [
        screen().at(Office).with(MarkBashful).saying("This is a test!"),
        screen().with(MarkHappy).saying("This text is very, very long and should automatically"
            + " wrap into multiple lines. Cuz it's long. Now for a moment of silence."),
        screen().with(Mark),
        screen().with(MarkMigraine).saying("Whoa, I feel a dilemma coming up..."),
        screen().choice("Let Mark go home early?",
        "Yes", [
            screen().with(MarkHappy).saying("Finally, it's over!"),
            screen().saying("Thanks for playing"),
            screen().with(Nobody).saying("And so I left the office never to be seen again..."),
            screen(),
            screen().at(PlaceKitten).with(Mark).saying("I CHOOSE YOU, GIANT PLACEHOLDER KITTEN"),
        ],
        "Nope", [
            screen().with(Mark).saying("Well thanks for nothing. Reload and try again, meanie."),
        ]),
    ];

    private static function screen ()
    {
        return new Screen();
    }
}
