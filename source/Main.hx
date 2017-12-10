package;

import flixel.FlxGame;
import openfl.display.Sprite;

// Created by Ruthie Edwards
// Made for Ludum Dare 40, December 2017
// http://ruthieswebsite.com

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 180, MenuState, 4, 60, 60, true));
	}
}
