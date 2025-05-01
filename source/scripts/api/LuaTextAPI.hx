package scripts.api;

import flixel.text.FlxText;
import scripts.LuaScript;

class LuaTextAPI {
    private var script:LuaScript;

    public function new(script:LuaScript) {
        this.script = script;
    }

    public function initialize() {
        script.addcallback("configText", configText);
        script.addcallback("setText", setText);
    }

    private function setText(name:String, text:String) {
        if (script.textMap.exists(name)) {
            var flxText:FlxText = script.textMap.get(name);
            flxText.text = text;
        }
    }

    private function configText(name:String, config:Dynamic) {
        if (script.textMap.exists(name)) {
            var text:FlxText = script.textMap.get(name);
            if (config.x != null) text.x = config.x;
            if (config.y != null) text.y = config.y;
            if (config.width != null) text.width = config.width;
            if (config.text != null) text.text = config.text;
            if (config.size != null) text.size = config.size;
            if (config.color != null) text.color = EngineUtil.getColorName(config.color);
            if (config.alignment != null) text.alignment = EngineUtil.getAlignmentName(config.alignment);
            if (config.alpha != null) text.alpha = config.alpha;
            if (config.scale != null) text.scale.set(config.scale.x, config.scale.y);
            if (config.angle != null) text.angle = config.angle;
            if (config.visible != null) text.visible = config.visible;
            if (config.active != null) text.active = config.active;
            if (config.scrollFactor != null) text.scrollFactor.set(config.scrollFactor.x, config.scrollFactor.y);
            if (config.antialiasing != null) text.antialiasing = config.antialiasing;
            if (config.font != null) text.font = Paths.font(config.font);
            if (config.borderSize != null) text.borderSize = config.borderSize;
            if (config.borderColor != null) text.borderColor = EngineUtil.getColorName(config.borderColor);
            if (config.borderStyle != null) text.borderStyle = EngineUtil.getBorderStyleName(config.borderStyle);
            if (config.borderQuality != null) text.borderQuality = config.borderQuality;
        }
    }
}