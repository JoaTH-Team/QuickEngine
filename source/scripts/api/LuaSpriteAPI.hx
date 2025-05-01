package scripts.api;

import flixel.FlxSprite;
import scripts.LuaScript;

class LuaSpriteAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addcallback("configSprite", configSprite);
        script.addcallback("makeGraphic", makeGraphic);

        script.addcallback("getSpriteSheet", getSpriteSheet);
        script.addcallback("setAnimation", setAnimation);
        script.addcallback("playAnimation", playAnimation);
    }

    private function makeGraphic(name:String, config:Dynamic) {
        if (script.spriteMap.exists(name)) {
            var sprite:FlxSprite = script.spriteMap.get(name);
            if (config.width != null && config.height != null) {
                sprite.makeGraphic(config.width, config.height, EngineUtil.getColorName(config.color));
            }
        }
    }

    private function configSprite(name:String, config:Dynamic) {
        if (script.spriteMap.exists(name)) {
            var sprite:FlxSprite = script.spriteMap.get(name);
            if (config.image != null) sprite.loadGraphic(Paths.image(config.image));
            if (config.x != null) sprite.x = config.x;
            if (config.y != null) sprite.y = config.y;
            if (config.width != null) sprite.width = config.width;
            if (config.height != null) sprite.height = config.height;
            if (config.alpha != null) sprite.alpha = config.alpha;
            if (config.scale != null) sprite.scale.set(config.scale.x, config.scale.y);
            if (config.angle != null) sprite.angle = config.angle;
            if (config.visible != null) sprite.visible = config.visible;
            if (config.active != null) sprite.active = config.active;
            if (config.scrollFactor != null) sprite.scrollFactor.set(config.scrollFactor.x, config.scrollFactor.y);
        }
    }

    private function getSpriteSheet(name:String, image:String) {
        if (script.spriteMap.exists(name)) {
            var sprite:FlxSprite = script.spriteMap.get(name);
            return sprite.frames = Paths.getSparrowAtlas(image);
        }
        return null;
    }

    private function setAnimation(name:String, config:Dynamic) {
        if (script.spriteMap.exists(name)) {
            var sprite:FlxSprite = script.spriteMap.get(name);
            switch (config.type) {
                case "frame":
                    return sprite.animation.add(
                        config.name, 
                        config.frames, 
                        config.frameRate, 
                        config.loop, 
                        config.flipX, 
                        config.flipY
                    );
                case "prefix":
                    return sprite.animation.addByPrefix(
                        config.name, 
                        config.prefix, 
                        config.frameRate, 
                        config.loop, 
                        config.flipX, 
                        config.flipY
                    );
                case "indices":
                    return sprite.animation.addByIndices(
                        config.name, 
                        config.prefix, 
                        config.indices, 
                        config.postfix, 
                        config.frameRate, 
                        config.loop, 
                        config.flipX, 
                        config.flipY
                    );
            }
        }
    }

    private function playAnimation(name:String, animation:String, force:Bool = false) {
        if (script.spriteMap.exists(name)) {
            var sprite:FlxSprite = script.spriteMap.get(name);
            sprite.animation.play(animation, force);
            return true;
        }
        return false;
    }
}