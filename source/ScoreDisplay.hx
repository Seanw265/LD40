package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class ScoreDisplay extends FlxSpriteGroup
{

    @:isVar public var displayScore (get,set):Int;
    public var actualScore:Int;

    var bitmapFont:FlxBitmapFont;
    var scoreDisplay:FlxBitmapText;

    public function new()
    {
        super();

        bitmapFont = FlxBitmapFont.fromMonospace("assets/images/NumbersPink.png","p1234567890",FlxPoint.get(9,16));
        scoreDisplay = new FlxBitmapText(bitmapFont);
        scoreDisplay.text = "0";
        scoreDisplay.width = 300;
        scoreDisplay.autoSize = false;
        scoreDisplay.alignment = FlxTextAlign.RIGHT;
        scoreDisplay.multiLine = false;
        // scoreDisplay.wordWrap = false;
        add(scoreDisplay);

    }

    function get_displayScore():Int
    {
        return this.displayScore;
    }

    function set_displayScore(displayScore):Int
    {
        this.displayScore = displayScore;
        scoreDisplay.text = Std.string(displayScore).replace("-","p");
        return displayScore;
    }

    public function incrementScore(score):Void
    {
        actualScore += score;
        FlxTween.tween(this,{displayScore:actualScore},1,{ease:FlxEase.quadOut});
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}