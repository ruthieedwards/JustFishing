package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

class FishMenu extends FlxSprite
{
	public var randNum100: Int;
	public var fishTypeNumber: Int;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);

		//sets the probability for each fish type, essentially tuna = 1% chance, squid = 4%, etc		
		randNum100 = FlxG.random.int(1, 100);
		if 		(randNum100 == 100)		 {fishTypeNumber = 8;}
		else if (randNum100 >= 96 && randNum100 <= 99) {fishTypeNumber = 7;}
		else if (randNum100 >= 91 && randNum100 <= 95) {fishTypeNumber = 6;}
		else if (randNum100 >= 81 && randNum100 <= 90) {fishTypeNumber = 5;}
		else if (randNum100 >= 61 && randNum100 <= 80) {fishTypeNumber = 4;}
		else if (randNum100 >= 36 && randNum100 <= 60) {fishTypeNumber = 3;}
		else if (randNum100 >= 31 && randNum100 <= 50) {fishTypeNumber = 2;}
		else {fishTypeNumber = 1;};

		this.flipX = true;
		this.scale.x = 2;
		this.scale.y = 2;

		// assigns image to each fish according to % chance above
		if (fishTypeNumber == 1)
		{
			// guppy
			loadGraphic("assets/images/fish_1.png", false, 18, 10);
		}

		if (fishTypeNumber == 2)
		{
			// black goldfish
			loadGraphic("assets/images/fish_2.png", false, 12, 12);
		}

		if (fishTypeNumber == 3)
		{
			// orange goldfish
			loadGraphic("assets/images/fish_3.png", false, 18, 16);
		}

		if (fishTypeNumber == 4)
		{
			// blue tang
			loadGraphic("assets/images/fish_4.png", false, 22, 11);
		}

		if (fishTypeNumber == 5)
		{
			// atlantic salmon
			loadGraphic("assets/images/fish_5.png", false, 26, 11);
		}

		if (fishTypeNumber == 6)
		{
			// rainbow trout
			loadGraphic("assets/images/fish_6.png", false, 26, 11);
		}

		if (fishTypeNumber == 7)
		{
			// squid
			loadGraphic("assets/images/fish_7.png", false, 31, 52);
		}

		if (fishTypeNumber == 8)
		{
			// tuna
			loadGraphic("assets/images/fish_8.png", false, 60, 28);
		}

		// moves fish from left to right across the screen at a random rate
		FlxTween.tween(this, {x: 380}, FlxG.random.int(20, 50), {type: FlxTween.LOOPING});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
