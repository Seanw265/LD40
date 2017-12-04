package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

import openfl.geom.Rectangle;

class Stove extends FlxSpriteGroup
{

    var knob1:FlxSprite;
    var knob2:FlxSprite;
    var knob3:FlxSprite;
    var knob4:FlxSprite;

    public function new()
    {
        super();

        knob1 = new FlxSprite(20,135);
        knob1.loadGraphic("assets/images/SquareKnob1.png");
        add(knob1);

        knob2 = new FlxSprite(76,135);
        knob2.loadGraphic("assets/images/SquareKnob2.png");
        add(knob2);

        knob3 = new FlxSprite(148,135);
        knob3.loadGraphic("assets/images/SquareKnob1.png");
        add(knob3);

        knob4 = new FlxSprite(204,135);
        knob4.loadGraphic("assets/images/SquareKnob2.png");
        add(knob4);

        knob1.angle = Std.random(360);
        knob2.angle = Std.random(360);
        knob3.angle = Std.random(360);
        knob4.angle = Std.random(360);

        var stove = new FlxSprite();
        stove.loadGraphic("assets/images/StoveWithHolesForKnobs.png",false);
        add(stove);
    }

    public function setKnobSpeed(speed:Float)
    {
        FlxG.watch.addQuick("KnobSpeed",speed);
        knob1.angularVelocity = speed;
        knob2.angularVelocity = speed * 1.2;
        knob3.angularVelocity = speed * 3;
        knob4.angularVelocity = speed * 2.2;
    }

    public function getBounds():Rectangle
    {
        return new Rectangle(16,24,224,112);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}