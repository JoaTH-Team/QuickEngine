package scripts;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import llua.*;
import llua.Lua.Lua_helper;
import scripts.api.*;

class LuaScript {
    public var Function_Stop = 1;
    public var Function_Continue = 0;

    public var lua:State = null;
    
    // API modules
    private var objectApi:LuaObjectAPI;
    private var spriteApi:LuaSpriteAPI;
    private var textApi:LuaTextAPI;
    private var propertyApi:LuaPropertyAPI;
    private var eventApi:LuaEventAPI;
    private var cameraApi:LuaCameraAPI;
	private var defaultApi:LuaDefaultAPI;

    // Maps moved to LuaObjectAPI
    @:allow(scripts.api)
    private var spriteMap:Map<String, FlxSprite> = new Map<String, FlxSprite>();
    @:allow(scripts.api)
    private var textMap:Map<String, FlxText> = new Map<String, FlxText>();
    @:allow(scripts.api)
    private var objectMap:Map<String, FlxObject> = new Map<String, FlxObject>();
    @:allow(scripts.api)
    private var cameraMap:Map<String, FlxCamera> = new Map<String, FlxCamera>();

    public function new(script:String) {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        Lua.init_callbacks(lua);
        trace("Load Script: " + script + ' - From state: ' + Type.getClassName(Type.getClass(FlxG.state)));

        // Initialize API modules
        objectApi = new LuaObjectAPI(this);
        spriteApi = new LuaSpriteAPI(this);
        textApi = new LuaTextAPI(this);
        propertyApi = new LuaPropertyAPI(this);
        eventApi = new LuaEventAPI(this);
        cameraApi = new LuaCameraAPI(this);
		defaultApi = new LuaDefaultAPI(this);

        var result:Dynamic = LuaL.dofile(lua, script);
        var resultString:String = Lua.tostring(lua, result);

        checkError(resultString, result);
        initializeCallbacks();
    }

    function initializeCallbacks() {
        // Initialize all API callbacks
        objectApi.initialize();
        spriteApi.initialize();
        textApi.initialize();
        propertyApi.initialize();
        eventApi.initialize();
        cameraApi.initialize();
		defaultApi.initialize();
    }

    function checkError(string:String, int:Int) {
        if (string != null && int != 0) {
            FlxG.stage.window.alert(string, "Lua Error!");
            lua = null;
            return;
        }
    }

    public function addcallback(fname:String, f:Dynamic) {
        Lua_helper.add_callback(lua, fname, f);
    }
    
    public function addVar(vari:String, dt:Dynamic) {
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
            return conv;
        }
        return Function_Continue;
    }
    
    public function resultIsAllowed(leLua:State, leResult:Null<Int>) {
        switch(Lua.type(leLua, leResult)) {
            case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
                return true;
        }
        return false;
    }
}