package;

import flixel.FlxState;
import flixel.FlxG;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;

import openfl.Lib;

using StringTools;

class VideoState extends MusicBeatState
{
	public var leSource:String = "";
	public var transClass:FlxState;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;

	public function new(source:String, toTrans:FlxState, frameSkipLimit:Int = -1, autopause:Bool = false)
	{
		super();
		
		autoPause = autopause;
		
		leSource = source;
		transClass = toTrans;
	}

	var video:VideoHandler;
	
	override function create()
	{
		super.create();
		FlxG.autoPause = false;
		doShit = false;

		//MARIO PRODU SMELLS
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		video = new VideoHandler();
		video.playMP4(leSource, function(){
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			FlxG.switchState(transClass);
		}, false);
		add(video);
		
		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}

		if (FlxG.keys.justPressed.P)
		{
			trace("PRESSED PAUSE");
			if(video.paused)
			video.resume();
			else
			video.pause();
			if (video.paused)
			{
				video.alpha2();
			} else {
				video.unalpha2();
			}
		}
		
		if (controls.ACCEPT)
		{
			video.vlcClean();
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			FlxG.switchState(transClass);
		}
	}
}