package;

import flixel.input.keyboard.FlxKey;
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

    public static function getKeyName(name:String) {
        switch (name) {
            case "A":
                return FlxKey.A;
            case "B":
                return FlxKey.B;
            case "C":
                return FlxKey.C;
            case "D":
                return FlxKey.D;
            case "E":
                return FlxKey.E;
            case "F":
                return FlxKey.F;
            case "G":
                return FlxKey.G;
            case "H":
                return FlxKey.H;
            case "I":
                return FlxKey.I;
            case "J":
                return FlxKey.J;
            case "K":
                return FlxKey.K;
            case "L":
                return FlxKey.L;
            case "M":
                return FlxKey.M;
            case "N":
                return FlxKey.N;
            case "O":
                return FlxKey.O;
            case "P":
                return FlxKey.P;
            case "Q":
                return FlxKey.Q;
            case "R":
                return FlxKey.R;
            case "S":
                return FlxKey.S;
            case "T":
                return FlxKey.T;
            case "U":
                return FlxKey.U;
            case "V":
                return FlxKey.V;
            case "W":
                return FlxKey.W;
            case "X":
                return FlxKey.X;
            case "Y":
                return FlxKey.Y;
            case "Z":
                return FlxKey.Z;
            case "ZERO":
                return FlxKey.ZERO;
            case "ONE":
                return FlxKey.ONE;
            case "TWO":
                return FlxKey.TWO;
            case "THREE":
                return FlxKey.THREE;
            case "FOUR":
                return FlxKey.FOUR;
            case "FIVE":
                return FlxKey.FIVE;
            case "SIX":
                return FlxKey.SIX;
            case "SEVEN":
                return FlxKey.SEVEN;
            case "EIGHT":
                return FlxKey.EIGHT;
            case "NINE":
                return FlxKey.NINE;
            case "SPACE":
                return FlxKey.SPACE;
            case "ENTER":
                return FlxKey.ENTER;
            case "ESCAPE":
                return FlxKey.ESCAPE;
            case "UP":
                return FlxKey.UP;
            case "DOWN":
                return FlxKey.DOWN;
            case "LEFT":
                return FlxKey.LEFT;
            case "RIGHT":
                return FlxKey.RIGHT;
        }

        return FlxKey.NONE;
    }
}