package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class Arthrometer extends FlxSpriteGroup
{

    @:isVar public var value (get, set):Float;

    var maxScalerWidth = 0;

    var backSprite:FlxSprite;
    var backSpriteLeftCap:FlxSprite;
    var backSpriteRightCap:FlxSprite;

    var frontSprite:FlxSprite;
    var frontSpriteLeftCap:FlxSprite;
    var frontSpriteRightCap:FlxSprite;

    public function new()
    {
        super();

        this.width = 193;

        backSprite = new FlxSprite();
        backSpriteLeftCap = new FlxSprite();
        backSpriteRightCap = new FlxSprite();
        backSprite.loadGraphic("assets/images/ArthrometerBackSpriteScaler.png");
        backSpriteLeftCap.loadGraphic("assets/images/ArthrometerBackSpriteCap.png");
        backSpriteRightCap.loadGraphic("assets/images/ArthrometerBackSpriteCap.png");

        frontSprite = new FlxSprite();
        frontSpriteLeftCap = new FlxSprite();
        frontSpriteRightCap = new FlxSprite();
        frontSprite.loadGraphic("assets/images/ArthrometerFrontSpriteScaler.png");
        frontSpriteLeftCap.loadGraphic("assets/images/ArthrometerFrontSpriteCap.png");
        frontSpriteRightCap.loadGraphic("assets/images/ArthrometerFrontSpriteCap.png");

        backSprite.x = (backSpriteLeftCap.width/2);
        frontSprite.x = (frontSpriteLeftCap.width/2);

        add(backSprite);
        add(backSpriteLeftCap);
        add(backSpriteRightCap);

        add(frontSprite);
        add(frontSpriteLeftCap);
        add(frontSpriteRightCap);

        maxScalerWidth = 193-Std.int(backSpriteLeftCap.width);

        backSprite.setGraphicSize(maxScalerWidth,9);
        backSprite.updateHitbox();
        backSpriteRightCap.x = this.x + backSprite.width;
    }

    public function set_value(value:Float):Float
    {
        this.value = value;
        if(this.value > 1) this.value = 1;
        if(this.value < 0) this.value = 0;

        frontSprite.setGraphicSize(Std.int(value*maxScalerWidth),9);
        frontSprite.updateHitbox();
        frontSpriteRightCap.x = this.x + frontSprite.width;

        return this.value;
    }

    function get_value(){
        return value;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}