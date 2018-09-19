package {

	public class Weapons {

		/*
			- maybe add one more var to weapon, --> displayType:int (1-?)
		*/

		private static var _instance: Weapons;
		private static var _allowInstantiation: Boolean;

		private static var _knife: Weapon;
		private static var _sword: Weapon;

		public static function get instance(): Weapons {

			if (!_instance) {
				_allowInstantiation = true;
				_instance = new Weapons();
				_allowInstantiation = false;
			}

			return _instance;
		}

		public function Weapons() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}


		// adv - melee
		public static function get trident(): Weapon {
			return new Weapon("Trident", Anim_Slash_3, false, 1, false, 0, 3, 3, null, 3, 1);
		}
		public static function get knife(): Weapon {
			return new Weapon("Knife", Anim_Slash, false, 1, false, 0, 1, 4, null, 3, 1);
		}
		public static function get dagger(): Weapon {
			return new Weapon("Dagger", Anim_Slash, false, 1, false, 0, 1, 4, null, 3, 1);
		}
		public static function get focusPunch(): Weapon {
			return new Weapon("Focus Punch", Anim_Punch, false, 1, false, 0, 2, 6, null, 12, 20);
		}
		public static function get club(): Weapon {
			return new Weapon("Club", Anim_Bang, false, 1, false, 0, 1, 4, null, 3, 19);
		}
		public static function get staff(): Weapon {
			return new Weapon("Firm Wallop", Anim_Bang, false, 1, false, 0, 1, 3, null, 3, 21);
		}
		public static function get bigHammer(): Weapon {
			return new Weapon("Big Hammer", Anim_Bang, false, 1, false, 0, 6, 2, null, 3,21);
		}
		public static function get sword(): Weapon {
			return new Weapon("Sword", Anim_Slash, false, 1, false, 0, 1, 10, null, 3,16);
		}
		public static function get doubleLongSwords(): Weapon {
			return new Weapon("Double Long Swords", Anim_Slash, false, 1, false, 0, 2, 10, null, 3,17);
		}
		public static function get spear(): Weapon {
			return new Weapon("Spear", Anim_Slash, false, 1, false, 0, 2, 10, null, 3,1);
		}
		public static function get pitchfork(): Weapon {
			return new Weapon("Pitchfork", Anim_Slash, false, 1, false, 0, 1, 3, null, 3, 1);
		}
		public static function get punch(): Weapon {
			return new Weapon("Punch", Anim_Punch, false, 1, false, 0, 1, 2, null, 12, 19);
		}
		public static function get herosAxe(): Weapon {
			return new Weapon("Hero's Axe", Anim_Slash_2, false, 1, false, 0, 2, 12, Statuses.poison_2, 9,18);
		}
		public static function get bigOlSword(): Weapon {
			return new Weapon("Big Ol' Sword", Anim_Slash_2, false, 1, false, 0, 5, 12, Statuses.poison_3, 9,17);
		}
		public static function get bigOlSword_2(): Weapon {
			return new Weapon("Massive Sword", Anim_Slash_2, false, 1, false, 0, 10, 12, Statuses.burn_5, 3,16);
		}
		public static function get swordOfTheDeep(): Weapon {
			return new Weapon("Sword of the Deep", Anim_Slash_3, false, 1, false, 0, 6, 15, Statuses.fear_2, 3,17);
		}
		public static function get bonkNoggin(): Weapon {
			return new Weapon("Bonk Noggin", Anim_Bang, false, 1, false, 0, 1, 8, Statuses.paralyze_1, 3,19);
		}
		public static function get pickAxe(): Weapon {
			return new Weapon("Pick Axe", Anim_Bang, false, 1, false, 0, 5, 6, null, 3,20);
		}
		public static function get deathScythe(): Weapon {
			return new Weapon("Death Scythe", Anim_Slash_3, false, 1, false, 0, 2, 3, Statuses.fear_5, 3,18);
		}
		public static function get swiftBonk(): Weapon {
			return new Weapon("Swift Bonk", Anim_Bang, false, 1, false, 0, 1, 8, null, 3,19);
		}


		// adv - ranged
		public static function get shuriken(): Weapon {
			return new Weapon("Shuriken", Anim_Shuriken, true, 8, false, 0, 2, 3, null, 6,31);
		}
		public static function get bow(): Weapon {
			return new Weapon("Bow", Anim_Arrow, true, 10, false, 0, 1, 6, null, 6,22);
		}
		public static function get throwingKnife(): Weapon {
			return new Weapon("Throwing Knife", Anim_ThrowingKnife, true, 4, false, 0, 1, 6, null, 6,0);
		}
		public static function get poisonArrows(): Weapon {
			return new Weapon("Poison Arrows", Anim_Arrow_Poison, true, 6, false, 0, 1, 6, Statuses.poison_2, 6,22);
		}
		public static function get tossThrone(): Weapon {
			return new Weapon("Toss the Throne", Anim_Throne, true, 6, false, 0, 50, 20, Statuses.confuse_1, 6,31);
		}

		// adv - spells
		public static function get confuseRay(): Weapon {
			return new Weapon("Confuse Ray", Anim_Bolt, true, 5, true, 500, 0, 0, Statuses.confuse_MAX, 13,11);
		}
		public static function get flames(): Weapon {
			return new Weapon("Flames", Anim_Flames_Complex, true, 5, true, 10, 2, 8, null, 11,24);
		}
		public static function get fireBall(): Weapon {
			return new Weapon("Fire Ball", Anim_SmallFireball, true, 6, true, 20, 1, 20, null, 11,24);
		}
		public static function get fireBall_2(): Weapon {
			return new Weapon("Fire Blast", Anim_Fireball, true, 6, true, 20, 10, 20, null, 11,24);
		}
		public static function get iceBlast(): Weapon {
			return new Weapon("Ice Blast", Anim_Snowflake, true, 5, true, 6, 2, 8, Statuses.freeze_2, 10,25);
		}
		public static function get iceBlast_2(): Weapon {
			return new Weapon("Deep Freeze", Anim_Snowflake, true, 5, true, 10, 10, 5, Statuses.freeze_4, 10,25);
		}
		public static function get magicBurst(): Weapon {
			return new Weapon("Magic Burst", Anim_MagicMissile, true, 6, true, 25, 2, 4, null, 5,26);
		}
		public static function get magicMissile(): Weapon {
			return new Weapon("Magic Missile", Anim_MagicMissile, true, 6, true, 25, 12, 4, null, 5,26);
		}
		public static function get tornado(): Weapon {
			return new Weapon("Tornado", Anim_Tornado, true, 6, true, 50, 4, 8, null, 15,32);
		}
		public static function get transmutePotion(): Weapon {
			return new Weapon("Transmute Potion", Anim_Transmute, true, 6, true, 250, 0, 0, Statuses.transmute_2, 14,11);
		}
		public static function get razorGrass(): Weapon {
			return new Weapon("Razor Grass", Anim_RazorGrass, true, 6, true, 50, 30, 3, Statuses.poison_4, 17,0);
		}
		public static function get rockSmash(): Weapon {
			return new Weapon("Rock Smash", Anim_ThrowBoulder, true, 6, true, 100, 3, 30, Statuses.paralyze_4, 20,27);
		}
		public static function get earthRitual(): Weapon {
			return new Weapon("Earth Ritual", Anim_ThrowBoulder, true, 6, true, 100, 6, 30, Statuses.paralyze_4, 20,27);
		}
		public static function get waterRitual(): Weapon {
			return new Weapon("Water Ritual", Anim_HeavyRain, true, 6, true, 100, 6, 30, Statuses.freeze_4, 19,28);
		}
		public static function get windRitual(): Weapon {
			return new Weapon("Wind Ritual", Anim_Tornado_Large, true, 6, true, 100, 6, 30, Statuses.fear_4, 15,32);
		}
		public static function get fireRitual(): Weapon {
			return new Weapon("Fire Ritual", Anim_Fireball, true, 6, true, 100, 6, 30, Statuses.burn_4, 11,24);
		}
		public static function get callOfTheWild(): Weapon {
			return new Weapon("Call of the Wild", Anim_Transmute, true, 6, true, 250, 0, 0, Statuses.transmute_MAX, 14, 11);
		}
		public static function get divineLight(): Weapon {
			return new Weapon("Divine Light", Anim_DivineLight, true, 6, true, 50, 12, 4, null, 5,14);
		}
		public static function get smite(): Weapon {
			return new Weapon("Smite", Anim_Smite, true, 6, true, 100, 12, 12, null, 5,14);
		}
		
		
		// adv - healing 
		public static function get minorHeal(): Weapon {
			return new Weapon("Minor Heal", Anim_Heal, true, 6, true, 25, 6, 6, null, 4, 30);
		}
		public static function get majorHeal(): Weapon {
			return new Weapon("Minor Heal", Anim_Heal, true, 6, true, 50, 12, 6, null, 4, 30);
		}
		public static function get divineGrace(): Weapon {
			return new Weapon("Divine Grace", Anim_Heal, true, 6, true, 200, 300, 1, null, 4, 30);
		}
		public static function get healingHerbs(): Weapon {
			return new Weapon("Healing Herbs", Anim_Heal, true, 6, true, 50, 150, 1, null, 4, 30);
		}
		public static function get blessing(): Weapon {
			return new Weapon("Blessing", Anim_Heal, true, 6, true, 50, 75, 1, null, 4, 30);
		}


		// adv - other
		public static function get kiStrike(): Weapon {
			return new Weapon("Ki Strike", Anim_Punch_Blue, false, 1, true, 20, 3, 10, Statuses.freeze_3, 12,20);
		}
		public static function get throwFood(): Weapon {
			return new Weapon("Throw Food", Anim_Food, true, 6, false, 0, 1, 1, null, 6,0);
		}




		//	-	-	-	-
		// 	MONSTER
		//	-	-	-	-	


		// monster melee
		public static function get beakPinch(): Weapon {
			return new Weapon("Beak Pinch", Anim_Bang, false, 1, false, 0, 3, 3, null, 8,  0);
		}
		public static function get bite(): Weapon {
			return new Weapon("Bite", Anim_Bite, false, 1, false, 0, 1, 8, null, 8,  0);
		}
		public static function get lastResort(): Weapon {
			return new Weapon("Last Resort", Anim_Claws_2, false, 0, false, 0, 3, 6, null, 7,  0);
		}
		public static function get softPaws(): Weapon {
			return new Weapon("Soft Paws", Anim_Claws_2, false, 0, false, 0, 1, 3, null, 7,  0);
		}
		public static function get spreadDisease(): Weapon {
			return new Weapon("Spread Disease", Anim_Bite_2, false, 1, false, 0, 2, 4, Statuses.poison_3, 2,  0);sd
		}
		public static function get chomp(): Weapon {
			return new Weapon("Chomp", Anim_Bite, false, 1, false, 0, 4, 7, null, 8,  0);
		}
		public static function get boneBash(): Weapon {
			return new Weapon("Bone Bash", Anim_Bang, false, 1, false, 0, 3, 3, null, 1,  19);
		}
		public static function get poisonBite(): Weapon {
			return new Weapon("Poison Bite", Anim_Bite_2, false, 1, false, 0, 5, 10, Statuses.poison_2, 2,  0);
		}
		public static function get flailLimbs(): Weapon {
			return new Weapon("Flail Limbs", Anim_Punch_Blue, false, 1, false, 0, 3, 4, Statuses.fear_1, 12, 20);
		}
		public static function get nibble(): Weapon {
			return new Weapon("Nibble", Anim_Bite, false, 1, false, 0, 2, 10, null, 8,  0);
		}
		public static function get tinyFists(): Weapon {
			return new Weapon("Tiny Fists", Anim_Punch, false, 1, false, 0, 1, 30, null, 12,  21);
		}
		public static function get mightyPeck(): Weapon {
			return new Weapon("Mighty Peck", Anim_Bang, false, 1, false, 0, 8, 10, null, 8,  0);
		}
		public static function get sheleighly(): Weapon {
			return new Weapon("Sheleighly", Anim_Bang, false, 1, false, 0, 1, 60, null, 3,  20);
		}
		public static function get stoneFist(): Weapon {
			return new Weapon("Stone Fist", Anim_Punch_Grey, false, 1, false, 0, 6, 10, null, 12,  0);
		}
		public static function get razorClaws(): Weapon {
			return new Weapon("Razor Claws", Anim_Claws_2, false, 1, false, 0, 20, 4, null, 7,  2);
		}
		public static function get halberd(): Weapon {
			return new Weapon("Halberd", Anim_Slash_2, false, 1, false, 0, 10, 5, null, 3,  0);
		}
		public static function get halbird(): Weapon {
			return new Weapon("Hal-Bird", Anim_Slash_3, false, 1, false, 0, 15, 20, null, 3,  0);
		}
		public static function get magicFist(): Weapon {
			return new Weapon("Magic Fist", Anim_Punch_Blue, false, 1, false, 0, 6, 22, null, 12,20);
		}
		public static function get sharpClaws(): Weapon {
			return new Weapon("Sharp Claws", Anim_Claws, false, 1, false, 0, 5, 12, null, 7,  0);
		}
		public static function get scimitar(): Weapon {
			return new Weapon("Scimitar", Anim_Slash_3, false, 1, false, 0, 10, 10, null, 3,  0);
		}
		public static function get oneTonFist(): Weapon {
			return new Weapon("One-Ton Fist", Anim_Bang, false, 1, false, 0, 1, 200, null, 12,  21);
		}
		public static function get razorTallons(): Weapon {
			return new Weapon("Razor Tallons", Anim_Claws, false, 1, false, 0, 3, 20, null, 7,  0);
		}
		public static function get lightningFist(): Weapon {
			return new Weapon("Lightning Fist", Anim_Claws, false, 1, false, 0, 14, 10, Statuses.paralyze_1, 12,  0);
		}
		public static function get poisonFist(): Weapon {
			return new Weapon("Poison Fist", Anim_Punch_Green, false, 1, false, 0, 20, 2, Statuses.poison_2, 12,  0);
		}
		public static function get trample(): Weapon {
			return new Weapon("Toad Trample", Anim_Bang, false, 1, false, 0, 12, 2, Statuses.fear_5, 1,  0);
		}
		public static function get icyTouch(): Weapon {
			return new Weapon("Icy Touch", Anim_Punch_Blue, false, 1, false, 0, 2, 30, Statuses.freeze_2, 10,  25);
		}




		// monster ranged
		public static function get burningSlime(): Weapon {
			return new Weapon("Burning Slime", Anim_BurningSlime, true, 4, false, 0, 2, 3, Statuses.burn_3, 11,14);
		}
		public static function get dirtBall(): Weapon {
			return new Weapon("Dirt Ball", Anim_DirtBall, true, 4, false, 0, 1, 12, null, 20,15);
		}
		public static function get tearsOfSorrow(): Weapon {
			return new Weapon("Tears of Sorrow", Anim_HeavyRain, true, 6, false, 0, 2, 12, null, 6, 28);
		}
		public static function get gust(): Weapon {
			return new Weapon("Gust", Anim_Tornado, true, 4, false, 0, 1, 40, null, 15, 32);
		}
		public static function get acidSpit(): Weapon {
			return new Weapon("Acid Spit", Anim_AcidSpit, true, 4, false, 0, 5, 6, Statuses.poison_4, 2, 12);
		}
		public static function get fireBreath(): Weapon {
			return new Weapon("Fire Breath", Anim_Fireball, true, 5, false, 0, 5, 10, Statuses.burn_4, 11, 24);
		}
		public static function get boulderBarrage(): Weapon {
			return new Weapon("Boulder Barrage", Anim_ThrowBoulder, true, 4, false, 0, 20, 2, Statuses.paralyze_1, 20, 27);
		}
		public static function get vegetation(): Weapon {
			return new Weapon("Vegetation", Anim_Vegetation, true, 5, false, 0, 2, 60, null, 17, 32);
		}
		public static function get endlessThunder(): Weapon {
			return new Weapon("Endless Thunder", Anim_Bolt, true, 4, false, 0, 2, 50, Statuses.paralyze_1, 18, 29);
		}
		public static function get flood(): Weapon {
			return new Weapon("Flood", Anim_HeavyRain, true, 3, false, 0, 8, 4, Statuses.fear_2, 19, 28);
		}



		// monster magic
		public static function get sonar(): Weapon {
			return new Weapon("Sonar", Anim_SoundWave, true, 6, true, 5, 1, 2, Statuses.confuse_5, 16, 12);
		}
		public static function get meanEyes(): Weapon {
			return new Weapon("Mean Eyes", Anim_MeanEyes, true, 4, true, 20, 0, 0, Statuses.fear_4, 1, 11);
		}
		public static function get pester(): Weapon {
			return new Weapon("Pester", Anim_Claws, false, 1, true, 0, 2, 3, null, 12, 0);
		}
		public static function get shootWeb(): Weapon {
			return new Weapon("Shoot Web", Anim_ShootWeb, true, 5, true, 20, 1, 12, Statuses.paralyze_4, 6, 13);
		}
		public static function get poisonGas(): Weapon {
			return new Weapon("Poison Gas", Anim_PoisonGas, true, 4, true, 20, 1, 12, Statuses.poison_3, 2,14);
		}
		public static function get roar(): Weapon {
			return new Weapon("Roar", Anim_SoundWave, true, 5, true, 40, 0, 0, Statuses.fear_5, 1,3);
		}
		public static function get staticShock(): Weapon {
			return new Weapon("Static Shock", Anim_StaticShock, true, 5, true, 500, 0, 0, Statuses.paralyze_MAX, 18,29);
		}
		public static function get moonDust(): Weapon {
			return new Weapon("Moon Dust", Anim_RazorGrass, true, 4, true, 50, 2, 30, Statuses.paralyze_2, 17, 14);
		}
		public static function get confuseRay_2(): Weapon {
			return new Weapon("Confuse Ray", Anim_Bolt, true, 3, true, 500, 0, 0, Statuses.confuse_MAX, 13,11);
		}
		public static function get badWish(): Weapon {
			return new Weapon("Bad Wish", Anim_Bolt, true, 3, true, 300, 0, 0, Statuses.transmute_MAX, 14,23);
		}
		public static function get massiveGust(): Weapon {
			return new Weapon("Massive Gust", Anim_Tornado_Large, true, 6, true, 60, 4, 30, null, 15,32);
		}
		public static function get lastWords(): Weapon {
			return new Weapon("Last Words", Anim_Skull, true, 3, true, 1000, 997, 1, null, 1, 23);
		}
		public static function get deepFreeze(): Weapon {
			return new Weapon("Deep Freeze", Anim_Snowflake, true, 5, true, 150, 3, 30, Statuses.freeze_5, 10, 25);
		}
		public static function get psychosis(): Weapon {
			return new Weapon("Psychosis", Anim_SoundWave, true, 6, true, 2000, 13, 5, Statuses.confuse_MAX, 13,11);
		}
		public static function get forbiddenRitual(): Weapon {
			return new Weapon("Forbidden Ritual", Anim_Transmute, true, 5, true, 650, 0, 0, Statuses.transmute_MAX, 1, 23);
		}
		public static function get eyeRay_Magic(): Weapon {
			return new Weapon("Eye Ray (Magic)", Anim_MagicMissile, true, 6, true, 100, 50, 3, null, 5,26);
		}
		public static function get eyeRay_Fire(): Weapon {
			return new Weapon("Eye Ray (Fire)", Anim_Fireball, true, 6, true, 100, 45, 2, Statuses.burn_2, 11, 24);
		}
		public static function get eyeRay_Ice(): Weapon {
			return new Weapon("Eye Ray (Ice)", Anim_Snowflake, true, 6, true, 100, 10, 5, Statuses.freeze_4, 10, 25);
		}
		public static function get eyeRay_Shock(): Weapon {
			return new Weapon("Eye Ray (Shock)", Anim_Bolt, true, 6, true, 100, 18, 3, Statuses.paralyze_3, 18, 29);
		}



		// monster healing
		public static function get poorHealing(): Weapon {
			return new Weapon("Poor Healing", Anim_Heal, true, 4, true, 60, 4, 10, null, 4, 30);
		}
		public static function get naturalHealing(): Weapon {
			return new Weapon("Natural Healing", Anim_Heal, true, 5, true, 120, 25, 12, null, 4, 30);
		}
		public static function get luckyDay(): Weapon {
			return new Weapon("Lucky Day", Anim_Heal, true, 5, true, 120, 1, 500, null, 4, 30);
		}
		public static function get forgottenRemedies(): Weapon {
			return new Weapon("Forgotten Remedies", Anim_Heal, true, 5, true, 100, 45, 8, null, 4, 30);
		}
		public static function get lastHurrah(): Weapon {
			return new Weapon("Last Hurrah", Anim_Heal, true, 4, true, 80, 200, 1, null, 4, 30);
		}
		public static function get greatHealing(): Weapon {
			return new Weapon("Great Healing", Anim_Heal, true, 6, true, 80, 20, 100, null, 4, 30);
		}
		public static function get energyTransfer(): Weapon {
			return new Weapon("Energy Transfer", Anim_Heal, true, 6, true, 500, 1000, 1, null, 4, 30);
		}




		// trap weapons
		public static function get trap_Spikes(): Weapon {
			return new Weapon("Spikes", null, false, 1, false, 0, 12, 1, null, 3);
		}
		public static function get trap_Spikes_Fire(): Weapon {
			return new Weapon("Fire Spikes", null, false, 1, false, 0, 20, 1, Statuses.burn_2, 11);
		}
		public static function get trap_Spikes_Ice(): Weapon {
			return new Weapon("Ice Spikes", null, false, 1, false, 0, 30, 1, Statuses.freeze_2, 10);
		}

		public static function get trap_Arrow(): Weapon {
			return new Weapon("Arrow", Anim_Arrow, false, 1, false, 0, 10, 1, null, 6);
		}
		public static function get trap_Arrow_Poison(): Weapon {
			return new Weapon("Poison Arrow", Anim_Arrow_Poison, false, 1, false, 0, 12, 1, Statuses.poison_5, 2);
		}
		public static function get trap_Arrow_Paralyze(): Weapon {
			return new Weapon("Paralysis Arrow", Anim_Arrow_Paralyze, false, 1, false, 0, 15, 1, Statuses.paralyze_5, 1);
		}
		public static function get trap_Boulder(): Weapon {
			return new Weapon("Giant Boulder", Boulder, false, 1, false, 0, 1000, 1, Statuses.paralyze_MAX, 20);
		}


		// door weapons
		public static function get door_Ice(): Weapon {
			return new Weapon("Ice Trap", null, false, 1, false, 0, 0, 1, Statuses.freeze_MAX, 10);
		}
		public static function get door_Fire(): Weapon {
			return new Weapon("Fire Trap", null, false, 1, false, 0, 25, 1, Statuses.burn_MAX, 11);
		}
		public static function get door_Confuse(): Weapon {
			return new Weapon("Confuse Trap", null, false, 1, false, 0, 0, 1, Statuses.confuse_MAX, 13);
		}
		public static function get door_Transmute(): Weapon {
			return new Weapon("Transmutation Trap", null, false, 1, false, 0, 0, 1, Statuses.transmute_MAX, 14);
		}
	}
}