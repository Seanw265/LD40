package;

import flixel.FlxSprite;
import flixel.FlxG;

class Hotdog extends FlxSprite
{

    public static var xPadding = 64;
    public static var yPadding = 64;

    var lifetime = 0.0;
    var nextLength:Float = Math.random() + .5;

    var totalNormalFrames = 6;

    public function new()
    {
        super();
        this.loadGraphic("assets/images/Hotdogs.png",true,16,64);

        this.angle = Std.random(360);

        // this.width = 64;
        // this.height = 64;

        this.angularVelocity = Std.random(60)+10;
        this.angularDrag = Std.random(20)+20;

        this.animation.frameIndex = Std.random(3);

    }

    public function getScore():Int
    {
        var returnValue = 0;
        switch (this.animation.frameIndex)
        {
            case 0: returnValue = -200;
            case 1: returnValue = -100;
            case 2: returnValue = 50;
            case 3: returnValue = 100;
            case 4: returnValue = 200;
            case 5: returnValue = 100;
            case 6: returnValue = -25;
            case 7: returnValue = 1000;
            default: returnValue = 0;
        }

        return returnValue;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        lifetime += elapsed;

        if(lifetime > nextLength)
        {
            lifetime = 0;
            if(this.animation.frameIndex < totalNormalFrames){
                this.animation.frameIndex++;
                nextLength = Math.random() + .5;
            }
        }
    }
}