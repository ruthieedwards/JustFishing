package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;

class Fish extends FlxSprite
{
	public var randNum100: Int;
	public var fishTypeNumber: Int;
	public var fishName: String;
	public var fishWeight: Float;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);

		//sets the probability for each fish type, essentially tuna = 1% chance, squid = 4%, etc		
		randNum100 = FlxG.random.int(1, 100);
		if 		(randNum100 == 100)					   {fishTypeNumber = 8;}
		else if (randNum100 >= 96 && randNum100 <= 99) {fishTypeNumber = 7;}
		else if (randNum100 >= 91 && randNum100 <= 95) {fishTypeNumber = 6;}
		else if (randNum100 >= 81 && randNum100 <= 90) {fishTypeNumber = 5;}
		else if (randNum100 >= 61 && randNum100 <= 80) {fishTypeNumber = 4;}
		else if (randNum100 >= 36 && randNum100 <= 60) {fishTypeNumber = 3;}
		else if (randNum100 >= 31 && randNum100 <= 50) {fishTypeNumber = 2;}
		else if (randNum100 >= 22 && randNum100 <= 30) {fishTypeNumber = 0;}
		else {fishTypeNumber = 1;};

		//each of these assigns a name, graphic, and weight to the fish that's randomly fished up
		if (fishTypeNumber == 0)
		{
			fishName = "Hermit Crab";
			loadGraphic("assets/images/fish_0.png", false, 20, 17);
			fishWeight = FlxG.random.float(0,.5);
		}

		if (fishTypeNumber == 1)
		{
			fishName = "Guppy";
			loadGraphic("assets/images/fish_1.png", false, 18, 10);
			fishWeight = FlxG.random.float(0,1);
		}

		if (fishTypeNumber == 2)
		{
			fishName = "Goldfish";
			loadGraphic("assets/images/fish_2.png", false, 12, 12);
			fishWeight = FlxG.random.float(0,1);
		}

		if (fishTypeNumber == 3)
		{
			fishName = "Goldfish";
			loadGraphic("assets/images/fish_3.png", false, 18, 16);
			fishWeight = FlxG.random.float(.2,2);
		}

		if (fishTypeNumber == 4)
		{
			fishName = "Blue Tang";
			loadGraphic("assets/images/fish_4.png", false, 22, 11);
			fishWeight = FlxG.random.float(0,1);
		}

		if (fishTypeNumber == 5)
		{
			fishName = "Atlantic Salmon";
			loadGraphic("assets/images/fish_5.png", false, 26, 11);
			fishWeight = FlxG.random.float(3,6);
		}

		if (fishTypeNumber == 6)
		{
			fishName = "Rainbow Trout";
			loadGraphic("assets/images/fish_6.png", false, 26, 11);
			fishWeight = FlxG.random.float(1,9);
		}

		if (fishTypeNumber == 7)
		{
			fishName = "Squid";
			loadGraphic("assets/images/fish_7.png", false, 31, 52);
			fishWeight = FlxG.random.float(2,100);
		}

		if (fishTypeNumber == 8)
		{
			fishName = "Tuna";
			loadGraphic("assets/images/fish_8.png", false, 60, 28);
			fishWeight = FlxG.random.float(4,500);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
