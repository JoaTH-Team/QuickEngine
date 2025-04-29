package scripts;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import llua.*;
import llua.Lua.Lua_helper;

class LuaScript
{
	public var Function_Stop = 1;
	public var Function_Continue = 0;

    public var lua:State = null;

    public function new(script:String) {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);
        trace("Load Script: " + script);

        var result:Dynamic = LuaL.dofile(lua, script);
        var resultString:String = Lua.tostring(lua, result);

        checkError(resultString, result);
        implete();
    }

    public var spriteMap:Map<String, FlxSprite> = new Map<String, FlxSprite>();
    public var textMap:Map<String, FlxText> = new Map<String, FlxText>();

    function implete() {
        addcallback("createObject", function (type:String, name:String, config:Dynamic) {
            switch (type) {
                case "sprite":
                    var sprite:FlxSprite = new FlxSprite(config.x, config.y);
                    sprite.loadGraphic(Paths.image(config.image));
                    sprite.active = true;
                    spriteMap.set(name, sprite);
                case "text":
                    var text:FlxText = new FlxText(config.x, config.y, config.width, config.text, config.size);
                    text.active = true;
                    textMap.set(name, text);
            }
        });
        addcallback("addObject", function (name:String) {
            if (spriteMap.exists(name)) {
                FlxG.state.add(spriteMap.get(name));
            } else if (textMap.exists(name)) {
                FlxG.state.add(textMap.get(name));
            }
        });
    }

    function checkError(string:String, int:Int) {
        if (string != null && int != 0) 
        {
            FlxG.stage.window.alert(string, "Lua Error!");
            lua = null;
            return;
        }
    }

    public function addcallback(fname:String, f:Dynamic)
    {
        Lua_helper.add_callback(lua, fname, f);
    }
    
    public function addVar(vari:String, dt:Dynamic)
    {
        Convert.toLua(lua, dt);
        Lua.setglobal(lua, vari);
    }
    
    public function call(event:String, args:Array<Dynamic>):Dynamic {
        if(lua == null) {
            return Function_Continue;
        }

        Lua.getglobal(lua, event);

        for (arg in args) {
            Convert.toLua(lua, arg);
        }

        var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
        if(result != null && resultIsAllowed(lua, result)) {
            if(Lua.type(lua, -1) == Lua.LUA_TSTRING) {
                var error:String = Lua.tostring(lua, -1);
                if(error == 'attempt to call a nil value') {
                    return Function_Continue;
                }
            }
            var conv:Dynamic = Convert.fromLua(lua, result);
            //Lua.pop(lua, 1);
            return conv;
        }
        return Function_Continue;
    }
    
    public function resultIsAllowed(leLua:State, leResult:Null<Int>) { //Makes it ignore warnings
        switch(Lua.type(leLua, leResult)) {
            case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
                return true;
        }
        return false;
    }
}