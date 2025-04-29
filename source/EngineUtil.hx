package;

import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;

class EngineUtil {
    public static function getColorName(name:String) {
        switch (name) {
            case "white":
                return FlxColor.WHITE;
            case "black":
                return FlxColor.BLACK;
            case "red":
                return FlxColor.RED;
            case "green":
                return FlxColor.GREEN;
            case "blue":
                return FlxColor.BLUE;
            case "yellow":
                return FlxColor.YELLOW;
            case "purple":
                return FlxColor.PURPLE;
            case "cyan":
                return FlxColor.CYAN;
            case "gray":
                return FlxColor.GRAY;
            case "orange":
                return FlxColor.ORANGE;
            case "lime":
                return FlxColor.LIME;
            case "magenta":
                return FlxColor.MAGENTA;
            case "pink":
                return FlxColor.PINK;
            case "brown":
                return FlxColor.BROWN;
            case "transparent":
                return FlxColor.TRANSPARENT;
            case "":
                return FlxColor.WHITE;
        }
        return FlxColor.WHITE;
    }

    public static function getAlignmentName(name:String) {
        switch (name) {
            case "left":
                return FlxTextAlign.LEFT;
            case "center":
                return FlxTextAlign.CENTER;
            case "right":
                return FlxTextAlign.RIGHT;
        }
        return FlxTextAlign.LEFT;
    }

    public static function getBorderStyleName(name:String) {
        switch (name) {
            case "none":
                return FlxTextBorderStyle.NONE;
            case "shadow":
                return FlxTextBorderStyle.SHADOW;
            case "outline":
                return FlxTextBorderStyle.OUTLINE;
            case "outlineFast":
                return FlxTextBorderStyle.OUTLINE_FAST;
        }
        return FlxTextBorderStyle.NONE;
    }
}