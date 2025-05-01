package scripts.api;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;

class LuaCameraAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addcallback("createCamera", createCamera);
        script.addcallback("addCamera", addCamera);
        script.addcallback("removeCamera", removeCamera);

        script.addcallback("setCameraBgColor", setCameraBgColor);
        script.addcallback("setObjectCamera", setObjectCamera);
    }

    private function setObjectCamera(name:String, cameraName:String) {
        if (script.spriteMap.exists(name)) {
            var sprite:FlxSprite = script.spriteMap.get(name);
            if (script.cameraMap.exists(cameraName)) {
                var camera:FlxCamera = script.cameraMap.get(cameraName);
                sprite.cameras = [camera];
            }
        } else if (script.textMap.exists(name)) {
            var text:FlxText = script.textMap.get(name);
            if (script.cameraMap.exists(cameraName)) {
                var camera:FlxCamera = script.cameraMap.get(cameraName);
                text.cameras = [camera];
            }
        } else if (script.objectMap.exists(name)) {
            var object:FlxObject = script.objectMap.get(name);
            if (script.cameraMap.exists(cameraName)) {
                var camera:FlxCamera = script.cameraMap.get(cameraName);
                object.cameras = [camera];
            }
        }
    }

    private function setCameraBgColor(name:String, color:String) {
        if (script.cameraMap.exists(name)) {
            var camera:FlxCamera = script.cameraMap.get(name);
            camera.bgColor = EngineUtil.getColorName(color);
        }
    }

    private function createCamera(name:String, config:Dynamic) {
        var camera = new FlxCamera();
        if (config.x != null) camera.x = config.x;
        if (config.y != null) camera.y = config.y;
        if (config.width != null) camera.width = config.width;
        if (config.height != null) camera.height = config.height;
        if (config.zoom != null) camera.zoom = config.zoom;
        camera.active = true;
        script.cameraMap.set(name, camera);
    }

    private function addCamera(name:String, defaultDraw:Bool = true) {
        if (script.cameraMap.exists(name)) {
            FlxG.cameras.add(script.cameraMap.get(name), defaultDraw);
        }
    }

    private function removeCamera(name:String) {
        if (script.cameraMap.exists(name)) {
            script.cameraMap.remove(name);
            FlxG.cameras.remove(script.cameraMap.get(name));
        }
    }
}