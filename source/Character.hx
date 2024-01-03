package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var playerColor:String = "31B0D1";

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var holdState:Bool = false;

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		if(FlxG.save.data.antialiasing)
			{
				antialiasing = true;
			}

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				animation.addByPrefix('die', 'gf DIES', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gfr':
				// GIRLFRIEND CODE 2
				tex = Paths.getSparrowAtlas('gf_reactor','shared',true);
				frames = tex;
				animation.addByIndices('sad', 'gf cry', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByPrefix('danceLeft', 'gf dance left', 24, false);
				animation.addByPrefix('danceRight', 'gf dance right', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');


			case 'gfparachute':
				tex = Paths.getSparrowAtlas('characters/gffall');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);



				addOffset('sad', -2, -21);
				addOffset('danceLeft', 260, -9);
				addOffset('danceRight', 260, -9);

		
				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('ghostgf','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'gf cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'gf idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'gf idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('gf_reactor','shared',true);
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
				

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('gfPixel','shared',true);
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('spooky_kids_assets','shared',true);
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('Mom_Assets','shared',true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('momCar','shared',true);
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('Monster_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('monsterChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('Pico_FNF_assetss','shared',true);
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared',true);
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -48, 27);
				addOffset("singRIGHT", -52, -5);
				addOffset("singLEFT", 6, -7);
				addOffset("singDOWN", -22, -51);
				addOffset("singUPmiss", -36, 27);
				addOffset("singRIGHTmiss", -44, 22);
				addOffset("singLEFTmiss", 7, 19);
				addOffset("singDOWNmiss", -15, -19);
				addOffset("hey", -3, 5);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
			
			case 'bfclow':
				var tex = Paths.getSparrowAtlas('clowfoesn','shared',true);
				playerColor = "CF1F6C";
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'clowfoe idle', 28, false);
				animation.addByPrefix('singUP', 'clowfoe up', 28, false);
				animation.addByPrefix('singLEFT', 'clowfoe left', 28, false);
				animation.addByPrefix('singRIGHT', 'clowfoe right', 28, false);
				animation.addByPrefix('singDOWN', 'clowfoe down', 28, false);
				animation.addByPrefix('singLEFTmiss', 'clowfoe miss left', 28, false);
				animation.addByPrefix('singDOWNmiss', 'clowfoe miss down', 28, false);
				animation.addByPrefix('singUPmiss', 'clowfoe miss up', 28, false);
				animation.addByPrefix('singRIGHTmiss', 'clowfoe miss right', 28, false);
				animation.addByPrefix('firstDeath', 'clowfoe retry die', 28, false);
				animation.addByPrefix('deathLoop', 'clowfoe retry loop', 28, false);
				animation.addByPrefix('deathConfirm', 'clowfoe retry press', 28, false);

				addOffset('idle', -5, 210);
				addOffset("singUP", -5, 229);
				addOffset("singRIGHT", -5, 227);
				addOffset("singLEFT", -5, 224);
				addOffset("singDOWN", -5, 180);
				addOffset("singLEFTmiss", -5, 221);
				addOffset("singDOWNmiss", -5, 188);
				addOffset("singUPmiss", -5, 229);
				addOffset("singRIGHTmiss", -5, 227);
				addOffset("firstDeath", 379, 191);
				addOffset("deathLoop", 379, 158);
				addOffset("deathConfirm", 379, 167);

				playAnim('idle');

				flipX = true;
			case 'bf-defeat-death':
				var tex = Paths.getSparrowAtlas('bf_defeat_death','impostor',true);
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 11);
				addOffset('deathConfirm', 37, 59);
	
				flipX = true;
					
			case 'bf-defeat-secret':
				var tex = Paths.getSparrowAtlas('bf_defeat_death_balls','impostor',true);
				frames = tex;
	
				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addOffset('idle', -5);
				addOffset('firstDeath', 823, 37);
				addOffset('deathLoop', 37, 11);
				addOffset('deathConfirm', 37, 75);
	
				flipX = true;
			
			case 'bfr':
				var tex = Paths.getSparrowAtlas('characters/bfr', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -48, 27);
				addOffset("singRIGHT", -52, -5);
				addOffset("singLEFT", 6, -7);
				addOffset("singDOWN", -22, -51);
				addOffset("singUPmiss", -36, 27);
				addOffset("singRIGHTmiss", -44, 22);
				addOffset("singLEFTmiss", 7, 19);
				addOffset("singDOWNmiss", -15, -19);

				playAnim('idle');

				flipX = true;

			case 'bfg':
				var tex = Paths.getSparrowAtlas('characters/bfghost');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'bf-fall':
				var tex = Paths.getSparrowAtlas('characters/bfFly', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'MISS 2up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MISS 0left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MISS 3right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MISS 1down', 24, false);

				animation.addByPrefix('firstDeath', "dead 0START", 24, false);
				animation.addByPrefix('deathLoop', "dead 1MID", 24, true);
				animation.addByPrefix('deathConfirm', "dead 2END", 24, false);



				addOffset('idle', -5);
				addOffset("singUP", -66, 59);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 1, -1);
				addOffset("singDOWN", 8, -37);
				addOffset("singUPmiss", -36, 27);
				addOffset("singRIGHTmiss", -44, 22);
				addOffset("singLEFTmiss", -18, 9);
				addOffset("singDOWNmiss", -15, -19);
				addOffset('firstDeath', 636, 254);
				addOffset('deathLoop', 636, -288);
				addOffset('deathConfirm', 636, -171);

				playAnim('idle');

				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('bfChristmas','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'bfeyes':
				playerColor = "FFFFFF";
				var tex = Paths.getSparrowAtlas('whitebf','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -48, 27);
				addOffset("singRIGHT", -52, -5);
				addOffset("singLEFT", 6, -7);
				addOffset("singDOWN", -22, -51);
				addOffset("singUPmiss", -36, 27);
				addOffset("singRIGHTmiss", -44, 22);
				addOffset("singLEFTmiss", 7, 19);
				addOffset("singDOWNmiss", -15, -19);

				playAnim('idle');

				flipX = true;	
			
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				playerColor = "7BD6F6";
				frames = Paths.getSparrowAtlas('bfPixel','shared',true);
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missdown', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-sus':
				playerColor = "7BD6F6";
				frames = Paths.getSparrowAtlas('bfSus','shared',true);
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missdown', 24, false);
				animation.addByPrefix('shoot', 'shoot', 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('bfPixelsDEAD','shared',true);
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, false);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				loadOffsetFile(curCharacter);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('senpai','shared',true);
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'tomongus':
				playerColor = "FF6770";
				frames = Paths.getSparrowAtlas('tomongus','shared',true);
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('huh', 'huh', 24, false);


				addOffset("idle", 250, 0);
				addOffset("singUP", 250, 0);
				addOffset("singRIGHT", 250, 0);
				addOffset("singLEFT", 250, 0);
				addOffset("singDOWN", 250, 0);
				addOffset("huh", 250, 0);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'hamster':
				playerColor = "FFCF86";
				frames = Paths.getSparrowAtlas('hamster','shared',true);
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);

				addOffset("idle", 250, 0);
				addOffset("singUP", 250, 0);
				addOffset("singRIGHT", 250, 0);
				addOffset("singLEFT", 250, 0);
				addOffset("singDOWN", 250, 0);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('senpai','shared',true);
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('spirit','shared',false);
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				loadOffsetFile(curCharacter);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('mom_dad_christmas_assets','shared',true);
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'impostor':
				// inky is a god
				playerColor = "BB2D30";
				tex = Paths.getSparrowAtlas('characters/impostor', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				addOffset('idle', 80, -20);
				addOffset("singUP", -16, 16);
				addOffset("singRIGHT", -73, -44);
				addOffset("singLEFT", 248, -35);
				addOffset("singDOWN", 40, 15);

				playAnim('idle');

			case 'sabotage':
				// inky is a god
				playerColor = "BB2D30";
				tex = Paths.getSparrowAtlas('characters/impostorS', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'impostor left', 24, false);
				animation.addByPrefix('hey', 'red look', 24, false);

				addOffset('idle', 80, -20);
				addOffset("singUP", -16, 16);
				addOffset("singRIGHT", 17, -41);
				addOffset("singLEFT", 208, -39);
				addOffset("singDOWN", 40, 15);
				addOffset('hey', 82, -20);

				playAnim('idle');

			case 'impostor3':
				// inky is a god
				playerColor = "1F6B2B";
				tex = Paths.getSparrowAtlas('characters/impostor3', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				addOffset('idle', 59, -28);
				addOffset("singUP", 161, 89);
				addOffset("singRIGHT", 59, -44);
				addOffset("singLEFT", 249, -38);
				addOffset("singDOWN", 106, -53);

				playAnim('idle');	

			case 'whiteimpostor':
				playerColor = "000000";
				tex = Paths.getSparrowAtlas('characters/whitegreen', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				addOffset('idle', 59, -28);
				addOffset("singUP", 161, 89);
				addOffset("singRIGHT", 59, -44);
				addOffset("singLEFT", 249, -38);
				addOffset("singDOWN", 106, -53);

				playAnim('idle');	

			case 'impostorr':
				// ethan
				playerColor = "1F6B2B";
				tex = Paths.getSparrowAtlas('characters/impostorr', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				addOffset('idle', 59, -278);
				addOffset("singUP", 161, -161);
				addOffset("singRIGHT", 59, -294);
				addOffset("singLEFT", 249, -288);
				addOffset("singDOWN", 106, -303);

				playAnim('idle');

			case 'parasite':
				playerColor = "003315";
				tex = Paths.getSparrowAtlas('characters/parasite', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle instance 1', 24, true);
				animation.addByPrefix('singUP', 'up instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'right instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'down instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'left instance 1', 24, false);

				addOffset('idle', 322, 140);
				addOffset("singUP", 171, 191);
				addOffset("singRIGHT", 67, -1);
				addOffset("singLEFT", 412, 29);
				addOffset("singDOWN", 187, -110);

				setGraphicSize(Std.int(width * 2));

				playAnim('idle');	

			case 'crewmate':
				// not an impostor
				playerColor = "1F6B2B";
				tex = Paths.getSparrowAtlas('characters/crewmate', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'green idle', 24, false);
				animation.addByPrefix('singUP', 'green up', 24, false);
				animation.addByPrefix('singRIGHT', 'green right', 24, false);
				animation.addByPrefix('singDOWN', 'green down', 24, false);
				animation.addByPrefix('singLEFT', 'green left', 24, false);

				addOffset('idle', -82, 30);
				addOffset("singUP", 61, 154);
				addOffset("singRIGHT", -89, 21);
				addOffset("singLEFT", 164, 34);
				addOffset("singDOWN", 11, 6);

				playAnim('idle');

			case 'impostor2':
				// impostor
				playerColor = "BB2D30";
				tex = Paths.getSparrowAtlas('characters/impostor2', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				addOffset('idle', 70, -29);
				addOffset("singUP", 70, -5);
				addOffset("singRIGHT", 70, -33);
				addOffset("singLEFT", 162, -25);
				addOffset("singDOWN", 70, -97);

				playAnim('idle');

			case 'ziffy':
				// impostor
				playerColor = "FF9933";
				tex = Paths.getSparrowAtlas('characters/ziffyfnf', 'impostor');
				frames = tex;
				animation.addByPrefix('idle', 'ziffy idle', 28, false);
				animation.addByPrefix('singUP', 'ziffy up', 24, false);
				animation.addByPrefix('singRIGHT', 'ziffy right', 28, false);
				animation.addByPrefix('singDOWN', 'ziffy down', 24, false);
				animation.addByPrefix('singLEFT', 'ziffy left', 28, false);

				addOffset('idle', 0, -40);
				addOffset("singUP", 39, -32);
				addOffset("singRIGHT", 3, -63);
				addOffset("singLEFT", 55, -86);
				addOffset("singDOWN", 62, -88);

				playAnim('idle');
				
			case 'black':
				// i hate black people
				playerColor = "3A1B4F";
				tex = Paths.getSparrowAtlas('characters/black', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'black idle remast', 24, true);
				animation.addByPrefix('singUP', 'black up', 24, false);
				animation.addByPrefix('singRIGHT', 'black right', 24, false);
				animation.addByPrefix('singDOWN', 'black down', 24, false);
				animation.addByPrefix('singLEFT', 'black left', 24, false);

				addOffset('idle', 365, 30);
				addOffset("singUP", 684, 135);
				addOffset("singRIGHT", 352, -48);
				addOffset("singLEFT", 580, -27);
				addOffset("singDOWN", 571, 270);

				playAnim('idle');

			case 'blackKill':
				// i hate black people
				playerColor = "3A1B4F";
				tex = Paths.getSparrowAtlas('characters/defeat_death', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'black', 24, true);
				animation.addByPrefix('kill1', 'black kill 1', 24, false);
				animation.addByPrefix('kill2', 'black kill 2', 24, false);
				animation.addByPrefix('kill3', 'black kill 3', 24, false);

				addOffset('idle');
				addOffset("kill1");
				addOffset("kill2", 39, -68);
				addOffset("kill3", 167, 306);

				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gfr' | 'gf-pixel' | 'gfparachute':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
						{
							if(!holdState)
								playAnim('danceRight');
						}else{
							if(!holdState)
								playAnim('danceLeft');
						}
	
					}
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					if(holdState) {
						//nothing
					}
					else {
						playAnim('idle', forced);
					}
			}
		}
	}

	public function changeSheet(newTex:FlxAtlasFrames){
		//okay some important stuff before using this function
		//this is gonna load ONLY the spritesheet
		//so ALL OF THE ANIMATION NAMES MUST BE THE SAME!!!!!!!!!!!
		//also be wary, this function is really complex. we take advantage of quantum physics to make this work. so please be careful!
		frames = newTex;
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function changeHoldState(state:Bool) {
		holdState = state;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
