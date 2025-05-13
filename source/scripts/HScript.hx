package scripts;

import flixel.FlxG;
import sys.io.File;
import crowplexus.iris.Iris;

using StringTools;

class HScript extends Iris
{
    var getInstance:Dynamic = null;

    public function new(file:String, instanceState:Dynamic) {
        super(File.getContent(file));
        config.autoPreset = true;
        config.autoRun = false;
        config.name = Std.string(file); // for sure

        getInstance = instanceState;
        var customInterp:CustomInterp = new CustomInterp();
        customInterp.parentInstance = getInstance;
        this.interp = customInterp;

        presentCode();

        execute(); // for sure pt.2
    }

    function presentCode() {
        // Flixel
        set('FlxG', flixel.FlxG);
        set('FlxSprite', flixel.FlxSprite);
        set('FlxText', flixel.text.FlxText);
        set('FlxCamera', flixel.FlxCamera);
        set('FlxTypeText', flixel.addons.text.FlxTypeText);
        set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);

        // OpenFL
        set('ShaderFilter', openfl.filters.ShaderFilter);
        set('System', openfl.system.System);
        set('Assets', openfl.Assets);
        set('Lib', openfl.Lib);

        // Lime
        set('Application', lime.app.Application);

        // Quick Engine
        set('Paths', Paths);
        set('EngineUtil', EngineUtil);
        set('ScriptedState', ScriptedState);

        // Functions
        set('add', function (basic:flixel.FlxBasic) return flixel.FlxG.state.add(basic));
        set('remove', function (basic:flixel.FlxBasic) return flixel.FlxG.state.remove(basic));
        set('insert', function (pos:Int, basic:flixel.FlxBasic) return flixel.FlxG.state.insert(pos, basic));
    
        set('switchScriptState', function (name:String, allowToLoadOtherFile:Bool = false) return flixel.FlxG.switchState(() -> new ScriptedState(name, allowToLoadOtherFile)));
        set('openScriptSubState', function (name:String, allowLoadOtherFile:Bool = false) {
            try {
                var directory = Paths.file('data/states/');
                if (sys.FileSystem.exists(directory))
                {
                    for (file in sys.FileSystem.readDirectory(directory))
                    {
                        if (file.endsWith(name + '.lua'))
                        {
                            FlxG.state.openSubState(new ScriptedSubState(name, allowLoadOtherFile));
                        }
                        for (ext in Paths.HSCRIPT_EXT)
                        {
                            if (file.endsWith(name + ext))
                            {
                                FlxG.state.openSubState(new ScriptedSubState(name, allowLoadOtherFile));
                            }
                        }
                    }
                }
            }
            catch (e:haxe.Exception)
            {
                trace(e.details());
            }
        });
        set('closeScriptSubState', function () {
            try {
                FlxG.state.closeSubState();
            }
            catch (e:haxe.Exception)
            {
                trace(e.details());
            }
        });

        set('getInputPress', function (type:String, key:String) {
            var returnKey:String = key.toUpperCase();
            switch (type.toLowerCase()) {
                case "justPressed":
                    return Reflect.getProperty(flixel.FlxG.keys.justPressed, returnKey);
                case "pressed":
                    return Reflect.getProperty(flixel.FlxG.keys.pressed, returnKey);
                case "released":
                    return Reflect.getProperty(flixel.FlxG.keys.released, returnKey);
            }
            return Reflect.getProperty(flixel.FlxG.keys.justPressed, returnKey);
        });
    
        // Variables
        set('game', getInstance);
        set('quickEngineVersion', flixel.FlxG.stage.window.application.meta.get("version"));
    }

    override function call(fun:String, ?args:Array<Dynamic>):IrisCall {
        if (fun == null || !exists(fun)) return null;
        return super.call(fun, args);
    }
}