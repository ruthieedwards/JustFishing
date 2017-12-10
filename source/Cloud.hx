package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class Cloud extends FlxSprite
{
	public var cloudTypeNumber: Int;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);

		//there's a better way to do this (cases) but this was a jam game, lol
		cloudTypeNumber = FlxG.random.int(0, 10);

		this.alpha = FlxG.random.float(.1, 1);

		if (cloudTypeNumber == 0)
		{
			loadGraphic("assets/images/cloud_0.png", false, 58, 19);
		}

		if (cloudTypeNumber == 1)
		{
			loadGraphic("assets/images/cloud_1.png", false, 29, 11);
		}

		if (cloudTypeNumber == 2)
		{
			loadGraphic("assets/images/cloud_2.png", false, 11, 6);
		}

		if (cloudTypeNumber == 3)
		{
			loadGraphic("assets/images/cloud_3.png", false, 26, 10);
		}

		if (cloudTypeNumber == 4)
		{
			loadGraphic("assets/images/cloud_4.png", false, 33, 10);
		}

		if (cloudTypeNumber == 5)
		{
			loadGraphic("assets/images/cloud_5.png", false, 18, 8);
		}

		if (cloudTypeNumber == 6)
		{
			loadGraphic("assets/images/cloud_6.png", false, 34, 13);
		}

		if (cloudTypeNumber == 7)
		{
			loadGraphic("assets/images/cloud_7.png", false, 50, 15);
		}

		if (cloudTypeNumber == 8)
		{
			loadGraphic("assets/images/cloud_8.png", false, 50, 17);
		}

		if (cloudTypeNumber == 9)
		{
			loadGraphic("assets/images/cloud_9.png", false, 29, 9);
		}

		if (cloudTypeNumber == 10)
		{
			loadGraphic("assets/images/cloud_10.png", false, 50, 23);
		}

		// this moves each cloud across the sky at a random speed
		FlxTween.tween(this, {x: 400}, FlxG.random.int(30, 60), {type: FlxTween.LOOPING});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
