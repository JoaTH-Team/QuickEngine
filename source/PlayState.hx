package;

import scripts.HScript;
import flixel.FlxState;
import scripts.LuaScript;

using StringTools;

class PlayState extends FlxState
{
	public var luaArray:Array<LuaScript> = [];
	public var hscriptArray:Array<HScript> = [];
	
	public static var instance:PlayState = null;

	public function new() {
		super();
		instance = this;
	}

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
					for (ext in Paths.HSCRIPT_EXT)
					{
						if (file.endsWith(ext))
						{
							var script = new HScript(directory + file, this);
							hscriptArray.push(script);
						}	
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
		for (i in 0...hscriptArray.length)
		{
			final script:HScript = hscriptArray[i];
			script.call(funcName, funcArgs);
		}
	}
}
