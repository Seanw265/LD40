package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class GameOverState extends FlxState
{

    var scoreDisplay:ScoreDisplay;
    var score = 0;

    public function new()
    {
        super();
        scoreDisplay = new ScoreDisplay();
        scoreDisplay.x = 274;
        scoreDisplay.y = 105;
    }

    override public function create():Void
	{
		super.create();

        FlxG.camera.fade(0x161720,2,true);

		var title = new FlxSprite();
		title.loadGraphic("assets/images/GameOver2.png");
		add(title);
        
        add(scoreDisplay);
        scoreDisplay.incrementScore(score);
	}

    public function setScore(score:Int)
    {
        this.score = score;
    }

	override public function update(elapsed)
    {
		super.update(elapsed);

		if(FlxG.keys.justPressed.SPACE){
			FlxG.camera.fade(0x161720,0.6,false,start);
		}
	}

	public function start(){
		FlxG.switchState(new TitleState());
	}
}