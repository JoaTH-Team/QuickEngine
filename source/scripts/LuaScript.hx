package scripts;

import PlayState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
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
    public var objectMap:Map<String, FlxObject> = new Map<String, FlxObject>();
    public var cameraMap:Map<String, FlxCamera> = new Map<String, FlxCamera>();
    
    function implete() {
        addcallback("createObject", function (type:String, name:String, config:Dynamic) {
            switch (type) {
                case "sprite":
                    var sprite:FlxSprite = new FlxSprite(config.x, config.y);
                    setCodeWithCheckNull(config.image, image -> sprite.loadGraphic(Paths.image(image)));
                    sprite.active = true;
                    spriteMap.set(name, sprite);
                case "text":
                    var text:FlxText = new FlxText(config.x, config.y, config.width, config.text, config.size);
                    text.active = true;
                    textMap.set(name, text);
                default:
                    var object:FlxObject = new FlxObject(config.x, config.y, config.width, config.height);
                    object.active = true;
                    objectMap.set(name, object);
            }
        });
        addcallback("addObject", function (name:String) {
            if (spriteMap.exists(name)) {
                FlxG.state.add(spriteMap.get(name));
            } else if (textMap.exists(name)) {
                FlxG.state.add(textMap.get(name));
            } else {
                FlxG.state.add(objectMap.get(name));
            }
        });
        addcallback("removeObject", function (name:String) {
            if (spriteMap.exists(name)) {
                FlxG.state.remove(spriteMap.get(name));
            } else if (textMap.exists(name)) {
                FlxG.state.remove(textMap.get(name));
            } else {
                FlxG.state.remove(objectMap.get(name));
            }
        });
        addcallback("insertObject", function (name:String, pos:Int = 0) {
            if (spriteMap.exists(name)) {
                FlxG.state.insert(pos, spriteMap.get(name));
            } else if (textMap.exists(name)) {
                FlxG.state.insert(pos, textMap.get(name));
            } else {
                FlxG.state.insert(pos, objectMap.get(name));
            }
        });
        
        addcallback("configText", function (name:String, config:Dynamic) {
            if (textMap.exists(name)) {
                var text:FlxText = textMap.get(name);
                setCodeWithCheckNull(config.x, x -> text.x = x);
                setCodeWithCheckNull(config.y, y -> text.y = y);
                setCodeWithCheckNull(config.width, width -> text.width = width);
                setCodeWithCheckNull(config.text, txt -> text.text = txt);
                setCodeWithCheckNull(config.size, size -> text.size = size);
                setCodeWithCheckNull(config.color, color -> text.color = EngineUtil.getColorName(color));
                setCodeWithCheckNull(config.alignment, align -> text.alignment = EngineUtil.getAlignmentName(align));
                setCodeWithCheckNull(config.alpha, alpha -> text.alpha = alpha);
                setCodeWithCheckNull(config.scale, scale -> text.scale.set(scale.x, scale.y));
                setCodeWithCheckNull(config.angle, angle -> text.angle = angle);
                setCodeWithCheckNull(config.visible, visible -> text.visible = visible);
                setCodeWithCheckNull(config.active, active -> text.active = active);
                setCodeWithCheckNull(config.scrollFactor, scrollFactor -> text.scrollFactor.set(scrollFactor.x, scrollFactor.y));
                setCodeWithCheckNull(config.antialiasing, antialiasing -> text.antialiasing = antialiasing);
                setCodeWithCheckNull(config.font, font -> text.font = Paths.font(font));
                setCodeWithCheckNull(config.borderSize, borderSize -> text.borderSize = borderSize);
                setCodeWithCheckNull(config.borderColor, borderColor -> text.borderColor = EngineUtil.getColorName(borderColor));
                setCodeWithCheckNull(config.borderStyle, borderStyle -> text.borderStyle = EngineUtil.getBorderStyleName(borderStyle));
                setCodeWithCheckNull(config.borderQuality, borderQuality -> text.borderQuality = borderQuality);
            }
        });

        addcallback("configSprite", function (name:String, config:Dynamic) {
            if (spriteMap.exists(name)) {
                var sprite:FlxSprite = spriteMap.get(name);
                setCodeWithCheckNull(config.image, img -> sprite.loadGraphic(Paths.image(img)));
                setCodeWithCheckNull(config.x, x -> sprite.x = x);
                setCodeWithCheckNull(config.y, y -> sprite.y = y);
                setCodeWithCheckNull(config.width, width -> sprite.width = width);
                setCodeWithCheckNull(config.height, height -> sprite.height = height);
                setCodeWithCheckNull(config.alpha, alpha -> sprite.alpha = alpha);
                setCodeWithCheckNull(config.scale, scale -> sprite.scale.set(scale.x, scale.y));
                setCodeWithCheckNull(config.angle, angle -> sprite.angle = angle);
                setCodeWithCheckNull(config.visible, visible -> sprite.visible = visible);
                setCodeWithCheckNull(config.active, active -> sprite.active = active);
                setCodeWithCheckNull(config.scrollFactor, scrollFactor -> sprite.scrollFactor.set(scrollFactor.x, scrollFactor.y));
            }
        });
        
        addcallback("getSpriteSheet", function (name:String, image:String) {
            if (spriteMap.exists(name)) {
                var sprite:FlxSprite = spriteMap.get(name);
                return sprite.frames = Paths.getSparrowAtlas(image);
            }
            return null;
        });

        addcallback("setAnimation", function (name:String, config:Dynamic) {
            if (spriteMap.exists(name)) {
                var sprite:FlxSprite = spriteMap.get(name);
                switch (config.type) {
                    case "prefix":
                        return sprite.animation.addByPrefix(config.name, config.prefix, config.frameRate, config.loop, config.flipX, config.flipY);
                    case "indices":
                        return sprite.animation.addByIndices(config.name, config.prefix, config.indices, config.postfix, config.frameRate, config.loop, config.flipX, config.flipY);
                }
            }
        });

        addcallback("playAnimation", function (name:String, animation:String, force:Bool = false) {
            if (spriteMap.exists(name)) {
                var sprite:FlxSprite = spriteMap.get(name);
                sprite.animation.play(animation, force);
                return true;
            }
            return false;
        });

        addcallback("configObject", function (name:String, config:Dynamic) {
            if (objectMap.exists(name)) {
                var object:FlxObject = objectMap.get(name);
                setCodeWithCheckNull(config.x, x -> object.x = x);
                setCodeWithCheckNull(config.y, y -> object.y = y);
                setCodeWithCheckNull(config.width, width -> object.width = width);
                setCodeWithCheckNull(config.height, height -> object.height = height);
                setCodeWithCheckNull(config.angle, angle -> object.angle = angle);
                setCodeWithCheckNull(config.visible, visible -> object.visible = visible);
                setCodeWithCheckNull(config.active, active -> object.active = active);
                setCodeWithCheckNull(config.scrollFactor, scrollFactor -> object.scrollFactor.set(scrollFactor.x, scrollFactor.y));
            }
        });

        // Main
        addcallback("setProperty", function (name:String, property:String, value:Dynamic) {
            if (spriteMap.exists(name)) {
                var sprite = spriteMap.get(name);
                Reflect.setProperty(sprite, property, value);
            } else if (textMap.exists(name)) {
                var text = textMap.get(name);
                Reflect.setProperty(text, property, value);
            } else if (objectMap.exists(name)) {
                var object = objectMap.get(name);
                Reflect.setProperty(object, property, value);
            } else {
                var instance = PlayState.instance;
                if (instance != null) {
                    var game = instance;
                    Reflect.setProperty(game, property, value);
                }
            }
        });
        addcallback("getProperty", function (name:String, property:String) {
            if (spriteMap.exists(name)) {
                var sprite = spriteMap.get(name);
                return Reflect.getProperty(sprite, property);
            } else if (textMap.exists(name)) {
                var text = textMap.get(name);
                return Reflect.getProperty(text, property);
            } else if (objectMap.exists(name)) {
                var object = objectMap.get(name);
                return Reflect.getProperty(object, property);
            } else {
                var instance = PlayState.instance;
                if (instance != null) {
                    var game = instance;
                    return Reflect.getProperty(game, property);
                }
            }
            return null;
        });

        addcallback("getInputPress", function (type:String, keyName:String) {
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
        });
    }

    function setCodeWithCheckNull<T>(value:Null<T>, setter:T->Void) {
        if (value != null) {
            setter(value);
        }
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