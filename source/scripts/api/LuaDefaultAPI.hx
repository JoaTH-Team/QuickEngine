package scripts.api;

import flixel.FlxG;

class LuaDefaultAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addVar("engineVersion", FlxG.stage.window.application.meta.get("version"));
        script.addcallback("print", print);
    }

    private function print(value:Dynamic)
	{
		if (value != null)
		{
			trace(Std.string(value));
		}
		else
		{
			trace("null");
		}
    }
}