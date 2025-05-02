package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));
		trace("Quick Engine version: " + FlxG.stage.window.application.meta.get("version"));
	}
}
