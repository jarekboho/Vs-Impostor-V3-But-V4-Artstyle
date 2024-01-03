package;
import lime.app.Application;
import openfl.utils.Future;
import openfl.media.Sound;
import flixel.system.FlxSound;
#if sys
import smTools.SMFile;
import sys.FileSystem;
import sys.io.File;
#end
import Song.SwagSong;
import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	public static var curSelected:Int = 0;
	public static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var diffCalcText:FlxText;
	var previewtext:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	public static var openedPreview = false;

	public static var songData:Map<String,Array<SwagSong>> = [];

	var polusWarehouse:FlxSprite;
	var polusRocks:FlxSprite;
	var polusHills:FlxSprite;
	var polusGround:FlxSprite;
	var pixelSelected:Bool = false;

	var reactor:FlxSprite;
	var baller:FlxSprite;

	var bgSky:FlxSprite;

	var effect:MosaicEffect;
	var effectTween:FlxTween;

	var defeatScroll:FlxSprite;

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
	{
		try 
		{
			array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
		}
		catch(ex)
		{
			// do nada
		}
	}

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('data/freeplaySonglist'));

		//var diffList = "";

		songData = [];
		songs = [];

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var meta = new SongMetadata(data[0], Std.parseInt(data[2]), data[1]);
			var format = StringTools.replace(meta.songName, " ", "-");
			switch (format) {
				case 'Dad-Battle': format = 'Dadbattle';
				case 'Philly-Nice': format = 'Philly';
			}

			var diffs = [];
			var diffsThatExist = [];


			#if sys
			if (FileSystem.exists('assets/data/${format}/${format}-hard.json'))
				diffsThatExist.push("Hard");
			if (FileSystem.exists('assets/data/${format}/${format}-easy.json'))
				diffsThatExist.push("Easy");
			if (FileSystem.exists('assets/data/${format}/${format}.json'))
				diffsThatExist.push("Normal");

			if (diffsThatExist.length == 0)
			{
				Application.current.window.alert("No difficulties found for chart, skipping.",meta.songName + " Chart");
				continue;
			}
			#else
			diffsThatExist = ["Easy","Normal","Hard"];
			#end
			if (diffsThatExist.contains("Easy"))
				FreeplayState.loadDiff(0,format,meta.songName,diffs);
			if (diffsThatExist.contains("Normal"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);
			if (diffsThatExist.contains("Hard"))
				FreeplayState.loadDiff(2,format,meta.songName,diffs);

			meta.diffs = diffsThatExist;

			if (diffsThatExist.length != 3)
				trace("I ONLY FOUND " + diffsThatExist);

			FreeplayState.songData.set(meta.songName,diffs);
			trace('loaded diffs for ' + meta.songName);
			songs.push(meta);

		}

		trace("tryin to load sm files");

		#if sys
		for(i in FileSystem.readDirectory("assets/sm/"))
		{
			trace(i);
			if (FileSystem.isDirectory("assets/sm/" + i))
			{
				trace("Reading SM file dir " + i);
				for (file in FileSystem.readDirectory("assets/sm/" + i))
				{
					if (file.contains(" "))
						FileSystem.rename("assets/sm/" + i + "/" + file,"assets/sm/" + i + "/" + file.replace(" ","_"));
					if (file.endsWith(".sm"))
					{
						trace("reading " + file);
						var file:SMFile = SMFile.loadFile("assets/sm/" + i + "/" + file.replace(" ","_"));
						trace("Converting " + file.header.TITLE);
						var data = file.convertToFNF("assets/sm/" + i + "/converted.json");
						var meta = new SongMetadata(file.header.TITLE, 0, "sm",file,"assets/sm/" + i);
						songs.push(meta);
						var song = Song.loadFromJsonRAW(data);
						songData.set(file.header.TITLE, [song,song,song]);
					}
				}
			}
		}
		#end

		//trace("\n" + diffList);

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('spacep'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		
		

		polusRocks = new FlxSprite(-700, -300).loadGraphic(Paths.image('polusrocks'));
		polusHills = new FlxSprite(-1050, -180.55).loadGraphic(Paths.image('polusHills'));
		polusWarehouse = new FlxSprite(50, -400).loadGraphic(Paths.image('polus_custom_lab'));
		polusGround = new FlxSprite(-1350, 80).loadGraphic(Paths.image('polus_custom_floor'));
		add(polusRocks);
		add(polusHills);
		add(polusWarehouse);
		add(polusGround);

		baller = new FlxSprite(100, 1000);
		baller.frames = Paths.getSparrowAtlas('ball lol');
		baller.animation.addByPrefix('bop', 'core instance 1', 24, false);
		add(baller);

		reactor = new FlxSprite(-1125, 100).loadGraphic(Paths.image('reactorroom'));
		add(reactor);

		bgSky = new FlxSprite(-500, 270).loadGraphic(Paths.image('tomong'));
		bgSky.scrollFactor.set(0.1, 0.1);
		bgSky.screenCenter();
		add(bgSky);
		bgSky.setGraphicSize(Std.int(bgSky.width * 5));
		bgSky.alpha = 0;

		effect = new MosaicEffect();
		bgSky.shader = effect.shader;

		defeatScroll = new FlxSprite(-100, 937).loadGraphic(Paths.image('defeatScroll'));
		defeatScroll.scrollFactor.x = 0;
		defeatScroll.scrollFactor.y = 0.10;
		defeatScroll.setGraphicSize(Std.int(defeatScroll.width * 1.1));
		defeatScroll.updateHitbox();
		defeatScroll.screenCenter();
		add(defeatScroll);

		var gradient:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuGr'));
		gradient.scrollFactor.x = 0;
		gradient.scrollFactor.y = 0.10;
		gradient.setGraphicSize(Std.int(gradient.width * 1.1));
		gradient.updateHitbox();
		gradient.screenCenter();
		add(gradient);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 105, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		add(diffCalcText);

		previewtext = new FlxText(scoreText.x, scoreText.y + 94, 0, "" + (KeyBinds.gamepad ? "X" : "SPACE") + " to preview", 24);
		previewtext.font = scoreText.font;
		//add(previewtext);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if (FlxG.sound.music.volume > 0.8)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
		}

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{

			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}

			//if (gamepad.justPressed.X && !openedPreview)
				//openSubState(new DiffOverview());
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		//if (FlxG.keys.justPressed.SPACE && !openedPreview)
			//openSubState(new DiffOverview());

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}
			var hmm;
			try
			{
				hmm = songData.get(songs[curSelected].songName)[curDifficulty];
				if (hmm == null)
					return;
			}
			catch(ex)
			{
				return;
			}


			PlayState.SONG = hmm;
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			#if sys
			if (songs[curSelected].songCharacter == "sm")
				{
					PlayState.isSM = true;
					PlayState.sm = songs[curSelected].sm;
					PlayState.pathToSm = songs[curSelected].path;
				}
			else
				PlayState.isSM = false;
			#else
			PlayState.isSM = false;
			#end
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		if (!songs[curSelected].diffs.contains(CoolUtil.difficultyFromInt(curDifficulty + change)))
			return;

		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end
		diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}

	var groundTween:FlxTween;
	var hillsTween:FlxTween;
	var rocksTween:FlxTween;
	var warehouseTween:FlxTween;
	var reactorTween:FlxTween;
	var ballerTween:FlxTween;
	var defeatTween:FlxTween;

	function cancelTweens()
	{
		groundTween.cancel();
		hillsTween.cancel();
		rocksTween.cancel();
		warehouseTween.cancel();
		reactorTween.cancel();
		ballerTween.cancel();
		defeatTween.cancel();
	}	

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);



		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].diffs.length != 3)
		{
			switch(songs[curSelected].diffs[0])
			{
				case "Easy":
					curDifficulty = 0;
				case "Normal":
					curDifficulty = 1;
				case "Hard":
					curDifficulty = 2;
			}
		}

		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';
		
		#if PRELOAD_ALL
		if (songs[curSelected].songCharacter == "sm")
		{
			var data = songs[curSelected];
			trace("Loading " + data.path + "/" + data.sm.header.MUSIC);
			var bytes = File.getBytes(data.path + "/" + data.sm.header.MUSIC);
			var sound = new Sound();
			sound.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
			FlxG.sound.playMusic(sound);
		}
		else
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var hmm;
			try
			{
				hmm = songData.get(songs[curSelected].songName)[curDifficulty];
				if (hmm != null)
					Conductor.changeBPM(hmm.bpm);
			}
			catch(ex)
			{}

		if (openedPreview)
		{
			closeSubState();
			openSubState(new DiffOverview());
		}

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		switch(songs[curSelected].week)
		{
			case 1: 
			{
				if(groundTween != null)
				{
					cancelTweens();
				}
				groundTween = FlxTween.tween(polusGround,{y: 80}, 0.5 ,{ease: FlxEase.expoOut});
				hillsTween = FlxTween.tween(polusHills,{y: -180.55}, 0.6 ,{ease: FlxEase.expoOut});
				rocksTween = FlxTween.tween(polusRocks,{y: -300}, 1 ,{ease: FlxEase.expoOut});
				warehouseTween = FlxTween.tween(polusWarehouse,{y: -400}, 0.8 ,{ease: FlxEase.expoOut});
				reactorTween = FlxTween.tween(reactor,{y: 100}, 0.6 ,{ease: FlxEase.expoIn});
				ballerTween = FlxTween.tween(baller,{y: 1000}, 0.8 ,{ease: FlxEase.expoIn});
				defeatTween = FlxTween.tween(defeatScroll,{y: 937}, 3 ,{ease: FlxEase.expoOut});
				effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 15, 0.5, {type: ONESHOT}, function(v)
				{
					effect.setStrength(v, v);
				});
				FlxTween.tween(bgSky, {alpha: 0}, 0.4, {ease: FlxEase.expoIn});
				pixelSelected = false;

			}
			case 2:
			{
				if(groundTween != null)
				{
						cancelTweens();
				}
				groundTween = FlxTween.tween(polusGround,{y: 1169.29}, 0.5 ,{ease: FlxEase.expoIn});
				hillsTween = FlxTween.tween(polusHills,{y: 873.62}, 0.6 ,{ease: FlxEase.expoIn});
				rocksTween = FlxTween.tween(polusRocks,{y: 712.09}, 0.8 ,{ease: FlxEase.expoIn});
				warehouseTween = FlxTween.tween(polusWarehouse,{y: 1220.92}, 0.7 ,{ease: FlxEase.expoIn});
				reactorTween = FlxTween.tween(reactor,{y: -600}, 0.6 ,{ease: FlxEase.expoOut});
				ballerTween = FlxTween.tween(baller,{y: -500}, 0.8 ,{ease: FlxEase.expoOut});
				defeatTween = FlxTween.tween(defeatScroll,{y: 937}, 3 ,{ease: FlxEase.expoOut});
				effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 15, 0.5, {type: ONESHOT}, function(v)
				{
					effect.setStrength(v, v);
				});
				FlxTween.tween(bgSky, {alpha: 0}, 0.4, {ease: FlxEase.expoIn});
				pixelSelected = false;
				//ARGGHHHH MY NUTS!
			}
			case 3:
			{
				if(groundTween != null)
				{
						cancelTweens();
				}
				groundTween = FlxTween.tween(polusGround,{y: 1169.29}, 0.5 ,{ease: FlxEase.expoIn});
				hillsTween = FlxTween.tween(polusHills,{y: 873.62}, 0.6 ,{ease: FlxEase.expoIn});
				rocksTween = FlxTween.tween(polusRocks,{y: 712.09}, 0.8 ,{ease: FlxEase.expoIn});
				warehouseTween = FlxTween.tween(polusWarehouse,{y: 1220.92}, 0.7 ,{ease: FlxEase.expoIn});
				reactorTween = FlxTween.tween(reactor,{y: 100}, 0.6 ,{ease: FlxEase.expoIn});
				ballerTween = FlxTween.tween(baller,{y: 1000}, 0.8 ,{ease: FlxEase.expoIn});
				defeatTween = FlxTween.tween(defeatScroll,{y: 937}, 3 ,{ease: FlxEase.expoOut});
				if(!pixelSelected) {
					effectTween = FlxTween.num(15, MosaicEffect.DEFAULT_STRENGTH, 0.5, {type: ONESHOT}, function(v)
					{
						effect.setStrength(v, v);
					});
				}
				FlxTween.tween(bgSky, {alpha: 1}, 0.4, {ease: FlxEase.expoOut});
				pixelSelected = true;
			}
			case 4:
			{
				if(groundTween != null)
				{
						cancelTweens();
				}
				groundTween = FlxTween.tween(polusGround,{y: 1169.29}, 0.5 ,{ease: FlxEase.expoIn});
				hillsTween = FlxTween.tween(polusHills,{y: 873.62}, 0.6 ,{ease: FlxEase.expoIn});
				rocksTween = FlxTween.tween(polusRocks,{y: 712.09}, 0.8 ,{ease: FlxEase.expoIn});
				warehouseTween = FlxTween.tween(polusWarehouse,{y: 1220.92}, 0.7 ,{ease: FlxEase.expoIn});
				reactorTween = FlxTween.tween(reactor,{y: 100}, 0.6 ,{ease: FlxEase.expoIn});
				ballerTween = FlxTween.tween(baller,{y: 1000}, 0.8 ,{ease: FlxEase.expoIn});
				defeatTween = FlxTween.tween(defeatScroll,{y: -2050}, 3 ,{ease: FlxEase.expoOut});
				effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 15, 0.5, {type: ONESHOT}, function(v)
				{
					effect.setStrength(v, v);
				});
				FlxTween.tween(bgSky, {alpha: 0}, 0.4, {ease: FlxEase.expoIn});
				pixelSelected = false;
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	#if sys
	public var sm:SMFile;
	public var path:String;
	#end
	public var songCharacter:String = "";

	public var diffs = [];

	#if sys
	public function new(song:String, week:Int, songCharacter:String, ?sm:SMFile = null, ?path:String = "")
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.sm = sm;
		this.path = path;
	}
	#else
	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
	#end
}