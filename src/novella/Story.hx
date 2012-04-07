package novella;

class Story
{
    public static var begin =
        branch()
            .at(Office)
            .with(MarkBashful)
            .saying("This is a test!")
            .playing(Jazz)
        .then()
            .with(MarkHappy)
            .saying("This text is very, very long and should automatically"
                + " wrap into multiple lines. Cuz it's long. Now for a moment of silence.")
        .then()
            .with(Mark)
            .playing(Silence)
        .then()
            .with(MarkMigraine)
            .playing(Jazz)
            .saying("Whoa, I feel a dilemma coming up...")
        .then()
            .choice("Let Mark go home early?"
            , "Yes", branch()
                    .with(MarkHappy)
                    .saying("Finally, it's over!")
                    .playing(Chiptune)
                .then()
                    .saying("Thanks for playing")
                .then()
                    .with(Nobody)
                    .saying("And so I left the office never to be seen again...")
                .then()
                .then()
                    .at(PlaceKitten)
                    .with(Mark)
                    .saying("I CHOOSE YOU, GIANT PLACEHOLDER KITTEN")
            , "Nope", branch()
                    .with(Mark)
                    .saying("Well thanks for nothing. Reload and try again, meanie.")
            );

    public static function branch ()
    {
        return new Screen();
    }
}
