package;

import custom.*;
import flixel.text.FlxText.FlxTextBorderStyle;

class EngineUtil {
    public static function getColorName(name:String):Int {
        var color = Reflect.getProperty(CustomFlxColor, name.toUpperCase());
        return (color != null) ? color : CustomFlxColor.WHITE;
    }

    public static function getAlignmentName(name:String) {
        var alignment = Reflect.getProperty(CustomFlxTextAlign, name.toUpperCase());
        return (alignment != null) ? alignment : CustomFlxTextAlign.LEFT;
    }

    public static function getBorderStyleName(name:String) {
        var borderStyle = Reflect.getProperty(FlxTextBorderStyle, name.toUpperCase());
        return (borderStyle != null) ? borderStyle : FlxTextBorderStyle.NONE;
    }

    public static function getKeyName(name:String) {
        var key = Reflect.getProperty(CustomFlxKey, name.toUpperCase());
        return (key != null) ? key : CustomFlxKey.NONE;
    }
}