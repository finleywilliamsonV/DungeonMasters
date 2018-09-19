package {

	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Sound;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	public class GlobalSounds {

		private static var _instance: GlobalSounds;
		private static var _allowInstantiation: Boolean;
		
		
		private static const NUMBER_OF_SOUNDS: int = 63;

		// declare sounds

		private static var _sfxSoundChannel: SoundChannel;
		private static var _bgmSoundChannel: SoundChannel;
		private static var _soundArray: Array;
		private static var _hasSound: Boolean;

		private static var _100: SoundTransform;
		private static var _85: SoundTransform;
		private static var _75: SoundTransform;
		private static var _66: SoundTransform;
		private static var _50: SoundTransform;
		private static var _25: SoundTransform;
		private static var _10: SoundTransform;
		private static var _MUTE: SoundTransform;

		private static var _bgm_Dark: BGM_Dark;

		private static var _swing_1: SFX_Swing; // 0
		private static var _swing_2: SFX_Swing_2; // 1
		private static var _swing_3: SFX_Swing_3; // 2

		private static var _ouch_monster_1: SFX_Ouch_Monster_1; // 3
		private static var _ouch_monster_2: SFX_Ouch_Monster_2; // 4
		private static var _ouch_monster_3: SFX_Ouch_Monster_3; // 5

		private static var _doorOpen_1: SFX_DoorOpen_1; // 6
		private static var _doorClose_1: SFX_DoorClose_1; // 7

		private static var _enterDungeon_ADV_1: SFX_EnterDungeon_ADV; // 8
		private static var _enterDungeon_ADV_2: SFX_EnterDungeon_ADV_2; // 9
		private static var _enterDungeon_ADV_3: SFX_EnterDungeon_ADV_3; // 10

		private static var _spell_1: SFX_Spell_1; // 11
		private static var _spell_2: SFX_Spell_2; // 12
		private static var _spell_3: SFX_Spell_3; // 13
		private static var _spell_4: SFX_Spell_4; // 14
		private static var _spell_5: SFX_Spell_5; // 15

		//	-	-	-	-	-	-	-	-	-

		private static var _metalClang_1: SFX_MetalClang_1; // 16
		private static var _metalClang_2: SFX_MetalClang_2; // 17
		private static var _metalClang_3: SFX_MetalClang_3; // 18

		private static var _bang_1: SFX_Bang_1; // 19
		private static var _bang_2: SFX_Bang_2; // 20
		private static var _bang_3: SFX_Bang_3; // 21

		private static var _bow: SFX_Bow; // 22
		private static var _wobble: SFX_Wobble; // 23

		private static var _fire: SFX_Fire; // 24
		private static var _ice: SFX_Ice; // 25
		private static var _magicMissile: SFX_MagicMissile; // 26
		private static var _rock: SFX_Rock; // 27
		private static var _electric: SFX_Electric; // 29
		private static var _water: SFX_Water; // 28

		private static var _heal: SFX_Heal; // 30

		private static var _shuriken: SFX_Shuriken; // 31
		private static var _wind: SFX_Wind; // 32

		private static var _bat: SFX_Bat; // 33
		private static var _bird: SFX_Bird; // 34
		private static var _buzz: SFX_Buzz; // 35
		private static var _dog: SFX_Dog; // 36
		private static var _duck: SFX_Duck; // 37
		private static var _eeeeeGrowl: SFX_EeeeeGrowl; // 38
		private static var _horse: SFX_Horse; // 39
		private static var _lion: SFX_Lion; // 40
		private static var _lowGrowl: SFX_LowGrowl; // 41
		private static var _lowGrowl_2: SFX_LowGrowl_2; // 42
		private static var _lowWooGrowl: SFX_LowWooGrowl; // 43
		private static var _mediumGrowl: SFX_MediumGrowl; // 44
		private static var _shortGrowlOrc: SFX_ShortGrowlOrc; // 45
		private static var _squawk: SFX_Squack; // 46
		private static var _tweet: SFX_Tweet; // 47
		private static var _weirdBird: SFX_WeirdBird; // 48

		private static var _trapTriggered: SFX_TrapTriggered; // 49

		private static var _femaleHey: SFX_FemaleHey; // 50
		private static var _femaleHuh: SFX_FemaleHuh; // 51
		private static var _femaleHiyah: SFX_FemaleHiyah; // 52
		private static var _femaleDeath_1: SFX_Female_Death_1; // 53
		private static var _femaleDeath_2: SFX_Female_Death_2; // 54

		private static var _maleHey: SFX_MaleHey; // 55
		private static var _maleHuh: SFX_MaleHuh; // 56
		private static var _maleHiyah: SFX_MaleHiyah; // 57
		private static var _maleDeath_1: SFX_Male_Death_1; // 58
		private static var _maleDeath_2: SFX_Male_Death_2; // 59
		
		private static var _click: SFX_Click; // 60
		
		private static var _redButton_Down: SFX_RedButton_Down; // 61
		private static var _redButton_Up: SFX_RedButton_Up; // 62
		
		private static var _notorietyLevelUp: SFX_NotorietyLevelUp; // 63

		private static var _isMuted_SFX: Boolean;
		private static var _isMuted_Music: Boolean;


		private static var _songPosition: Number;

		private var _soundTimer: Timer;





		public static function get instance(): GlobalSounds {

			if (!_instance) {

				// instantiate instance
				_allowInstantiation = true;
				_instance = new GlobalSounds();
				_allowInstantiation = false;
				
				_isMuted_Music = GlobalSharedObject.instance.isMutedMusic;
				_isMuted_SFX = GlobalSharedObject.instance.isMutedSFX;
			}

			return _instance;
		}

		private function onTick(tE: TimerEvent): void {
			playAllSounds();
		}

		public function get songPosition(): Number {
			return _songPosition;
		}

		public function set songPosition(newPosition: Number): void {
			_songPosition = newPosition;
		}

		public function get bgmSoundChannel(): SoundChannel {
			return _bgmSoundChannel;
		}

		public function get sfxSoundChannel(): SoundChannel {
			return _sfxSoundChannel;
		}

		public function setMuted_SFX(tf: Boolean): void {
			_isMuted_SFX = tf;
			GlobalSharedObject.instance.isMutedSFX = tf;
		}

		public function setMuted_Music(tf: Boolean): void {
			_isMuted_Music = tf;

			//trace("Song Position on setMuted_Music: " + _bgmSoundChannel.position);

			////trace("\nSetMuted_Music Called:");

			if (_isMuted_Music) {
				_bgmSoundChannel.soundTransform = _MUTE;
				////trace("BGM muted\n");

			} else {
				_bgmSoundChannel.soundTransform = _50;
				////trace("BGM unmuted\n");
			}
			
			GlobalSharedObject.instance.isMutedMusic = tf;
		}

		public function toggleMuted_Music(): void {

			//trace("Song Position on setMuted_Music: " + _bgmSoundChannel.position);

			////trace("\nSetMuted_Music Called:");

			if (_isMuted_Music == false) {
				_bgmSoundChannel.soundTransform = _MUTE;
				////trace("BGM muted\n");
				_isMuted_Music = true;
				GlobalSharedObject.instance.isMutedMusic = true;

			} else {
				_bgmSoundChannel.soundTransform = _50;
				////trace("BGM unmuted\n");
				_isMuted_Music = false;
				GlobalSharedObject.instance.isMutedMusic = false;
			}
		}

		public function get isMuted_Music(): Boolean {
			return _isMuted_Music;
		}

		public function get isMuted_SFX(): Boolean {
			return _isMuted_SFX;
		}

		public function setSound(which: int): void {
			
			if (which == -1) return;
			
			_soundArray[which] = true;
			_hasSound = true;
		}

		public function playSound(which: int): void {

			if (which == -1) return;

			setSound(which);
			playAllSounds();
		}

		public function playBGM(): void {

			//if (!_isMuted_Music){

			////trace("playBGM");
			////trace(_isMuted_Music);
			////trace(_songPosition);

			// android!
			//_bgmSoundChannel = _bgm_short.play(_songPosition,1,_66);
			//_bgmSoundChannel = _bgm_short.play(0,1,_75);

			//_bgmSoundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete);


			// !!!!!!

			_bgmSoundChannel = _bgm_Dark.play(0, 99999, _50); //FIND IT THIS IS COMMENTED OUT!!!

			setMuted_Music(_isMuted_Music);


			// android!
			//bgmSoundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);


			//}

		}

		private function soundComplete(e: Event): void {
			////trace("soundComplete");
			_bgmSoundChannel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			_songPosition = 0;
			playBGM();
		}

		public function stopAll(): void {
			_sfxSoundChannel.stop();
			_bgmSoundChannel.stop();
		}

		/*public function click() : void {
			setSound(14);
			playAllSounds();
		}
		
		public function ouch() : void {
			setSound(1 + int(Math.random() * 6) + 7);
		}*/

		public function randomSwing(): void {
			setSound(int(Math.random() * 3));
		}

		public function randomOuch_Monster(): void {
			setSound(int(Math.random() * 3) + 3);
		}

		public function randomBang(): void {
			//trace("RANDOM BANG");
			var randSound: int = Math.random() * 3;
			if (randSound == 0) {
				playHelper(19, _bang_1, _50);
				//trace("PLAYING: _bang_1");
			} else if (randSound == 1) {
				playHelper(20, _bang_2, _50);
				//trace("PLAYING: _bang_2");
			} else {
				playHelper(21, _bang_3, _25);
				//trace("PLAYING: _bang_3");
			}
		}

		public function randomClang(): void {
			//trace("RANDOM CLANG");
			var randSound: int = Math.random() * 3;
			if (randSound == 0) {
				playHelper(16, _metalClang_1, _50);
				//trace("PLAYING: _metalClang_1");
			} else if (randSound == 1) {
				playHelper(17, _metalClang_2, _50);
				//trace("PLAYING: _metalClang_2");
			} else {
				playHelper(18, _metalClang_3, _50);
				//trace("PLAYING: _metalClang_3");
			}
		}

		public function enterDungeon_ADV(adv: Adventurer): void {
			if (adv.sex == GlobalVariables.SEX_FEMALE) {
				setSound(int(Math.random() * 3) + 50);
			} else {
				setSound(int(Math.random() * 3) + 55);
			}
		}

		public function die_ADV(adv: Adventurer): void {
			if (adv.sex == GlobalVariables.SEX_FEMALE) {
				setSound(int(Math.random() * 2) + 53);
			} else {
				setSound(int(Math.random() * 2) + 58);
			}
		}

		public function enterDungeon(): void {
			setSound(int(Math.random() * 3) + 8);
		}



		// play all sounds
		public function playAllSounds(): void {

			////trace("\nGlobalSounds - Play All Sounds");

			if (_hasSound) {

				// swing
				if (_soundArray[0]) {
					playHelper(0, _swing_1, _75);
					//trace("PLAYING: _swing_1");
				}

				// swing 2
				if (_soundArray[1]) {
					playHelper(1, _swing_2, _75);
					//trace("PLAYING: _swing_2");
				}

				// swing 3
				if (_soundArray[2]) {
					playHelper(2, _swing_3, _75);
					//trace("PLAYING: _swing_3");
				}

				// ouch monster 1
				if (_soundArray[3]) {
					playHelper(3, _ouch_monster_1, _100);
					//trace("PLAYING: _ouch_monster_1");
				}

				// ouch monster 2
				if (_soundArray[4]) {
					playHelper(4, _ouch_monster_2, _100);
					//trace("PLAYING: _ouch_monster_2");
				}

				// ouch monster 3
				if (_soundArray[5]) {
					playHelper(5, _ouch_monster_3, _100);
					//trace("PLAYING: _ouch_monster_3");
				}

				// door open 1
				if (_soundArray[6]) {
					playHelper(6, _doorOpen_1, _25);
					//trace("PLAYING: _doorOpen_1");
				}

				// door close 1
				if (_soundArray[7]) {
					playHelper(7, _doorClose_1, _25);
					//trace("PLAYING: _doorClose_1");
				}

				// adv enter 1
				if (_soundArray[8]) {
					playHelper(8, _enterDungeon_ADV_1, _100);
					//trace("PLAYING: _enterDungeon_ADV_1");
				}

				// adv enter 2
				if (_soundArray[9]) {
					playHelper(9, _enterDungeon_ADV_2, _100);
					//trace("PLAYING: _enterDungeon_ADV_2");
				}

				// adv enter 3
				if (_soundArray[10]) {
					playHelper(10, _enterDungeon_ADV_3, _100);
					//trace("PLAYING: _enterDungeon_ADV_3");
				}

				// spell - 1
				if (_soundArray[11]) {
					playHelper(11, _spell_1, _100);
					//trace("PLAYING: _spell_1");
				}

				// spell - 2
				if (_soundArray[12]) {
					playHelper(12, _spell_2, _100);
					//trace("PLAYING: _spell_2");
				}

				// spell - 3
				if (_soundArray[13]) {
					playHelper(13, _spell_3, _100);
					//trace("PLAYING: _spell_3");
				}

				// spell - 4
				if (_soundArray[14]) {
					playHelper(14, _spell_4, _100);
					//trace("PLAYING: _spell_4");
				}

				// spell - 5
				if (_soundArray[15]) {
					playHelper(15, _spell_5, _100);
					//trace("PLAYING: _spell_5");
				}

				// metal clang 1
				if (_soundArray[16]) {
					randomClang();
					_soundArray[16] = false;
				}

				// _metalClang_2
				if (_soundArray[17]) {
					randomClang();
					_soundArray[16] = false;
				}

				// _metalClang_3
				if (_soundArray[18]) {
					randomClang();
					_soundArray[16] = false;
				}


				//// all bangs
				//if (_soundArray[19] || _soundArray[20] || _soundArray[21]) {
				//	var randSound: int = Math.random() * 3;
				//	if (randSound == 0) {
				//		playHelper(19, _bang_1, _50);
				//		//trace("PLAYING: _bang_1");
				//	} else if (randSound == 1) {
				//		playHelper(20, _bang_2, _50);
				//		//trace("PLAYING: _bang_2");
				//	} else {
				//		playHelper(21, _bang_3, _25);
				//		//trace("PLAYING: _bang_3");
				//	}
				//}

				//_bang_1
				if (_soundArray[19]) {
					randomBang();
					_soundArray[19] = false;
				}

				//_bang_2
				if (_soundArray[20]) {
					randomBang();
					_soundArray[20] = false;
				}

				//_bang_3
				if (_soundArray[21]) {
					randomBang();
					_soundArray[21] = false;
				}

				//_bow
				if (_soundArray[22]) {
					playHelper(22, _bow, _66);
					//trace("PLAYING: _bow");
				}

				//_wobble
				if (_soundArray[23]) {
					playHelper(23, _wobble, _100);
					//trace("PLAYING: _wobble");
				}

				//_fire
				if (_soundArray[24]) {
					playHelper(24, _fire, _100);
					//trace("PLAYING: _fire");
				}

				//_ice
				if (_soundArray[25]) {
					playHelper(25, _ice, _100);
					//trace("PLAYING: _ice");
				}

				//_magicMissile
				if (_soundArray[26]) {
					playHelper(26, _magicMissile, _66);
					//trace("PLAYING: _magicMissile");
				}

				//_rock
				if (_soundArray[27]) {
					playHelper(27, _rock, _100);
					//trace("PLAYING: _rock");
				}

				//_water
				if (_soundArray[28]) {
					playHelper(28, _water, _100);
					//trace("PLAYING: _water");
				}

				//_electric
				if (_soundArray[29]) {
					playHelper(29, _electric, _100);
					//trace("PLAYING: _electric");
				}

				//_heal
				if (_soundArray[30]) {
					playHelper(30, _heal, _100);
					//trace("PLAYING: _heal");
				}

				//_shuriken
				if (_soundArray[31]) {
					playHelper(31, _shuriken, _100);
					//trace("PLAYING: _shuriken");
				}

				//_wind
				if (_soundArray[32]) {
					playHelper(32, _wind, _100);
					//trace("PLAYING: _wind");
				}

				//_bat
				if (_soundArray[33]) {
					playHelper(33, _bat, _25);
					//trace("PLAYING:_bat ");
				}

				//_bird
				if (_soundArray[34]) {
					playHelper(34, _bird, _100);
					//trace("PLAYING: _bird");
				}

				//_buzz
				if (_soundArray[35]) {
					playHelper(35, _buzz, _100);
					//trace("PLAYING: _buzz");
				}

				//_dog
				if (_soundArray[36]) {
					playHelper(36, _dog, _100);
					//trace("PLAYING: _dog");
				}

				//_duck
				if (_soundArray[37]) {
					playHelper(37, _duck, _100);
					//trace("PLAYING: _duck");
				}

				//_eeeeeGrowl
				if (_soundArray[38]) {
					playHelper(38, _eeeeeGrowl, _100);
					//trace("PLAYING: _eeeeeGrowl");
				}

				//_horse
				if (_soundArray[39]) {
					playHelper(39, _horse, _100);
					//trace("PLAYING: _horse");
				}

				//_lion
				if (_soundArray[40]) {
					playHelper(40, _lion, _100);
					//trace("PLAYING: _lion");
				}

				//_lowGrowl
				if (_soundArray[41]) {
					playHelper(41, _lowGrowl, _100);
					//trace("PLAYING: _lowGrowl");
				}

				//_lowGrowl_2
				if (_soundArray[42]) {
					playHelper(42, _lowGrowl_2, _100);
					//trace("PLAYING: _lowGrowl_2");
				}

				//_lowWooGrowl
				if (_soundArray[43]) {
					playHelper(43, _lowWooGrowl, _100);
					//trace("PLAYING: _lowWooGrowl");
				}

				//_mediumGrowl
				if (_soundArray[44]) {
					playHelper(44, _mediumGrowl, _100);
					//trace("PLAYING: _mediumGrowl");
				}

				//_shortGrowlOrc
				if (_soundArray[45]) {
					playHelper(45, _shortGrowlOrc, _100);
					//trace("PLAYING: _shortGrowlOrc");
				}

				//_squawk
				if (_soundArray[46]) {
					playHelper(46, _squawk, _100);
					//trace("PLAYING: _squawk");
				}

				//_tweet
				if (_soundArray[47]) {
					playHelper(47, _tweet, _100);
					//trace("PLAYING: _tweet");
				}

				//_weirdBird
				if (_soundArray[48]) {
					playHelper(48, _weirdBird, _100);
					//trace("PLAYING: _weirdBird");
				}

				//_trapTriggered
				if (_soundArray[49]) {
					playHelper(49, _trapTriggered, _50);
					//trace("PLAYING: _trapTriggered");
				}

				//	_femaleHey
				if (_soundArray[50]) {
					playHelper(50, _femaleHey, _100);
					//trace("PLAYING: _femaleHey");
				}

				//_femaleHuh
				if (_soundArray[51]) {
					playHelper(51, _femaleHuh, _100);
					//trace("PLAYING: _femaleHuh");
				}

				//_femaleHiyah
				if (_soundArray[52]) {
					playHelper(52, _femaleHiyah, _100);
					//trace("PLAYING: _femaleHiyah");
				}

				//_femaleDeath_1
				if (_soundArray[53]) {
					playHelper(53, _femaleDeath_1, _100);
					//trace("PLAYING: _femaleDeath_1");
				}

				//_femaleDeath_2
				if (_soundArray[54]) {
					playHelper(54, _femaleDeath_2, _100);
					//trace("PLAYING: _femaleDeath_2");
				}

				//_maleHey
				if (_soundArray[55]) {
					playHelper(55, _maleHey, _100);
					//trace("PLAYING:_maleHey ");
				}

				//_maleHuh
				if (_soundArray[56]) {
					playHelper(56, _maleHuh, _100);
					//trace("PLAYING: _maleHuh");
				}

				//_maleHiyah
				if (_soundArray[57]) {
					playHelper(57, _maleHiyah, _100);
					//trace("PLAYING: _maleHiyah");
				}

				//_maleDeath_1
				if (_soundArray[58]) {
					playHelper(58, _maleDeath_1, _100);
					//trace("PLAYING: _maleDeath_1");
				}

				//_maleDeath_2
				if (_soundArray[59]) {
					playHelper(59, _maleDeath_2, _100);
					//trace("PLAYING: _maleDeath_2");
				}

				//_click
				if (_soundArray[60]) {
					playHelper(60, _click, _75);
					//trace("PLAYING: _click");
				}

				// red button down
				if (_soundArray[61]) {
					playHelper(61, _redButton_Down, _100);
					//trace("PLAYING: _click");
				}

				// red button up
				if (_soundArray[62]) {
					playHelper(62, _redButton_Up, _100);
					//trace("PLAYING: _click");
				}


				// _notorietyLevelUp
				if (_soundArray[63]) {
					playHelper(63, _notorietyLevelUp, _75);
					//trace("PLAYING: _click");
				}


				/*
				
				//
				if (_soundArray[]) {
					playHelper(, , _100);
					//trace("PLAYING: ");
				}

				*/


				_hasSound = false;
			}

		}
		
		public function click():void {
			setSound(60);
		}

		private function playHelper(index: int, sound: * , sT: SoundTransform) {
			if (!(_isMuted_SFX)) {
				_sfxSoundChannel = sound.play(0, 0, sT); // can be simplified if sounds are at the appropriate volume
			}
			_soundArray[index] = false;
		}

		// singleton constructor - unused
		public function GlobalSounds() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}

			// song position
			_songPosition = 0;

			// instantiate sound array, transform
			_soundArray = new Array();

			for (var i: int = 0; i < NUMBER_OF_SOUNDS; i++) {
				_soundArray.push(false);
			}
			_hasSound = false;

			_100 = new SoundTransform(1, 0);
			_85 = new SoundTransform(.85, 0);
			_75 = new SoundTransform(.75, 0);
			_66 = new SoundTransform(.66, 0);
			_50 = new SoundTransform(.5, 0);
			_25 = new SoundTransform(.25, 0);
			_10 = new SoundTransform(.1, 0);
			_MUTE = new SoundTransform(0, 0);


			// instantiate sound timer
			_soundTimer = new Timer(25);
			_soundTimer.addEventListener(TimerEvent.TIMER, onTick);
			_soundTimer.start();

			// instantiate bgm
			_bgm_Dark = new BGM_Dark();

			// instantiate sound fx
			_swing_1 = new SFX_Swing();
			_swing_2 = new SFX_Swing_2();
			_swing_3 = new SFX_Swing_3();

			_ouch_monster_1 = new SFX_Ouch_Monster_1();
			_ouch_monster_2 = new SFX_Ouch_Monster_2();
			_ouch_monster_3 = new SFX_Ouch_Monster_3();

			_doorOpen_1 = new SFX_DoorOpen_1();
			_doorClose_1 = new SFX_DoorClose_1();

			_enterDungeon_ADV_1 = new SFX_EnterDungeon_ADV();
			_enterDungeon_ADV_2 = new SFX_EnterDungeon_ADV_2();
			_enterDungeon_ADV_3 = new SFX_EnterDungeon_ADV_3();

			_spell_1 = new SFX_Spell_1();
			_spell_2 = new SFX_Spell_2();
			_spell_3 = new SFX_Spell_3();
			_spell_4 = new SFX_Spell_4();
			_spell_5 = new SFX_Spell_5();

			_metalClang_1 = new SFX_MetalClang_1();
			_metalClang_2 = new SFX_MetalClang_2();
			_metalClang_3 = new SFX_MetalClang_3();

			_bang_1 = new SFX_Bang_1();
			_bang_2 = new SFX_Bang_2();
			_bang_3 = new SFX_Bang_3();

			_bow = new SFX_Bow();
			_wobble = new SFX_Wobble();

			_fire = new SFX_Fire();
			_ice = new SFX_Ice();
			_magicMissile = new SFX_MagicMissile();
			_rock = new SFX_Rock();
			_water = new SFX_Water();
			_electric = new SFX_Electric();

			_heal = new SFX_Heal();

			_shuriken = new SFX_Shuriken();
			_wind = new SFX_Wind();

			_bat = new SFX_Bat();
			_bird = new SFX_Bird();
			_buzz = new SFX_Buzz();
			_dog = new SFX_Dog();
			_duck = new SFX_Duck();
			_eeeeeGrowl = new SFX_EeeeeGrowl();
			_horse = new SFX_Horse();
			_lion = new SFX_Lion();
			_lowGrowl = new SFX_LowGrowl();
			_lowGrowl_2 = new SFX_LowGrowl_2();
			_lowWooGrowl = new SFX_LowWooGrowl();
			_mediumGrowl = new SFX_MediumGrowl();
			_shortGrowlOrc = new SFX_ShortGrowlOrc();
			_squawk = new SFX_Squack();
			_tweet = new SFX_Tweet();
			_weirdBird = new SFX_WeirdBird();

			_trapTriggered = new SFX_TrapTriggered();

			_femaleHey = new SFX_FemaleHey();
			_femaleHuh = new SFX_FemaleHuh();
			_femaleHiyah = new SFX_FemaleHiyah();
			_femaleDeath_1 = new SFX_Female_Death_1();
			_femaleDeath_2 = new SFX_Female_Death_2();

			_maleHey = new SFX_MaleHey();
			_maleHuh = new SFX_MaleHuh();
			_maleHiyah = new SFX_MaleHiyah();
			_maleDeath_1 = new SFX_Male_Death_1();
			_maleDeath_2 = new SFX_Male_Death_2();
			
			_click = new SFX_Click();
			
			_redButton_Down = new SFX_RedButton_Down();
			_redButton_Up = new SFX_RedButton_Up();
			
			_notorietyLevelUp = new SFX_NotorietyLevelUp();

			// mute feature
			_isMuted_SFX = false;
			_isMuted_Music = false;
		}

	}

}