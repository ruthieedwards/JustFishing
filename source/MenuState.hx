 package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

// Created by Ruthie Edwards
// Made for Ludum Dare 40, December 2017
// http://ruthieswebsite.com

class MenuState extends FlxState
{

	public var bg:FlxSprite;
	public var bg2:FlxSprite;

	public var fishTimer:FlxTimer;

	public static var schoolOfFish: FlxTypedGroup<FishMenu>;

	override public function create():Void
	{
		super.create();

		FlxG.mouse.visible = false;

		if (FlxG.sound.music == null) // don't restart the music if it's already playing
			 {
			     FlxG.sound.playMusic("assets/music/fishin-up-something-good.mp3", .7, true);
			 }

		// adds two backgrounds and apply a wave effect over each
		var bg:FlxSprite = new FlxSprite(0,0);
		bg.loadGraphic("assets/images/ocean_bg.png",false,320,180);
		add (bg);

		// this wave effect isn't optimized in HTML5, so it's disabled
		#if !html5
		var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 5, .5, 5, 5, HORIZONTAL);
 		var waveSprite = new FlxEffectSprite(bg, [waveEffect]);
 		add(waveSprite);
 		#end

 		var bg2:FlxSprite = new FlxSprite(0,0);
		bg2.loadGraphic("assets/images/ocean_bg.png",false,320,180);
		add (bg2);
		bg2.alpha = .5;

		#if !html5
		var waveEffect2 = new FlxWaveEffect(FlxWaveMode.ALL, 6, .5, 6, 6, HORIZONTAL);
 		var waveSprite2 = new FlxEffectSprite(bg2, [waveEffect2]);
 		add(waveSprite2);
 		#end

 		// adds 20 fish to the screen one second apart, plus two extra fish to start
 		schoolOfFish = new FlxTypedGroup<FishMenu>();
		add (schoolOfFish);
		fishTimer = new FlxTimer().start(1, addAFish, 20);
		schoolOfFish.add(new FishMenu(-60, FlxG.random.int(0,175)));
		schoolOfFish.add(new FishMenu(-60, FlxG.random.int(0,175)));


		// adds logo and gently animates it up and down
		var logo:FlxSprite = new FlxSprite(85,62);
		logo.loadGraphic("assets/images/logo.png",false,152,54);
		add (logo);
		FlxTween.tween(logo, { x:85, y:67 }, 2, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});

		// adds "press space" or "tap to start" graphic depending on platform
		var pressSpace:FlxSprite = new FlxSprite(85,131);
		#if (flash)
		pressSpace.loadGraphic("assets/images/press-space.png",false,150,22);
		#end
		#if (html5)
		pressSpace.loadGraphic("assets/images/tap-to-start.png",false,150,22);
		#end
		add (pressSpace);
		FlxTween.tween(pressSpace,{alpha:0},1,{type:FlxTween.PINGPONG, ease:FlxEase.sineInOut, loopDelay:1});
 		
	}

	private function playGame():Void
	{
		// fades to black
		FlxG.camera.fade(0x00000000,.5);

		// when the transition is done, switches to PlayState
		new FlxTimer().start(.5).onComplete = function(t:FlxTimer):Void
		{
			FlxG.switchState(new PlayState());
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if (flash)
		if (FlxG.keys.justPressed.SPACE)
		{
			playGame();
		}
		#end

		#if (html5)
		if (FlxG.mouse.justPressed)
		{
			playGame();
		}
		#end
	}

	private function addAFish(Timer:FlxTimer)
	{
		// adds one fish slightly off left side of screen with a random Y placement
		schoolOfFish.add(new FishMenu(-60, FlxG.random.int(0,175)));
	}

}