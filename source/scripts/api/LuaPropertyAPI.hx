package scripts.api;

import PlayState;
import ScriptedState;
import flixel.FlxG;
import scripts.LuaScript;

using StringTools;

class LuaPropertyAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
		script.addVar("setTitle", setTitle);
		script.addVar("setWindowSize", setWindowSize);

        script.addcallback("setProperty", setProperty);
		script.addcallback("setClassProperty", setClassProperty);

        script.addcallback("getProperty", getProperty);
		script.addcallback("getClassProperty", getClassProperty);

        script.addcallback("setPosition", setPosition);
        script.addcallback("setScale", setScale);
		script.addcallback("addFolder", addFolder);
	}

	private function setWindowSize(width:Int, height:Int)
	{
		if (width > 0 && height > 0)
		{
			FlxG.stage.window.width = width;
			FlxG.stage.window.height = height;
		}
		else
		{
			FlxG.stage.window.width = 800;
			FlxG.stage.window.height = 600;
		}
	}

	private function setTitle(name:String)
	{
		if (name != null)
		{
			FlxG.stage.window.title = name;
		}
		else // prevent null
		{
			FlxG.stage.window.title = "Quick Engine";
		}
	}

    private function setScale(name:String, x:Float, y:Float) {
        if (script.spriteMap.exists(name)) {
            var sprite = script.spriteMap.get(name);
            sprite.scale.set(x, y);
        } else if (script.textMap.exists(name)) {
            var text = script.textMap.get(name);
            text.scale.set(x, y);
        }
    }

    private function setPosition(name:String, x:Float, y:Float) {
        if (script.spriteMap.exists(name)) {
            var sprite = script.spriteMap.get(name);
            sprite.setPosition(x, y);
        } else if (script.textMap.exists(name)) {
            var text = script.textMap.get(name);
            text.setPosition(x, y);
        } else if (script.objectMap.exists(name)) {
            var object = script.objectMap.get(name);
            object.setPosition(x, y);
        } else if (script.cameraMap.exists(name)) {
            var camera = script.cameraMap.get(name);
            camera.setPosition(x, y);
        }
    }

    private function setNestedProperty(obj:Dynamic, propertyPath:String, value:Dynamic) {
        var props = propertyPath.split(".");
        var current = obj;
        
        for (i in 0...props.length - 1) {
            current = Reflect.getProperty(current, props[i]);
            if (current == null) return;
        }
        
        Reflect.setProperty(current, props[props.length - 1], value);
    }

    private function getNestedProperty(obj:Dynamic, propertyPath:String):Dynamic {
        var props = propertyPath.split(".");
        var current = obj;
        
        for (prop in props) {
            if (current == null) return null;
            current = Reflect.getProperty(current, prop);
        }
        
        return current;
    }

    private function setProperty(name:String, property:String, value:Dynamic) {
        if (script.spriteMap.exists(name)) {
            var sprite = script.spriteMap.get(name);
            setNestedProperty(sprite, property, value);
        } else if (script.textMap.exists(name)) {
            var text = script.textMap.get(name);
            setNestedProperty(text, property, value);
        } else if (script.objectMap.exists(name)) {
            var object = script.objectMap.get(name);
            setNestedProperty(object, property, value);
        } else if (script.cameraMap.exists(name)) {
            var camera = script.cameraMap.get(name);
            setNestedProperty(camera, property, value);
        } else {
            var instance = PlayState.instance;
            if (instance != null) {
                setNestedProperty(instance, property, value);
            }
        }
    }

    private function getProperty(name:String, property:String) {
        if (script.spriteMap.exists(name)) {
            var sprite = script.spriteMap.get(name);
            return getNestedProperty(sprite, property);
        } else if (script.textMap.exists(name)) {
            var text = script.textMap.get(name);
            return getNestedProperty(text, property);
        } else if (script.objectMap.exists(name)) {
            var object = script.objectMap.get(name);
            return getNestedProperty(object, property);
        } else if (script.cameraMap.exists(name)) {
            var camera = script.cameraMap.get(name);
            return getNestedProperty(camera, property);
        } else {
            var instance = PlayState.instance;
            if (instance != null) {
                return getNestedProperty(instance, property);
            }
        }
        return null;
    }
	private function getClassProperty(className:String, property:String)
	{
		var classRef = Type.resolveClass(className);
		if (classRef != null)
		{
			return getNestedProperty(classRef, property);
		}
		return null;
	}

	private function setClassProperty(className:String, property:String, value:Dynamic)
	{
		var classRef = Type.resolveClass(className);
		if (classRef != null)
		{
			setNestedProperty(classRef, property, value);
		}
	}

	private function addFolder(folderName:String)
	{
		try
		{
			var directory = Paths.file('data/$folderName/');
			if (sys.FileSystem.exists(directory))
			{
				for (file in sys.FileSystem.readDirectory(directory))
				{
					if (file.endsWith('.lua'))
					{
						var script = new LuaScript(directory + file);
						if (PlayState.instance != null)
							PlayState.instance.luaArray.push(script);
						else if (ScriptedState.instance != null)
							ScriptedState.instance.luaArray.push(script);
					}
				}
			}
		}
		catch (e:haxe.Exception)
		{
			trace(e.details());
		}
	}
}