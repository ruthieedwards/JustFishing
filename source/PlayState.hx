package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.motion.CubicMotion;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxStringUtil;

// Created by Ruthie Edwards
// Made for Ludum Dare 40, December 2017
// http://ruthieswebsite.com

class PlayState extends FlxState
{
	public var bobber:FlxSprite;
	public var fisher:FlxSprite;
	public var sploosh:FlxSprite;
	public var bobbingAnimation:FlxTween;
	public var ripple:FlxSprite;
	public var fishCaughtNumber:Int = 0;
	public var exclamation:FlxSprite;

	public var controlsDisabled:Bool = false;
	public var isCasting:Bool = false;
	public var isFishing:Bool = false;
	public var fishHasBitten:Bool = false;
	public var caughtFish:Bool = false;

	public var powerBarFill:FlxSprite;
	public var powerBarBack:FlxSprite;
	public var tweeningNumber:FlxTween;
	public var bobberLandingX:Float = 0;
	public var fishBiteTimer:FlxTimer;

	public static var allTheFish: FlxTypedGroup<Fish>;
	public static var allTheClouds: FlxTypedGroup<Cloud>;
	public static var allTheBirds: FlxTypedGroup<Bird>;

	public var cloudTimer:FlxTimer;
	public var birdTimer:FlxTimer;

	public static var fishDesc:FlxText;
	public static var newRecordText:FlxText;
	public static var fishRecordWeight:Float = 0;

	public static var buttonPressed:Bool = false;


	override public function create():Void
	{
		FlxG.mouse.visible = false;

		// fades up from black
		FlxG.camera.flash(0x00000000,.5);

		// adds background graphic
		var bg:FlxSprite = new FlxSprite(0,0);
		bg.loadGraphic("assets/images/bg.png",false,320,180);
		add (bg);

		// adds 9 clouds to the cloud group that animates L->R across the sky
		allTheClouds = new FlxTypedGroup<Cloud>();
		add (allTheClouds);
		cloudTimer = new FlxTimer().start(4, addACloud, 9);

		// adds 4 birds to the bird group, these fly in an arc across the sky
		allTheBirds = new FlxTypedGroup<Bird>();
		add (allTheBirds);
		birdTimer = new FlxTimer().start(10, addABird, 4);

		// adds the water "caustics" (simply a sprite animation) and animates it
		var waterMoving:FlxSprite = new FlxSprite(0,0);
		waterMoving.loadGraphic("assets/images/water_moving.png",true,320,180);
		waterMoving.animation.add("waterMovingAnim",[0,1,2,3,4,5], 6, true);
		waterMoving.animation.play("waterMovingAnim");
		waterMoving.alpha = .5;
		add (waterMoving);

		// add the island and dock on top of bg & waterMoving
		var island:FlxSprite = new FlxSprite(0,0);
		island.loadGraphic("assets/images/island.png",false,320,180);
		add (island);

		var dock:FlxSprite = new FlxSprite(0,0);
		dock.loadGraphic("assets/images/dock.png",false,320,180);
		add (dock);

		// ripple animation played when the bobber lands or bites
		ripple = new FlxSprite(-37,-20);
		ripple.loadGraphic("assets/images/ripple.png",true,37,20);
		ripple.animation.add("ripple",[0,1,2,3,4,5,6,7,8,9,10,11,12], 12, false);
		ripple.animation.add("ripple_loop",[0,1,2,3,4,5,6,7,8,9,10,11,12], 12, true);
		add(ripple);

		// splashing animation played when the bobber lands
		sploosh = new FlxSprite(-24,-24);
		sploosh.loadGraphic("assets/images/sploosh.png",true,24,24);
		sploosh.animation.add("sploosh",[1,2,3,4,5,6,7,0], 24, false);
		add(sploosh);

		bobber = new FlxSprite(-5,-5);
		bobber.loadGraphic("assets/images/bobber.png",false,5,5);
		add (bobber);

		// sets up animations for all the fisher's actions
		fisher = new FlxSprite(191,50);
		fisher.loadGraphic("assets/images/fisher.png",true,64,64);
		fisher.animation.add("cast_back",[2,3,4], 12, false);
		fisher.animation.add("cast_fwd",[5,5,6,7,8], 12, false);
		fisher.animation.add("hanging_on",[15,16], 6, true);
		fisher.animation.add("reel_in", [9,10,11,12,12,12,13,14], 12, false);
		add(fisher);

		// adds power bar and fill (invisible until fisher casts rod)
		powerBarBack = new FlxSprite(211, 69);
		powerBarBack.loadGraphic("assets/images/powerbar_back.png",false,30,6);
		add(powerBarBack);
		powerBarBack.visible = false;
		powerBarFill = new FlxSprite(239,70);
		powerBarFill.loadGraphic("assets/images/powerbar_fill.png",false,26,4);
		add (powerBarFill);
		powerBarFill.visible = false;
		powerBarFill.origin.set(0, 0);

		// adds exclamation box (invisible until fish bites)
		exclamation = new FlxSprite(213,58);
		exclamation.loadGraphic("assets/images/exclamation_box.png",false,19,19);
		exclamation.visible = false;
		add(exclamation);

		// group of all the fish in the game
		allTheFish = new FlxTypedGroup<Fish>();
		add (allTheFish);

		// dock's front poles added here because they need to be in front of everything else
		var polesFront:FlxSprite = new FlxSprite(0,0);
		polesFront.loadGraphic("assets/images/poles_front.png",false,320,180);
		add (polesFront);

		// sets up text box at top-right with conditional text based on platform
		fishDesc = new FlxText(0, 5, 315);
		fishDesc.setFormat("assets/fonts/BMdelico.ttf", 16, 0xFFdc8f53, "right");
		#if (flash)
		fishDesc.text = "Press space to cast/reel";
		#end
		#if (html5)
		fishDesc.text = "Tap to cast/reel";
		#end 
		add (fishDesc);

		// adds "New Record" text (invisible until a bigger fish is caught)
		newRecordText = new FlxText(-500, -500, 315);
		newRecordText.setFormat("assets/fonts/BMdelico.ttf", 32, 0xFFdc8f53, "right");
		newRecordText.text = "New Record";
		add(newRecordText);
		var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 2, .5, 2);
 		var waveSprite = new FlxEffectSprite(newRecordText, [waveEffect]);
 		add(waveSprite);
 		waveSprite.x = 0;
 		waveSprite.y = 26;
 		newRecordText.alpha = 0;

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		#if (flash)
		buttonPressed = FlxG.keys.justPressed.SPACE;
		#end

		#if (html5)
		buttonPressed = FlxG.mouse.justPressed;
		#end

		///////   WINDING UP    ///////
		if (buttonPressed == true && isCasting == false && isFishing == false && controlsDisabled == false)
		    { 	
		    	FlxG.sound.play("assets/sounds/windup.wav",.5);
		    	// controls briefly disabled so user can't interrupt animation
		    	controlsDisabled = true;
		    	new FlxTimer().start(.1, toggleControlsDisable, 1);

		    	fisher.animation.play("cast_back");
		    	bobber.visible = false;
		    	
		    	isCasting = true;
		    	// displays the power bar
		    	powerBarBack.visible = true;
		    	powerBarFill.visible = true;

		   		// pingpongs a number between 0 and 1 to determine throw distance and power bar's fill 	
				tweeningNumber = FlxTween.num(1, 0, .5, { ease: FlxEase.quadInOut, type: FlxTween.PINGPONG }, scaleFillBar.bind(powerBarFill) );
		    }

		//////    CASTING ROD    /////
		else if (buttonPressed == true && isCasting == true && isFishing == false && controlsDisabled == false && fishHasBitten == false)
		    { 	
		    	FlxG.sound.play("assets/sounds/cast.wav",.5);
		    	controlsDisabled = true;
		    	new FlxTimer().start(.8, toggleControlsDisable, 1);

		    	// turns off the power bar stuff
		    	powerBarBack.visible = false;
		    	powerBarFill.visible = false;
		    	tweeningNumber.cancel();
		    	
		    	fisher.animation.play("cast_fwd");
		    	bobber.visible = true;

		    	isFishing = true;
		    	isCasting = false;

		    	// animates the bobber along a quadratic arc depending on the "power" of the cast
		    	FlxTween.quadMotion(bobber, 248, 111, 199, 12, bobberLandingX, 140, .5, true, { ease: FlxEase.quadIn, type: FlxTween.ONESHOT, onComplete: fishingTime});
		   	}

		////////   REELING IN    &&    CAUGHT FISH    ////
		else if (buttonPressed == true && isCasting == false && isFishing == true && fishHasBitten == true && controlsDisabled == false)
		{
			FlxG.sound.play("assets/sounds/reel.wav",.5);

			isFishing = false;
			isCasting = false;

			controlsDisabled = true;
		    new FlxTimer().start(.7, toggleControlsDisable, 1);

		    // clears out some of the visuals
		    ripple.animation.stop();
		    ripple.animation.frameIndex = 12;
		    bobbingAnimation.cancel();
			exclamation.visible = false;

		    fishBiteTimer.cancel();

			fisher.animation.play("reel_in");

			// places a fish on the bobber
			allTheFish.add(new Fish(bobber.x,bobber.y));

			// animates the bobber along an arc back to the rod
			FlxTween.quadMotion(bobber, bobber.x, bobber.y, 199, 12, 198, 79, .5, true, { type: FlxTween.ONESHOT });

			// animates the fish along an arc to a semi-random place on the dock, incrementing Y+1.5 every time to make them "stack"
			FlxTween.quadMotion(allTheFish.members[fishCaughtNumber], allTheFish.members[fishCaughtNumber].x, allTheFish.members[fishCaughtNumber].y, 
				200, -20, 291 - allTheFish.members[fishCaughtNumber].width/2 + FlxG.random.int(-20, 15), 111 - allTheFish.members[fishCaughtNumber].height/2 - fishCaughtNumber*1.5, 
				.5, true, { ease:FlxEase.quadIn, type: FlxTween.ONESHOT, startDelay: .1, onComplete: fishCaughtNotification});
		}    

		//////// REELING IN     -    NO FISH CAUGHT ///////
		else if (buttonPressed == true && isCasting == false && isFishing == true && fishHasBitten == false && controlsDisabled == false)
		{
			FlxG.sound.play("assets/sounds/reel.wav",.5);

			controlsDisabled = true;
		    new FlxTimer().start(.7, toggleControlsDisable, 1);

			bobbingAnimation.cancel();
			exclamation.visible = false;

		    fishBiteTimer.cancel();

			fisher.animation.play("reel_in");

			// animates the bobber along an arc back to the rod
			FlxTween.quadMotion(bobber, bobber.x, bobber.y, 199, 12, 198, 79, .5, true, { type: FlxTween.ONESHOT });

			isFishing = false;
		}  

		super.update(elapsed);
	}

	public function toggleControlsDisable(Timer:FlxTimer)
	{
		controlsDisabled = false;
	}

	public function fishCaughtNotification(Tween:FlxTween)
	{
		FlxG.sound.play("assets/sounds/plop2.wav",.75);

		isFishing = false;
		fishHasBitten = false;

		fishDesc.alpha = 1;

		bobbingAnimation.cancel();

		// this adds a little bounce to the landing, I think... 
		FlxTween.tween(allTheFish.members[fishCaughtNumber], {y: allTheFish.members[fishCaughtNumber].y - 3}, .25, {ease: FlxEase.bounceOut, type: FlxTween.PINGPONG, loopDelay: 500});		
	
		// compares current fish's weight to previous to see if it's a new record
		if (allTheFish.members[fishCaughtNumber].fishWeight > fishRecordWeight)
		{
			newRecordText.alpha = 1;
			fishRecordWeight = allTheFish.members[fishCaughtNumber].fishWeight;
		}

		// updates name and weight (formatting the weight number like money (X.XX) was the easiest way to convert the float!
		fishDesc.text = allTheFish.members[fishCaughtNumber].fishName + " - " + FlxStringUtil.formatMoney(allTheFish.members[fishCaughtNumber].fishWeight, true, true) + "kg" ;
		fishCaughtNumber += 1;

		// fades text out
		FlxTween.tween(fishDesc, {alpha: 0}, 1, {type: FlxTween.ONESHOT, startDelay: 3});
		FlxTween.tween(newRecordText, {alpha: 0}, 1, {type: FlxTween.ONESHOT, startDelay: 3});
	}

	public function fishingTime(Tween:FlxTween)
	{
		FlxG.sound.play("assets/sounds/plop.wav",.5);

		// adds sploosh + ripple animations to wherever the bobber lands
		sploosh.x = bobber.x-10;
		sploosh.y = bobber.y-10;
		sploosh.animation.play("sploosh");
		ripple.x = bobber.x-17;
		ripple.y = bobber.y-5;
		ripple.animation.play("ripple");

		new FlxTimer().start(.1).onComplete = function(t:FlxTimer):Void
			{
				// randomly bobs the bobber up and down slightly
				bobbingAnimation = FlxTween.tween(bobber, {y: bobber.y+3}, .5, {ease:FlxEase.quadInOut, type: FlxTween.PINGPONG, loopDelay: FlxG.random.int(1, 6)*.5 });
			}

		// this is the main game mechanic!! for every fish caught, the time between fish biting is longer
		fishBiteTimer = new FlxTimer().start(2+fishCaughtNumber*.8, fishBiting, 1);
	}


	private function fishBiting(Timer:FlxTimer)
	{
		FlxG.sound.play("assets/sounds/wiggle.wav",.5);
		bobbingAnimation.cancel();
		exclamation.visible = true;
		fisher.animation.play("hanging_on");
		fishHasBitten = true;
		bobbingAnimation = FlxTween.tween(bobber, {y: bobber.y+3}, .25, {ease:FlxEase.bounceInOut, type: FlxTween.PINGPONG });
		ripple.animation.play("ripple_loop");
	}

	private function scaleFillBar(s:FlxSprite, v:Float) 
	{
		// determines the "power" of a cast and applies it to the bobber's X position
		// power is purely cosmetic
		powerBarFill.scale.set(-v, 1);
		bobberLandingX = 158*v + 12;
	}

	private function addACloud(Timer:FlxTimer)
	{
		allTheClouds.add(new Cloud(-60, FlxG.random.int(4, 42)));
	}

	private function addABird(Timer:FlxTimer)
	{
		allTheBirds.add(new Bird(-60, -60));
	}

}