package scripts.api;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import scripts.LuaScript;

using StringTools;

class LuaEventAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addcallback("getInputPress", getInputPress);
        script.addcallback("getInputPressMulti", getInputPressMulti);

        script.addcallback("switchState", switchState);
        script.addcallback("returnToDefaultState", returnToDefaultState);
    }

    private function getInputPress(type:String, keyName:String) {
        switch (type) {
            case "justPressed":
                return FlxG.keys.anyJustPressed([EngineUtil.getKeyName(keyName)]);
            case "justReleased":
                return FlxG.keys.anyJustReleased([EngineUtil.getKeyName(keyName)]);
            case "pressed":
                return FlxG.keys.anyPressed([EngineUtil.getKeyName(keyName)]);
            default:
                return false;
        }
    }

    private function getInputPressMulti(type:String, keyName:Dynamic):Bool {
        var keys:Array<FlxKey> = new Array<FlxKey>();
        if (Std.isOfType(keyName, Array)) {
            for (key in (keyName : Array<Dynamic>)) {
                keys.push(cast EngineUtil.getKeyName(key));
            }
            switch (type) {
                case "justPressed":
                    return FlxG.keys.anyJustPressed(keys);
                case "justReleased":
                    return FlxG.keys.anyJustReleased(keys);
                case "pressed":
                    return FlxG.keys.anyPressed(keys);
                default:
                    return false;
            }
        }
        return false;
    }

    private function switchState(name:String, allowLoadOtherFile:Bool = true) {
        try {
        	var directory = Paths.file('data/states/');
        	if (sys.FileSystem.exists(directory))
        	{
        		for (file in sys.FileSystem.readDirectory(directory))
        		{
        			if (file.endsWith(name + '.lua'))
        			{
        				FlxG.switchState(() -> new ScriptedState(name, allowLoadOtherFile));
        			}
        		}
        	}
        }
        catch (e:haxe.Exception)
        {
        	trace(e.details());
        }
    }

    private function returnToDefaultState() {
        return FlxG.switchState(() -> new PlayState());
    }
}