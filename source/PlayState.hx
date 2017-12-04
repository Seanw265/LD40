package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxSort;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{

	var stove:Stove;
	var arthrometer:Arthrometer;
	var scoreDisplay:ScoreDisplay;

	var hotdogGroup:FlxTypedGroup<Hotdog>;

	var hotdogOverlapList:FlxTypedGroup<Hotdog>;

	var increaseWindow = .5;
	var clickTimer = 100000.0;
	var increaseRate = 0.0; //.003;
	var lowerBound = .0008;
	var upperBound = .0055;
	var difficultyMultiplier = 1.0;

	var arthroMashRate = 0.2;

	var gameOverB = false;

	var largeEmitter:FlxEmitter;

	var scoreBMFont:FlxBitmapFont;

	var hotdogKey = "j";
	var stoveKey = "k";
	var arthroKey = "l";

	var goodSounds = ["assets/sounds/Delicious_1.wav",
	"assets/sounds/Hotdog_1.wav",
	"assets/sounds/Hotdog2_1.wav",
	"assets/sounds/HotdogForPresident_1.wav",
	"assets/sounds/IDoLoveMeSomeHotdogs_1.wav",
	"assets/sounds/Nice_1.wav",
	"assets/sounds/OhYeah_1.wav",
	"assets/sounds/Spell_1.wav"];

	var coldSounds = ["assets/sounds/TooCold_1.wav",
	"assets/sounds/EwGross_1.wav"];
	
	var loseSounds = ["assets/sounds/AghArthritis_1.wav",
	"assets/sounds/AghMyHand_1.wav",
	"assets/sounds/Nooo_1.wav"];

	var munchSounds = ["assets/sounds/Munch2_1.wav",
	"assets/sounds/Munch2_2.wav",
	"assets/sounds/Munch2_5.wav",
	"assets/sounds/Munch2_7.wav",
	"assets/sounds/Munch2.wav"
	];

	var wooshSounds = ["assets/sounds/Woosh_1.wav",
	"assets/sounds/Woosh_2.wav",
	"assets/sounds/Woosh_3.wav",
	"assets/sounds/Woosh_5.wav",
	"assets/sounds/Woosh.wav"];

	var arthritisFixerSounds = ["assets/sounds/ArthritisFixer.wav",
	"assets/sounds/ArthritisFixer_1.wav",
	"assets/sounds/ArthritisFixer_2.wav",
	"assets/sounds/ArthritisFixer_3.wav",
	"assets/sounds/ArthritisFixer_5.wav"];

	var lastCold = 10.0;

	var soundTimer:FlxTimer;

	var canMunchSound = true;

	override public function create():Void
	{
		super.create();


		this.bgColor = 0x161720ff;

		FlxG.camera.fade(0x161720,0.1,true);

		stove = new Stove();
		add(stove);

		hotdogGroup = new FlxTypedGroup<Hotdog>();
		add(hotdogGroup);

		hotdogOverlapList = new FlxTypedGroup<Hotdog>();

		var hotdogButton = new FlxButton(240,24,null,addHotdogs);
		hotdogButton.loadGraphic("assets/images/HotdogButton.png",true,64,40);
		add(hotdogButton);

		var arthrometerButton = new FlxButton(240,64,null,arthroMash);
		arthrometerButton.loadGraphic("assets/images/ArthrometerButton.png",true,64,40);
		add(arthrometerButton);

		var arthrometerDisplay = new FlxSprite(16,0);
		arthrometerDisplay.loadGraphic("assets/images/Arthrometer.png");
		add(arthrometerDisplay);

		arthrometer = new Arthrometer();
		arthrometer.x = 109;
		arthrometer.y = 10;
		add(arthrometer);

		scoreDisplay = new ScoreDisplay();
		scoreDisplay.x = FlxG.width - 4;
		scoreDisplay.y = arthrometerButton.y + arthrometerButton.height + 0;
		add(scoreDisplay);

		largeEmitter = new FlxEmitter(stove.getBounds().x,stove.getBounds().y,200);
		largeEmitter.loadParticles("assets/images/Smoke.png",200);
		largeEmitter.setSize(stove.getBounds().width,stove.getBounds().height);
		largeEmitter.start(false,.02);
		largeEmitter.launchMode = FlxEmitterMode.SQUARE;
		largeEmitter.velocity.set(-10,-30,10,-80);
		largeEmitter.alpha.set(.05,.15,0,0);
		largeEmitter.scale.set(.9,.9,3,3,1,1,4,4);
		add(largeEmitter);

		scoreBMFont = FlxBitmapFont.fromMonospace("assets/images/Numbers.png","-1234567890",FlxPoint.get(9,16));

		soundTimer = new FlxTimer();
		waitAndDoSounds();

		// stove.scale.set(1.05,1.05);

		
	}

	
	public function waitAndDoSounds()
	{
		if(!gameOverB)
		{
			soundTimer.start(Math.random()*4+1,function(timer) doSounds(),1);
		}
	}

	public function doSounds(){
		if(gameOverB) return;

		if(lastCold < 8.0 && Math.random() < .7)
		{
			FlxG.sound.play(coldSounds[Std.random(coldSounds.length)],0.8,false,null,true,waitAndDoSounds);
		}
		else
		{
			FlxG.sound.play(goodSounds[Std.random(goodSounds.length)],0.8,false,null,true,waitAndDoSounds);
		}
	}

	public function readyMunchSounds(){
		canMunchSound = true;
	}

	public function arthroMash()
	{
		screenShake();
		FlxG.sound.play(arthritisFixerSounds[Std.random(arthritisFixerSounds.length)],0.8);


		arthrometer.value -= arthroMashRate;
		increaseRate = 0.0;
	}

	public function addHotdogs()
	{
		screenShake();
		FlxG.sound.play(wooshSounds[Std.random(wooshSounds.length)]);

		for (i in 0...1)
		{
			var hotdog = new Hotdog();
			hotdog.offset.set(hotdog.width/2,hotdog.height/2);
			hotdogGroup.add(hotdog);

			hotdog.width = 1;
			hotdog.height = 1;

			hotdog.x = stove.getBounds().x + stove.getBounds().width/2;
			hotdog.y = -100;

			var xPos = Std.random(Std.int(stove.getBounds().width - Hotdog.xPadding)) + stove.getBounds().x + Hotdog.xPadding/2;
			var yPos = Std.random(Std.int(stove.getBounds().height - Hotdog.yPadding)) + stove.getBounds().y + Hotdog.yPadding/2;

			FlxTween.tween(hotdog,{x:xPos,y:yPos},(Math.random()/2+.5)/2,{ease:FlxEase.sineOut});

			
		}
	}

	public function hotdogOverlaps(hotdog:Hotdog,mouseObject:FlxObject)
	{
		hotdogOverlapList.add(hotdog);
	}

	function hotdogSort(order:Int,hotdog1:Hotdog,hotdog2:Hotdog):Int 
	{
		if(hotdog1 == null) return -order;
		if(hotdog2 == null) return order;
		return FlxSort.byValues(order,hotdog1.animation.frameIndex,hotdog2.animation.frameIndex);
	}

	function gameOver()
	{
		gameOverB = true;
		FlxG.sound.defaultSoundGroup.pause();
		FlxG.camera.fade(FlxColor.WHITE,.4,true,fadeToBlack);
		FlxG.sound.play(loseSounds[Std.random(loseSounds.length)],.95,false);
	}

	function fadeToBlack()
	{
		FlxG.camera.fade(0x161720,1.5,false,toGameOverState);
	}

	function toGameOverState()
	{
		var gameOverState = new GameOverState();
		gameOverState.setScore(scoreDisplay.actualScore);
		FlxG.switchState(gameOverState);
	}

	function increaseArthrometerRate()
	{
		increaseRate += .0005;
		if(increaseRate > upperBound*difficultyMultiplier) increaseRate = upperBound*difficultyMultiplier;
	}

	function screenShake()
	{
		FlxG.camera.shake(.008,.07,null,true);
	}

	function showScreenThing()
	{

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		clickTimer += elapsed;

		hotdogOverlapList.sort(hotdogSort,FlxSort.DESCENDING);
		for(i in 0...2)
		{	
			if(hotdogOverlapList.getFirstAlive() != null)
			{
				var hotdog = hotdogOverlapList.getFirstAlive();
				FlxTween.tween(hotdog,{x:-200,y:Std.random(350)-Math.abs(350-FlxG.height)/2},Math.random()*.3+.4,{ease:FlxEase.quadOut,onComplete:function(tween) hotdogGroup.remove(hotdog)});
				scoreDisplay.incrementScore(hotdog.getScore());

				var score = new FlxBitmapText(scoreBMFont);
				score.text = Std.string(hotdog.getScore());
				score.x = hotdog.x;
				score.y = hotdog.y;
				FlxTween.tween(score,{x:scoreDisplay.x,y:scoreDisplay.y},Math.random()*.2+.1,{ease:FlxEase.quadOut,onComplete:function(tween)remove(score)});
				add(score);

				if(hotdog.animation.frameIndex < 2) lastCold = 0;

				if(canMunchSound)
				{
					FlxG.sound.play(munchSounds[Std.random(munchSounds.length)],.7,false,null,true,readyMunchSounds);
				}
			}
		}
		hotdogOverlapList.forEach(function (hotdog) hotdogOverlapList.remove(hotdog),false);

		lastCold += elapsed;

		if(FlxG.keys.anyJustPressed([FlxKey.fromString(hotdogKey)]))
		{
			addHotdogs();
			increaseArthrometerRate();
		}
		else if(FlxG.keys.anyJustPressed([FlxKey.fromString(arthroKey)]))
		{
			arthroMash();
		}
		else if(FlxG.keys.anyJustPressed([FlxKey.fromString(stoveKey)]))
		{
			screenShake();
			increaseArthrometerRate();
			var stoveBounds = stove.getBounds();
			var mouseBasic = new FlxObject(stoveBounds.x,stoveBounds.y,stoveBounds.width,stoveBounds.height);
			FlxG.overlap(hotdogGroup,mouseBasic,hotdogOverlaps);
		}

		if(FlxG.mouse.justReleased)
		{
			screenShake();
			var mouseSize = 48;
			var mouseBasic = new FlxObject(FlxG.mouse.x-Std.int(mouseSize/2),FlxG.mouse.y-Std.int(mouseSize/2),Std.int(mouseSize),Std.int(mouseSize));
			FlxG.overlap(hotdogGroup,mouseBasic,hotdogOverlaps);
			increaseArthrometerRate();
		}

		FlxG.watch.addQuick("clickTimer",clickTimer);
		FlxG.watch.addQuick("increaseWindow",increaseWindow);
		FlxG.watch.addQuick("arthrometer",arthrometer.value);

		difficultyMultiplier = 1 + scoreDisplay.actualScore/3000;

		arthrometer.value += increaseRate;
		increaseRate -= .00002;
		if(increaseRate < lowerBound*difficultyMultiplier) increaseRate = lowerBound*difficultyMultiplier;

		if(arthrometer.value == 1 && !gameOverB)
		{
			gameOver();
		}

		if(gameOverB)
		{
			if(FlxG.keys.justPressed.SPACE){
				FlxG.resetState();
			}
		}

		stove.setKnobSpeed(increaseRate * 100000);
	}
}
