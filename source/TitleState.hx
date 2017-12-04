package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class TitleState extends FlxState
{
    override public function create():Void
	{
		super.create();

        FlxG.mouse.useSystemCursor = true;

        FlxG.camera.fade(0x161720,.1,true);

		var title = new FlxSprite();
		title.loadGraphic("assets/images/Title.png");
		add(title);

        if(FlxG.sound.defaultMusicGroup.sounds.length == 0) FlxG.sound.playMusic("assets/music/LD40_-again.ogg",.4);
	}

	override public function update(elapsed)
    {
		super.update(elapsed);

		if(FlxG.keys.justPressed.SPACE){
			FlxG.camera.fade(0x161720,0.6,false,start);
		}
	}

	public function start(){
		FlxG.switchState(new PlayState());
	}
}