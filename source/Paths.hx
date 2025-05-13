package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.media.Sound;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

@:keep
@:access(openfl.display.BitmapData)
class Paths {
	inline public static final DEFAULT_FOLDER:String = 'game';

	public static var SOUND_EXT:Array<String> = ['.ogg', '.wav'];
	public static var HSCRIPT_EXT:Array<String> = ['.hx', '.hxs', '.hscript', '.hxc', '.haxeScript'];

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var localTrackedAssets:Array<String> = [];

	static public function getPath(folder:Null<String>, file:String) {
		if (folder == null)
			folder = DEFAULT_FOLDER;
		#if sys
		var modPath = './$folder/$file';
		if (FileSystem.exists(modPath))
			return modPath;
		#end
		return folder + '/' + file;
	}

	static public function file(file:String, folder:String = DEFAULT_FOLDER) {
		if (#if sys FileSystem.exists(folder) && #end (folder != null && folder != DEFAULT_FOLDER))
			return getPath(folder, file);
		return getPath(null, file);
	}

	inline static public function data(key:String)
		return file('data/$key');

	inline static public function video(key:String)
		return file('videos/$key.mp4');

	static public function sound(key:String, ?cache:Bool = true):Sound
		return returnSound('sounds/$key', cache);

	inline static public function music(key:String, ?cache:Bool = true):Sound
		return returnSound('music/$key', cache);

	inline static public function image(key:String, ?cache:Bool = true):FlxGraphic
		return returnGraphic('images/$key', cache);

	inline static public function font(key:String)
		return file('fonts/$key');

	inline static public function getSparrowAtlas(key:String)
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));

	inline static public function getPackerAtlas(key:String)
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt'));

	public static function returnGraphic(key:String, ?cache:Bool = true):FlxGraphic
	{
		var path:String = file('$key.png');
		#if sys
		// Check for game folder first
		var modPath = './$DEFAULT_FOLDER/$key.png';
		if (FileSystem.exists(modPath)) {
			if (!currentTrackedAssets.exists(modPath)) {
				var bitmap = BitmapData.fromFile(modPath);
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, modPath, cache);
				graphic.persist = true;
				currentTrackedAssets.set(modPath, graphic);
			}
			localTrackedAssets.push(modPath);
			return currentTrackedAssets.get(modPath);
		}
		#end

		if (Assets.exists(path, IMAGE)) {
			if (!currentTrackedAssets.exists(path)) {
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(Assets.getBitmapData(path), false, path, cache);
				graphic.persist = true;
				currentTrackedAssets.set(path, graphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}

		trace('oops! graphic $key returned null');
		return null;
	}

	public static function returnSound(key:String, ?cache:Bool = true, ?beepOnNull:Bool = true):Sound
	{
		for (i in SOUND_EXT) {
			var path:String = file(key + i);
			#if sys
			// Check for mod file first
			var modPath = './$DEFAULT_FOLDER/$key$i';
			if (FileSystem.exists(modPath)) {
				if (!currentTrackedSounds.exists(modPath))
					currentTrackedSounds.set(modPath, Sound.fromFile(modPath));
				localTrackedAssets.push(modPath);
				return currentTrackedSounds.get(modPath);
			}
			#end

			if (Assets.exists(path, SOUND)) {
				if (!currentTrackedSounds.exists(path))
					currentTrackedSounds.set(path, Assets.getSound(path, cache));
				localTrackedAssets.push(path);
				return currentTrackedSounds.get(path);
			}
		}

		if (beepOnNull) {
			trace('oops! sound $key returned null');
			return FlxAssets.getSoundAddExtension('flixel/sounds/beep');
		}
		return null;
	}

	inline static public function getAsepriteAtlas(key:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromAseprite(image(key), file('images/$key.json'));
	}
}