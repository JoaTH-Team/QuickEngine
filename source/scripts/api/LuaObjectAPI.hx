package scripts.api;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import scripts.LuaScript;

class LuaObjectAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addcallback("createObject", createObject);

        script.addcallback("addObject", addObject);
        script.addcallback("removeObject", removeObject);
        script.addcallback("insertObject", insertObject);
    }

    private function createObject(type:String, name:String, config:Dynamic) {
        switch (type) {
            case "sprite":
                var sprite:FlxSprite = new FlxSprite();
                if (config.x != null) sprite.x = config.x;
                if (config.y != null) sprite.y = config.y;
                if (config.image != null) sprite.loadGraphic(Paths.image(config.image));
                sprite.active = true;
                script.spriteMap.set(name, sprite);
            case "text":
                var text:FlxText = new FlxText();
                if (config.x != null) text.x = config.x;
                if (config.y != null) text.y = config.y;
                if (config.width != null) text.width = config.width;
                if (config.text != null) text.text = config.text;
                if (config.size != null) text.size = config.size;
                text.active = true;
                script.textMap.set(name, text);
            default:
                var object:FlxObject = new FlxObject(config.x, config.y, config.width, config.height);
                object.active = true;
                script.objectMap.set(name, object);
        }
    }

    private function addObject(name:String) {
        if (script.spriteMap.exists(name)) {
            FlxG.state.add(script.spriteMap.get(name));
        } else if (script.textMap.exists(name)) {
            FlxG.state.add(script.textMap.get(name));
        } else {
            FlxG.state.add(script.objectMap.get(name));
        }
    }

    private function removeObject(name:String) {
        if (script.spriteMap.exists(name)) {
            script.spriteMap.remove(name);
            FlxG.state.remove(script.spriteMap.get(name));
        } else if (script.textMap.exists(name)) {
            script.textMap.remove(name);
            FlxG.state.remove(script.textMap.get(name));
        } else {
            script.objectMap.remove(name);
            FlxG.state.remove(script.objectMap.get(name));
        }
    }

    private function insertObject(name:String, pos:Int = 0) {
        if (script.spriteMap.exists(name)) {
            FlxG.state.insert(pos, script.spriteMap.get(name));
        } else if (script.textMap.exists(name)) {
            FlxG.state.insert(pos, script.textMap.get(name));
        } else {
            FlxG.state.insert(pos, script.objectMap.get(name));
        }
    }
}