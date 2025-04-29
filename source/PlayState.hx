package;

import flixel.FlxState;
import scripts.LuaScript;

using StringTools;

class PlayState extends FlxState
{
	var luaArray:Array<LuaScript> = [];

	override public function create()
	{
		super.create();
		createExtract();

		callOnScripts("create", []);
	}

	function createExtract():Void
	{
		// Load the Lua script
		try
		{
			var directory = Paths.file('data/');
			if (sys.FileSystem.exists(directory))
			{
				for (file in sys.FileSystem.readDirectory(directory))
				{
					if (file.endsWith('.lua'))
					{
						var script = new LuaScript(directory + file);
						luaArray.push(script);
					}
				}
			}
		}
		catch (e:haxe.Exception)
		{
			trace(e.details());
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		callOnScripts("update", [elapsed]);
	}

	override public function destroy()
	{
		super.destroy();

		callOnScripts("destroy", []);
	}

	override function draw()
	{
		super.draw();

		callOnScripts("draw", []);
	}

	function callOnScripts(funcName:String, funcArgs:Array<Dynamic>)
	{
		for (i in 0...luaArray.length)
		{
			final script:LuaScript = luaArray[i];
			script.call(funcName, funcArgs);
		}
	}
}
