package novella;

class Story
{
    public static var SOON = branch().with(MarkMigraine).saying("Whoa, hold on! This part isn't done yet.");

    public static var intro =
        branch()
            .at(Intro)
            .with(Nobody).saying("Welcome to SpAAAce! Our company provides the best care for your short range shuttle while you live on Tera Moon 1. We strive to show you just how much we care, so let's follow one of our hard working employees thought a tough time in their life! Since watching things happen is a bit boring, let's also help him choose what paths to take! We can because we CARE sooo much here at SpAAAce.")
        .then()
            .at(Office).playing(Cipher)
            .with(Mark).saying("Another nice day outside. Normally I'd be pretty upset about having to spend all morning indoors like this...")
        .then()
            .with(MarkHappy).saying("However, today Sarah is also in the office. I think I can bear it if she's here too.")
        .then()
            .with(MarkBashful).saying("I'm not going to lie... it was love at first sight for me. I haven't said anything yet though. Just small office chat here and there.")
        .then()
            .with(MarkHappy).saying("Today is the day though, I'm going to tell Sarah how I feel! Maybe. Right after I finish this report for the boss.")
        .then()
            .with(Nobody).saying("Several hours of work later...")
        .then()
            .at(Blocks).playing(Rising)
            .with(MarkMigraine).saying("I can't look at the screen anymore, my eyes are burning! I need a break or something. Maybe splash water on my face, or go talk with a co-worker for a bit.")
        .then()
            .choice("Choose what Mark will do.",
                "Wash face then finish report", partA,
                "Go talk to Sarah for a bit", partB)
        ;

    // Inlined to prevent static initialization order problems
    inline private static var partA =
        branch()
            .with(Mark).saying("After several hours of work, that darn report is finally done. It's time for lunch and it looks like Sarah has already went.")
        .then()
            .with(MarkHappy).saying("I almost forgot! Dan and Lori wanted to go out for lunch. I might be able to catch them still.")
        .then()
            .at(Cafe).playing(Mandeville)
            .with(Nobody).saying("The Cafe is alive with lunch time customers, a formiliar voice comes from a near by table.")
        .then()
            .with(DanHappy).saying("Mark, you're late as usual! Come over here and grab a bite to eat already!")
        .then()
            .with(Lori).saying("Sheesh, you look terrible. Did you run here or something?")
        .then()
            .with(Mark).saying("I accidently worked into my lunch hour. Pass me some of your fries, I won't be here all that long.")
        .then()
            .with(Dan).saying("I thought today was the 'big day'. What happened?")
        .then()
            .with(Mark).choice("What will Mark tell his friends?",
                "Today is too busy, you haven't even talk to her yet", ending1,
                "Today is the day, just had to finish a report first", ending2)
        ;

    inline private static var partB = SOON;

    inline private static var ending1 =
        branch()
            .with(MarkMigraine).saying("Yeah, today was suppossed to be the day. The boss gave us a huge report though. I've been too busy with work to talk to her.")
        .then()
            .with(Lori).saying("Your work will be there tomorrow, but she might not be if you keep putting this off!")
        .then()
            .with(Dan).saying("Lori, be nice. Sarah has the same work though, right? Talk with her anyways, see if you can set up a date for after work.")
        .then()
            .with(Mark).saying("Thanks guys. I think I should head back now...")
        .then()
            .with(Lori).saying("Come back here after work, we'll get you a real meal instead of just fries!")
        .then()
            .at(Office).playing(Cipher)
            .with(Nobody).saying("You can hear the hum of the printer and it's angry beeps of it wanting more paper. After telling your computer to print your report, you head over to the printer as well.")
        .then()
            .at(Printer)
            .with(MarkHappy).saying("Hiya Sarah, is the printer fighting back again?")
        .then()
            .with(Sarah).saying("Oh, hey Mark. It keeps saying it wants more paper but refuses to take any I give it.")
        .then()
            .with(Mark).saying("Crazy thing. You'd think with all the advanced technology lately, we'd invent better printers. Let's see if we can get it to work...")
        .then()
            .with(Sarah).saying("I think it's our punishment for not taking a field job. Hey, you got it to work! Thank you Mark.")
        .then()
            .with(MarkBashful).saying("You're welcome... um.. Sarah? There's something I want to talk to you about, once we're both off the clock.")
        .then()
            .at(Cafe).playing(AwesomeCall)
            .with(MarkCasualHappy).saying("It's been two weeks now! I no longer work as a paper pusher at SpAAAce!")
        .then()
            .with(SarahCasualBashful).saying("I know it's been two weeks, why are you shouting it out like that?")
        .then()
            .with(MarkCasualBashful).saying("I uh... felt like there was someone who waiting to still find out. You know, should and pretty much everyone near by hears you...")
        .then()
            .with(Dan).saying("Anyways, what have you two been up to? You basically left me hanging two weeks ago. Both of you up and vanished for a bit.")
        .then()
            .with(SarahCasual).saying("That report was actually a test from our boss. Who ever got it finished was to be promoted. Two spots had opened up and they figured this was the easiest way to choose who got it.")
        .then()
            .with(MarkCasualHappy).saying("After we both heard the good news and realized we finally have time for a social life, we started dating.")
        .then()
            .with(Dan).saying("Well I'll be! Haha, congrats you two. I hope it works out, you've both worked hard for it.")
        .then()
            .with(MarkCasualHappy).saying("As long as I never have to see that report again, I think we'll be fine.")
        .then()
            .with(Nobody).saying("This ends our time following Mark, the desk minion. Thank you for spending your time at SpAAACe with us! We hope to see you... in the future!")
        .then()
            .theEnd(1)
        ;

    inline private static var ending2 =
        branch()
            .with(Mark).saying("Nothing happened, I just had to get some work done first. The boss gave us some huge report to finish today.")
        .then()
            .with(Lori).saying("They sure do like to try and drive you crazy with those things. Did you get it done? Are you going to see her right after this?")
        .then()
            .with(Mark).saying("Yes to both. We both still have to print our reports, so I'll probably catch her at the printer.")
        .then()
            .with(Dan).saying("Well you better chow down on those fries and hurry on back there! Let's all meet back up after work, I want to hear what happens and you need real food in you.")
        .then()
            .with(Lori).saying("You two can eat, I want to hear every detail when you get back! Skip nothing!")
        .then()
            .with(MarkBashful).saying("I better run back now. Thanks guys.")
        .then()
            .at(Office).playing(Cipher)
            .with(Nobody).saying("The office seems too quite, not even the growl of the printer can be heard.")
        .then()
            .with(Mark).saying("I guess I missed her... I should look over that report one more time...")
        .then()
            .at(Blocks)
            .with(Mark).saying("...")
        .then()
            .with(Sarah).saying("Mark? What are you still doing here?")
        .then()
            .with(Mark).saying("...")
        .then()
            .at(Office)
            .with(Sarah).saying("Earth to Mark on Tera moon 1, can you hear me? Is that report really so intersting or has it finally taken someone's soul?")
        .then()
            .with(Mark).saying("Ah! Uh.. hey Sarah, sorry. I was..uh... over thinking something.")
        .then()
            .with(Sarah).saying("Don't over think too much, you'll fry your brain. Tell you what, I was heading out to go see a late movie. Mars Girl 2, did you want to come with me?")
        .then()
            .with(MarkHappy).saying("I- yeah! Yes, I, sure. Let me just print this and we can go! I've been trying to find and talk with you, so this works out great.")
        .then()
            .with(SarahHappy).saying("Good! Hurry up, time waits for no one and I'm not going to miss the intro to the movie because your being slow.")
        .then()
            .at(Cafe).playing(AwesomeCall)
            .with(MarkCasualHappy).saying("I can't believe this. I'm no longer a paper pusher for SpAAAce, I've got my own office now, and I'm going to be married soon!")
        .then()
            .with(Dan).saying("You might want to send me a email or something next time you decide to drop off the face of the moon like that. That goes for both of you!")
        .then()
            .with(SarahCasualHappy).saying("We're sorry, work and everything just happened so fast... seems like just yesterday we went to the movies and talked about how we both felt.")
        .then()
            .with(Lori).saying("Aww, you two are just so cute! It's always wonderful to see two people stepping towards the future together like that... Isn't it, Dan?")
        .then()
            .with(Dan).saying("Ah... Mark! Tell me, what have you two been up to the month you've both been gone?")
        .then()
            .with(Lori).saying("*Pouts*")
        .then()
            .with(MarkCasual).saying("That report was actually a test from our boss. Whoever got it finished correctly was to be promoted. Two spots had opened up and they figured this was the easiest way to choose who got it.")
        .then()
            .with(SarahCasualHappy).saying("After we both heard the good news and realized we finally had time for a social life, we started to hang out together more... and here we are now.")
        .then()
            .with(Lori).saying("I'm glad to hear it! It couldn't have happened to a better couple! Plus you get to wear those awesome traditional clothes, a suit and tie, a white dress and vail...")
        .then()
            .with(Dan).saying("Ahem, ah, We'll be here if you need help with anything. Congratulations you two!" )
        .then()
            .with(SarahCasualHappy).saying("Hehe, Thank you. Both of you.")
        .then()
            .with(MarkCasual).saying("Now, let's eat!")
        .then()
            .with(Nobody).saying("This ends our time following Mark, the desk minion. Who would have guessed we would be so helpful? Thank you for spending your time at SpAAACe with us! We hope to see you... in the future!")
        .then()
            .theEnd(2)
        ;

    public static function branch ()
    {
        return new Screen();
    }
}
