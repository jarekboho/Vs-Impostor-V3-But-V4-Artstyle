package;

import flixel.graphics.tile.FlxGraphicsShader;
import flixel.graphics.FlxGraphic;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	static function weekData():Array<Dynamic>
	{
		return [
			['Sussus Moogus', 'Sabotage', 'Meltdown'],
			['Sussus Toogus', 'Lights Down', 'Reactor', 'Ejected'],
			['Sussy Bussy', 'Rivals', 'Chewmate'],
			['Defeat']
		];
	}
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['', 'bf', 'gf'],
		['', 'bf', 'gf'],
		['', 'bf', 'gf']
	];

	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/weekNames'));

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var polusWarehouse:FlxSprite;
	var polusRocks:FlxSprite;
	var polusHills:FlxSprite;
	var polusGround:FlxSprite;

	var reactor:FlxSprite;
	var baller:FlxSprite;

	var bgSky:FlxSprite;

	var effect:MosaicEffect;
	var effectTween:FlxTween;

	var defeatScroll:FlxSprite;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		#if debug
		for(i in 0...weekNames.length)
			weeks.push(true);
		return weeks;
		#end
		
		weeks.push(true);

		for(i in 0...FlxG.save.data.weekUnlocked)
			{
				weeks.push(true);
			}
		return weeks;
	}

	
	function amongTimer()
	{
		new FlxTimer().start(FlxG.random.int(3, 7), function(tmr:FlxTimer)
		{
			var tex = Paths.getSparrowAtlas('amongRun');

			var walking:FlxSprite = new FlxSprite();
			walking.setGraphicSize(Std.int(walking.width * 0.2));
			walking.screenCenter(Y);
			walking.updateHitbox();
			walking.x -= walking.width;
			
			walking.frames = tex;
			walking.animation.addByPrefix('Walk', 'Walk', 24);
			walking.animation.play('Walk');
			add(walking);

			FlxTween.tween(walking,{x: FlxG.width}, FlxG.random.int(10, 20));

			amongTimer();
		});
	}

	override function create()
	{

		

		weekUnlocked = unlockWeeks();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Conductor.changeBPM(102);
			}
		}

		

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

		//var topBlack:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 60, FlxColor.BLACK);
		//add(topBlack);

		//var bottomBlack:FlxSprite = new FlxSprite(0, 450).makeGraphic(FlxG.width, 500, FlxColor.BLACK);
		//add(bottomBlack);

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		trace("Line 70");

		for (i in 0...weekData().length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			if(FlxG.save.data.antialiasing)
				{
					weekThing.antialiasing = true;
				}
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				trace('locking week ' + i);
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				if(FlxG.save.data.antialiasing)
					{
						lock.antialiasing = true;
					}
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		//add(yellowBG);
		//add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFffffff;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();


		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			bullShit++;
		}

		trace("Line 165");

		changeWeek();

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeWeek(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				switch(curWeek)
				{
					//this shit might show up as an error but it will build, trust me
					case 0:
						grpWeekText.members[curWeek].startFlashing(0xFF3E1D60);
					case 1:
						grpWeekText.members[curWeek].startFlashing(0xFFE23100);
					case 2:
						grpWeekText.members[curWeek].startFlashing(0xFF4B6858);
					case 3:
						grpWeekText.members[curWeek].startFlashing(0xFF8C0800);
				}
				
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData()[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			if (curWeek == 0) {
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxTransitionableState.skipNextTransIn = true;
					LoadingState.loadAndSwitchState(new VideoState('assets/videos/polus1.mp4',new PlayState()));
				});
			}

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

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

	function changeWeek(change:Int = 0):Void 
	{
		curWeek += change;

		if (curWeek >= weekData().length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData().length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();

		for (i in 0...grpWeekText.members.length)
			{
				if(i > curWeek) {
					FlxTween.tween(grpWeekText.members[i], {alpha: 0.3}, 0.1, {ease: FlxEase.expoOut});
				}
				else if(i == curWeek) {
					FlxTween.tween(grpWeekText.members[i], {alpha: 1}, 0.1, {ease: FlxEase.expoOut});
				}
				else if(i < curWeek) {
					FlxTween.tween(grpWeekText.members[i], {alpha: 0}, 0.1, {ease: FlxEase.expoOut});
				}
			}

		grpLocks.forEach(function(lock:FlxSprite)
		{
			if(lock.ID > curWeek) {
				FlxTween.tween(lock, {alpha: 0.3}, 0.1, {ease: FlxEase.expoOut});
			}
			else if(lock.ID == curWeek) {
				FlxTween.tween(lock, {alpha: 1}, 0.1, {ease: FlxEase.expoOut});
			}
			else if(lock.ID < curWeek) {
				FlxTween.tween(lock, {alpha: 0}, 0.1, {ease: FlxEase.expoOut});
			}
		});

		switch(curWeek)
		{
			case 0: 
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

			}
			case 1:
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

				var currentNuts:Int = 0; // i love testicle among s!

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
				reactorTween = FlxTween.tween(reactor,{y: 100}, 0.6 ,{ease: FlxEase.expoIn});
				ballerTween = FlxTween.tween(baller,{y: 1000}, 0.8 ,{ease: FlxEase.expoIn});
				defeatTween = FlxTween.tween(defeatScroll,{y: 937}, 3 ,{ease: FlxEase.expoOut});

				effectTween = FlxTween.num(15, MosaicEffect.DEFAULT_STRENGTH, 0.5, {type: ONESHOT}, function(v)
				{
					effect.setStrength(v, v);
				});
				FlxTween.tween(bgSky, {alpha: 1}, 0.4, {ease: FlxEase.expoOut});
				
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
				defeatTween = FlxTween.tween(defeatScroll,{y: -2050}, 3 ,{ease: FlxEase.expoOut});

				effectTween = FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 15, 0.5, {type: ONESHOT}, function(v)
				{
					effect.setStrength(v, v);
				});
				FlxTween.tween(bgSky, {alpha: 0}, 0.4, {ease: FlxEase.expoIn});

			}
		}

		
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData()[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	public static function unlockNextWeek(week:Int):Void
	{
		if(week <= weekData().length - 1 && FlxG.save.data.weekUnlocked == week)
		{
			weekUnlocked.push(true);
			trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}

		FlxG.save.data.weekUnlocked = weekUnlocked.length - 1;
		FlxG.save.flush();
	}

	override function beatHit()
	{
		super.beatHit();

		grpWeekCharacters.members[0].bopHead();
		grpWeekCharacters.members[1].bopHead();
		grpWeekCharacters.members[2].bopHead();
	}
}
