package;

import scripts.HScript;
import scripts.LuaScript;
import flixel.FlxSubState;

using StringTools;

class ScriptedSubState extends FlxSubState
{
    public var luaArray:Array<LuaScript> = [];
	public var hscriptArray:Array<HScript> = [];

	public static var instance:ScriptedSubState = null;
    public var allowToLoadOtherFile:Bool = false;
    public var nameFile:String = "";

	public function new(name:String, allowToLoadOtherFile:Bool = false) {
		super();
		instance = this;
        this.allowToLoadOtherFile = allowToLoadOtherFile;
        nameFile = name;
	}

	override public function create()
	{
		super.create();

        var directory = Paths.file('data/states/');
        if (sys.FileSystem.exists(directory))
        {
            for (file in sys.FileSystem.readDirectory(directory))
            {
                if (file.endsWith(nameFile + '.lua'))
                {
                    var script = new LuaScript(directory + file);
                    luaArray.push(script);
                }
				for (ext in Paths.HSCRIPT_EXT)
				{
					if (file.endsWith(nameFile + ext))
					{
						var script = new HScript(directory + file, this);
						hscriptArray.push(script);
					}	
				}
            }
        }

        if (allowToLoadOtherFile)
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
						if (file.endsWith(nameFile + ext))
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