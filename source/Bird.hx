package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

class Bird extends FlxSprite
{

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);

		// pulls graphic from 1 of 3 random bird images
		loadGraphic("assets/images/bird_" + FlxG.random.int(1, 3) + ".png", false, 20, 17);

		//animates the birds on a somewhat random arc across the top of the screen
		FlxTween.quadMotion(this, -40, 0 + FlxG.random.int(0, 10), 199, 90, 270 +FlxG.random.int(1, 30) , -20, FlxG.random.int(1, 3)*1.5+.5, true, { type: FlxTween.LOOPING, loopDelay: 5});		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
