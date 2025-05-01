package scripts.api;

import PlayState;
import scripts.LuaScript;

class LuaPropertyAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addcallback("setProperty", setProperty);
        script.addcallback("getProperty", getProperty);

        script.addcallback("setPosition", setPosition);
        script.addcallback("setScale", setScale);
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
        }
    }

    private function setProperty(name:String, property:String, value:Dynamic) {
        if (script.spriteMap.exists(name)) {
            var sprite = script.spriteMap.get(name);
            Reflect.setProperty(sprite, property, value);
        } else if (script.textMap.exists(name)) {
            var text = script.textMap.get(name);
            Reflect.setProperty(text, property, value);
        } else if (script.objectMap.exists(name)) {
            var object = script.objectMap.get(name);
            Reflect.setProperty(object, property, value);
        } else {
            var instance = PlayState.instance;
            if (instance != null) {
                Reflect.setProperty(instance, property, value);
            }
        }
    }

    private function getProperty(name:String, property:String) {
        if (script.spriteMap.exists(name)) {
            var sprite = script.spriteMap.get(name);
            return Reflect.getProperty(sprite, property);
        } else if (script.textMap.exists(name)) {
            var text = script.textMap.get(name);
            return Reflect.getProperty(text, property);
        } else if (script.objectMap.exists(name)) {
            var object = script.objectMap.get(name);
            return Reflect.getProperty(object, property);
        } else {
            var instance = PlayState.instance;
            if (instance != null) {
                return Reflect.getProperty(instance, property);
            }
        }
        return null;
    }
}