package;

import flixel.util.FlxSignal;
import openfl.events.Event;
import openfl.media.SoundTransform;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import vlc.VlcBitmap;

/**
	An adaptation of PolybiusProxy's OpenFL desktop MP4 code to not only make         
	work as a Flixel Sprite, but also allow it to work with standard OpenFL               
	on Web builds as well.              
	@author Rozebud
**/

class VideoHandler extends FlxSprite
{
	/**
		Sets the maximum framerate that the video object will be to the sprite at.
		Helps increase performance on lower end machines and web builds.
	**/
	public static var MAX_FPS = 60;

	/**
		Determines whether the video plays auido. 
	**/
	public var muted(get, set):Bool;
	public var volume:Float = 1;

	//public var length(get, never):Float;

	var __muted:Bool = false;
	public var paused:Bool = false;
	var finishCallback:Void->Void;
	var waitingStart:Bool = false;
	var startDrawing:Bool = false;
	var frameCount:Float = 0;
	var completed:Bool = false;
	var destroyed:Bool = false;

	#if desktop
	var vlcBitmap:VlcBitmap;
	#end

	#if web
	var video:Video;
	var netStream:NetStream;
	var netPath:String;
	var netLoop:Bool;
	#end

	public function new(?x:Float = 0, ?y:Float = 0){
		super(x, y);
		makeGraphic(1, 1, FlxColor.TRANSPARENT);
	}

	/**
		Generic play function. 
		Works with both desktop and web builds.
	**/
	public function playMP4(videoPath:String, callback:Void->Void, ?repeat:Bool = false){

		#if desktop
		playDesktopMP4(videoPath, callback, repeat);
		#end

		#if web
		playWebMP4(videoPath, callback, repeat);
		#end

	}

	//===========================================================================================================//

	#if desktop
	/**
		Plays MP4s using VLC Bitmaps as the source.
		Only works on desktop builds.
		It is recommended that you use `playMP4()` instead since that works for desktop and web.
	**/
	@:noCompletion public function playDesktopMP4(path:String, callback:Void->Void, ?repeat:Bool = false, ?isWindow:Bool = false, ?isFullscreen:Bool = false):Void {

		//FlxG.autoPause = false;

		//if (FlxG.sound.music != null)
		//{
		//	FlxG.sound.music.stop();
		//}

		finishCallback = callback;

		vlcBitmap = new VlcBitmap();
		vlcBitmap.onVideoReady = onVLCVideoReady;
		vlcBitmap.onComplete = onVLCComplete;
		vlcBitmap.volume = FlxG.sound.volume;

		if (repeat)
			vlcBitmap.repeat = -1;
		else
			vlcBitmap.repeat = 0;

		vlcBitmap.inWindow = isWindow;
		vlcBitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(vlcBitmap);
		vlcBitmap.play(checkFile(path));
		vlcBitmap.visible = false;

		FlxG.signals.focusLost.add(pause);
		FlxG.signals.focusGained.add(resume);

		waitingStart = true;
	}

	function checkFile(fileName:String):String
	{
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";
		if (fileName.indexOf(":") == -1) // Not a path
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1) // C:, D: etc? ..missing "file:///" ?
			pDir = "file:///";

		return pDir + fileName;
	}

	function onVLCVideoReady()
	{
		trace("video loaded!");
	}

	function onVLCComplete()
	{
		if (finishCallback != null){
			finishCallback();
		}

		destroy();

		//FlxG.autoPause = true;

	}

	public function vlcClean(){
		vlcBitmap.stop();

		// Clean player, just in case!
		vlcBitmap.dispose();

		if (FlxG.game.contains(vlcBitmap))
		{
			FlxG.game.removeChild(vlcBitmap);
		}

		trace("Done!");
		completed = true;
	}
	#end

	//===========================================================================================================//

	#if web
	/**
		Plays MP4s using OpenFL NetStreams and Videos as the source.
		Only works on web builds.
		It is recommended that you use `playMP4()` instead since that works for desktop and web.
	**/
	@:noCompletion public function playWebMP4(videoPath:String, callback:Void->Void, ?repeat:Bool = false) {

		netLoop = repeat;
		netPath = videoPath;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		finishCallback = callback;

		video = new Video();
		video.x = -1280;
		video.y = -720;

		FlxG.addChildBelowMouse(video);

		var nc = new NetConnection();
		nc.connect(null);

		netStream = new NetStream(nc);
		netStream.client = {onMetaData: client_onMetaData};

		nc.addEventListener("netStatus", netConnection_onNetStatus);

		FlxG.signals.focusLost.add(pause);
		FlxG.signals.focusGained.add(resume);

		netStream.play(netPath);
	}

	function client_onMetaData(videoPath)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;

		waitingStart = true;
	}

	function netConnection_onNetStatus(videoPath){
		if (videoPath.info.code == "NetStream.Play.Complete")
		{
			if(netLoop){
				netStream.play(netPath);
			}
			else{
				finishVideo();
			}
		}
		if (videoPath.info.code == "NetStream.Play.Start")
		{
			setSoundTransform(__muted);
		}
	}

	function finishVideo(){
		
		if (finishCallback != null){
				finishCallback();
		}
		
		destroy();

	}

	function netClean(){
		
		netStream.dispose();

		completed = true;

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);
		}

		trace("Done!");
		completed = true;
	}

	function setSoundTransform(isMuted:Bool){
		if(!isMuted){
			netStream.soundTransform = new SoundTransform(FlxG.sound.volume);
		}
		else{
			netStream.soundTransform = new SoundTransform(0);
		}
	}
	#end

	//===========================================================================================================//

	//Basically just grabbing the bitmap data from the video objects and drawing it to the FlxSprite every so often. 
	override function update(elapsed){

		super.update(elapsed);

		#if desktop
		if(vlcBitmap != null){

			if(!__muted){
				//I'm going to blow up a retirement home.
				var vol:Float = FlxG.sound.volume;
				vol = (vol) * 0.7;
				vol += 0.3;
				vlcBitmap.volume = vol * volume;
			}
			else{
				vlcBitmap.volume = 0;
			}

		}

		if(waitingStart){

			if(vlcBitmap.initComplete){
				makeGraphic(vlcBitmap.bitmapData.width, vlcBitmap.bitmapData.height, FlxColor.TRANSPARENT);

				waitingStart = false;
				startDrawing = true;
			}
			
		}

		if(startDrawing && !paused){

				if(frameCount >= 1/MAX_FPS){
					pixels.draw(vlcBitmap.bitmapData);
					frameCount = 0;
				}
				frameCount += elapsed;

		}
		#end

		#if web
		if(FlxG.keys.justPressed.MINUS || FlxG.keys.justPressed.PLUS){
			setSoundTransform(__muted);
		}

		if(waitingStart){

			makeGraphic(video.videoWidth, video.videoHeight, FlxColor.TRANSPARENT);

			waitingStart = false;
			startDrawing = true;
			
		}

		if(startDrawing && !paused){

			if(frameCount >= 1/MAX_FPS){
				pixels.draw(video);
				frameCount = 0;
			}
			frameCount += elapsed;

		}
		#end

	}

	override function destroy():Void{

		if(destroyed){
			return;
		}
			
		destroyed = true;

		FlxG.signals.focusLost.remove(pause);
		FlxG.signals.focusGained.remove(resume);

		#if desktop
		if(!completed){
			vlcClean();
		}
		#end

		#if web
		if(!completed){
			netClean();
		}
		#end

		super.destroy();
		
	}

	/**
		Pauses playback of the video.
	**/
	public function pause(){

		#if desktop
		if(vlcBitmap != null && !paused){
			vlcBitmap.pause();
		}
		#end

		#if web
		if(netStream != null && !paused){
			netStream.pause();
		}
		#end

		paused = true;
	}

	/**
		Resumes playback of the video.
	**/
	public function resume(){

		#if desktop
		if(vlcBitmap != null && paused){ 
			vlcBitmap.resume();
		}
		#end

		#if web
		if(netStream != null && paused){ 
			netStream.resume();
		}
		#end

		paused = false;
	}

	public function skip(){

		#if desktop
		onVLCComplete();
		#end
		#if web
		finishVideo();
		#end

	}

	private function get_muted():Bool{
		return __muted;
	}

	private function set_muted(value:Bool):Bool{

		#if web
		if(startDrawing){
			setSoundTransform(value);
		}
		#end

		return __muted = value;
	}
	

	/*function get_length():Float {
		#if desktop
		return vlcBitmap.length;
		#end
		#if web
		@:privateAccess
		return netStream.__video.duration;
		#end
	}*/

	public function alpha2():Void
	{
		this.alpha = GlobalVideo.daAlpha1;
	}
	
	public function unalpha2():Void
	{
		this.alpha = GlobalVideo.daAlpha2;
	}
}