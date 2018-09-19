package {

	// idea:
	// get instance
	// set array = []
	// return instance 

	public class DungeonLayouts {

		public static function get empty(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}


		public static function get fullTest01(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			dungeonArray.push(30, 20);

			floorArray.push(15, 9, 5, 4);

			entranceArray.push(15, 4);

			slotArray_Monster.push(8, 8, 6, 6, 11, 11);

			slotArray_Trap.push(15, 5);

			slotArray_Door.push(16, 4);

			//slotArray_Chest.push(6, 11);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

		public static function get fullTest02(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			dungeonArray.push(30, 20);

			floorArray.push(3, 8, 3, 5);
			floorArray.push(10, 1, 6, 12);
			floorArray.push(6, 4, 9, 5);
			floorArray.push(1, 3, 10, 9);
			floorArray.push(7, 1, 14, 6);
			floorArray.push(1, 6, 20, 6);
			floorArray.push(6, 3, 15, 14);
			floorArray.push(1, 3, 20, 11);
			floorArray.push(1, 3, 15, 12);
			floorArray.push(7, 1, 20, 15);
			floorArray.push(1, 10, 27, 6);

			entranceArray.push(27, 6);

			slotArray_Monster.push(19, 14, 16, 16, 4, 9, 10, 7, 12, 6);

			slotArray_Trap.push(22, 15, 16, 6, 7, 12, 12, 12);

			slotArray_Door.push(21, 15, 15, 6, 6, 12, 20, 13, 15, 13);

			//slotArray_Chest.push(4, 6);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

		// dungeon glubmire
		public static function get dungeon_01(): Array {
			var dungeonArray: Array = []; // width, height of dungeon in nodes
			var floorArray: Array = []; // array of width, height, location (x,y) of all floors
			var entranceArray: Array = []; // array of entrances

			var slotArray_Monster: Array = []; // monster slots
			var slotArray_Trap: Array = []; // trap slots
			var slotArray_Door: Array = []; // door slots
			var slotArray_Chest: Array = []; // chest slots

			var decorArray_Floor: Array = []; // floor decor
			var decorArray_Wall: Array = []; // wall decor

			dungeonArray.push(30, 20);

			floorArray.push(6, 8, 3, 5);
			floorArray.push(5, 1, 8, 12);
			floorArray.push(1, 5, 13, 8);

			entranceArray.push(13, 8);

			slotArray_Monster.push(7, 6, 4, 9);
			//slotArray_Trap.push(22,15, 16, 6,7, 12,12,12);
			slotArray_Door.push(13, 11);
			////slotArray_Chest.push(4,6);

			decorArray_Floor.push(3, 12, 1);
			decorArray_Floor.push(4, 12, 2);
			decorArray_Floor.push(3, 11, 3);
			decorArray_Floor.push(4, 5, 4);
			decorArray_Floor.push(3, 5, 5);
			decorArray_Floor.push(5, 5, 5);
			//decorArray_Floor.push(6, 9, 6);
			decorArray_Floor.push(7, 10, 6);
			decorArray_Floor.push(8, 10, 8);
			decorArray_Floor.push(3, 6, 9);
			decorArray_Floor.push(4, 6, 9);
			decorArray_Floor.push(5, 6, 9);

			decorArray_Wall.push(10, 11, 1);
			decorArray_Wall.push(13, 7, 1);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, .35, 14, 3, decorArray_Floor, decorArray_Wall);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}

		// dungeon skoodhorn
		public static function get dungeon_02(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(30, 20);

			floorArray.push(15, 1, 7, 5);
			floorArray.push(15, 1, 7, 11);
			floorArray.push(9, 6, 10, 10);
			floorArray.push(1, 7, 7, 5);
			floorArray.push(1, 7, 21, 5);
			floorArray.push(1, 1, 14, 4);

			entranceArray.push(14, 4);

			slotArray_Monster.push(12, 14, 16, 14);
			slotArray_Trap.push(9, 5, 19, 5);
			slotArray_Door.push(9, 11, 19, 11);
			////slotArray_Chest.push(4,6);

			decorArray_Floor.push(12, 10, 10);
			decorArray_Floor.push(16, 10, 11);
			decorArray_Floor.push(13, 10, 12);
			decorArray_Floor.push(18, 13, 17);
			decorArray_Floor.push(15, 10, 15);
			decorArray_Floor.push(10, 10, 22);
			decorArray_Floor.push(18, 10, 21);
			decorArray_Floor.push(10, 15, 25);
			decorArray_Floor.push(18, 15, 28);

			decorArray_Floor.push(14, 10, 30);
			decorArray_Floor.push(14, 11, 31);
			//decorArray_Floor.push(14, 13, 32);
			decorArray_Floor.push(14, 14, 29);
			decorArray_Floor.push(14, 15, 29);
			
			
			var decorArray_Wall: Array = []; // wall decor
			
			decorArray_Wall.push(13, 4, 1);
			decorArray_Wall.push(15, 4, 1);
			
			decorArray_Wall.push(12, 9, 1);
			decorArray_Wall.push(16, 9, 1);
			
			decorArray_Wall.push(20, 10, 1);
			decorArray_Wall.push(8, 10, 1);


			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, .05, 4, 3, decorArray_Floor, decorArray_Wall);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}
		
		// dungeon skoodhorn2
		public static function get dungeon_22(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(30, 20);

			floorArray.push(15, 1, 7, 12);
			floorArray.push(15, 1, 7, 5);
			floorArray.push(9, 6, 10, 4);
			floorArray.push(1, 7, 7, 6);
			floorArray.push(1, 7, 21, 6);
			floorArray.push(1, 1, 14, 13);

			entranceArray.push(14, 13);

			slotArray_Monster.push(12, 8, 16, 8);
			slotArray_Trap.push(7, 8, 21, 8);
			slotArray_Door.push(9, 5, 19, 5);
			////slotArray_Chest.push(4,6);

			decorArray_Floor.push(12, 4, 10);
			decorArray_Floor.push(16, 4, 11);
			decorArray_Floor.push(13, 4, 12);
			decorArray_Floor.push(18, 7, 17);
			decorArray_Floor.push(15, 4, 15);
			decorArray_Floor.push(10, 4, 22);
			decorArray_Floor.push(18, 4, 21);
			decorArray_Floor.push(10, 9, 25);
			decorArray_Floor.push(18, 9, 28);

			decorArray_Floor.push(14, 4, 30);
			decorArray_Floor.push(14, 5, 31);
			//decorArray_Floor.push(14, 13, 32);
			decorArray_Floor.push(14, 8, 29);
			decorArray_Floor.push(14, 9, 29);
			
			
			var decorArray_Wall: Array = []; // wall decor
			
			decorArray_Wall.push(13, 11, 1);
			decorArray_Wall.push(15, 11, 1);
			
			decorArray_Wall.push(12, 3, 1);
			decorArray_Wall.push(16, 3, 1);
			
			decorArray_Wall.push(20, 4, 1);
			decorArray_Wall.push(8, 4, 1);


			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, .05, 4, 3, decorArray_Floor, decorArray_Wall);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

		// dungeon moonglow
		public static function get dungeon_03(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(30, 20);

			floorArray.push(1, 4, 8, 4);
			floorArray.push(5, 1, 8, 7);
			floorArray.push(5, 7, 13, 5);
			floorArray.push(5, 1, 17, 7);
			floorArray.push(3, 3, 22, 6);
			floorArray.push(3, 5, 7, 11);
			floorArray.push(14, 1, 10, 15);
			floorArray.push(1, 4, 15, 11);
			floorArray.push(1, 7, 23, 8);
			//floorArray.push(15,1,7,11);
			//floorArray.push(9,6,10,10);
			//floorArray.push(1,7,7,5);
			//floorArray.push(1,7,21,5);
			//floorArray.push(1,1,14,4);

			decorArray_Floor.push(16, 8, 38);
			decorArray_Floor.push(17, 8, 36);

			decorArray_Floor.push(16, 10, 36);
			decorArray_Floor.push(17, 10, 37);

			decorArray_Floor.push(13, 8, 8);

			decorArray_Floor.push(14, 5, 40);
			decorArray_Floor.push(13, 5, 41);
			decorArray_Floor.push(15, 5, 42);
			decorArray_Floor.push(16, 5, 41);
			decorArray_Floor.push(17, 5, 43);

			decorArray_Floor.push(7, 14, 50);
			decorArray_Floor.push(9, 14, 50);
		
			decorArray_Floor.push(7, 12, 5);
			decorArray_Floor.push(9, 12, 5);
		
			decorArray_Floor.push(23, 6, 3);
			decorArray_Floor.push(24, 6, 2);
			decorArray_Floor.push(24, 7, 3);
			
			decorArray_Floor.push(7, 11, 9);
			decorArray_Floor.push(9, 11, 9);
			
			
			var decorArray_Wall: Array = []; // wall decor
		
			decorArray_Wall.push(10, 6, 1);
			decorArray_Wall.push(20, 6, 1);
			
			decorArray_Wall.push(21, 14, 1);



			entranceArray.push(8, 4);

			slotArray_Monster.push(14, 10, 23, 7, 8, 11);
			//slotArray_Monster.push(15, 6, 15, 10, 23, 7, 8, 12);
			slotArray_Trap.push(11, 15, 11, 7, 15, 13, 19, 7, 23, 10);
			slotArray_Door.push(12, 7, 18, 7, 15, 12, 23, 9, 10, 15);
			////slotArray_Chest.push(4,6);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, .1, 5, 2, decorArray_Floor, decorArray_Wall);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

		// orchaus
		public static function get dungeon_04(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(30, 20);

			floorArray.push(3, 8, 3, 5);
			floorArray.push(10, 1, 6, 12);
			floorArray.push(6, 4, 9, 5);
			floorArray.push(1, 3, 10, 9);
			floorArray.push(7, 1, 14, 6);
			floorArray.push(1, 6, 20, 6);
			floorArray.push(6, 3, 15, 14);
			floorArray.push(1, 3, 20, 11);
			floorArray.push(1, 3, 15, 12);
			floorArray.push(7, 1, 20, 15);
			floorArray.push(1, 10, 27, 6);

			entranceArray.push(27, 6);

			slotArray_Monster.push(19, 14, 16, 16, 4, 9, 10, 7, 12, 6);

			slotArray_Trap.push(22, 15, 16, 6, 7, 12, 12, 12);

			slotArray_Door.push(21, 15, 15, 6, 6, 12, 20, 13, 15, 13);

			//slotArray_Chest.push(4, 6);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 3, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}

		// hall of despair
		public static function get dungeon_05(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(40, 20);

			floorArray.push(1, 2, 4, 15);
			floorArray.push(21, 1, 4, 16);
			floorArray.push(1, 10, 24, 6);
			floorArray.push(4, 1, 24, 13);
			floorArray.push(3, 3, 28, 12);
			floorArray.push(4, 1, 24, 7);
			floorArray.push(3, 3, 28, 6);
			floorArray.push(3, 7, 3, 5);
			floorArray.push(5, 1, 5, 6);
			floorArray.push(9, 3, 9, 10);
			floorArray.push(1, 4, 9, 6);
			floorArray.push(8, 7, 12, 6);
			floorArray.push(5, 1, 19, 10);

			decorArray_Floor.push(12, 12, 53);
			decorArray_Floor.push(12, 11, 54);
			
			//decorArray_Floor.push(9, 10, 57);
			//decorArray_Floor.push(10, 10, 58);
			//decorArray_Floor.push(11, 10, 59);
			//decorArray_Floor.push(9, 11, 60);
			//decorArray_Floor.push(10, 11, 61);
			//decorArray_Floor.push(11, 11, 62);
			//decorArray_Floor.push(9, 12, 63);
			//decorArray_Floor.push(10, 12, 64);
			//decorArray_Floor.push(11, 12, 65);
			
			decorArray_Floor.push(3, 5, 55);
			decorArray_Floor.push(4, 5, 55);
			decorArray_Floor.push(3, 6, 56);
			
			decorArray_Floor.push(3, 10, 66);
			decorArray_Floor.push(3, 11, 66);
			decorArray_Floor.push(4, 11, 67);
			
			decorArray_Floor.push(24, 6, 68);
			
			decorArray_Floor.push(17, 9, 69);
			decorArray_Floor.push(14, 9, 69);
			
			decorArray_Floor.push(30, 8, 70);
			
			decorArray_Floor.push(30, 13, 74);
			decorArray_Floor.push(30, 12, 72);
			decorArray_Floor.push(30, 14, 73);
			decorArray_Floor.push(29, 12, 71);
			
			decorArray_Floor.push(12, 6, 5);
			decorArray_Floor.push(19, 6, 5);
			
			var decorArray_Wall: Array = []; // wall decor
		
			decorArray_Wall.push(27, 6, 1);
			decorArray_Wall.push(27, 12, 1);
			decorArray_Wall.push(7, 5, 1);
			
			decorArray_Wall.push(10, 15, 1);
			decorArray_Wall.push(14, 15, 1);
			decorArray_Wall.push(18, 15, 1);
			
			
			var randomArray: Array = []; // wall decor
			randomArray.push(20, 16, BoulderTrap);

			entranceArray.push(4, 15);

			slotArray_Monster.push(3, 8, 13, 7, 18, 7, 16, 11, 29, 7, 29, 13);
			slotArray_Trap.push(8, 16, 12, 16, 16, 16, 21, 10, 9, 6);
			slotArray_Door.push(20, 10, 23, 10, 26, 7, 26, 13, 9, 9, 6, 6);
			//slotArray_Chest.push(4, 10);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, .1, 3, 1, decorArray_Floor, decorArray_Wall,randomArray);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

		// holken
		public static function get dungeon_06(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(50, 30);

			floorArray.push(5, 5, 3, 4);
			floorArray.push(5, 5, 11, 4);
			floorArray.push(5, 5, 19, 4);
			floorArray.push(5, 5, 27, 4);

			floorArray.push(5, 5, 3, 12);
			floorArray.push(5, 5, 11, 12);
			floorArray.push(5, 5, 19, 12);
			floorArray.push(5, 5, 27, 12);

			floorArray.push(1, 11, 35, 4);

			floorArray.push(3, 1, 32, 14);
			floorArray.push(3, 1, 24, 6);
			floorArray.push(3, 1, 8, 6);
			floorArray.push(3, 1, 16, 14);

			floorArray.push(1, 4, 29, 8);
			floorArray.push(1, 4, 21, 8);
			floorArray.push(1, 4, 13, 8);
			floorArray.push(1, 4, 5, 8);





			entranceArray.push(35, 4);

			slotArray_Monster.push(29, 14, 29, 6, 21, 6, 21, 14, 13, 14, 13, 6, 5, 6, 3, 14, 7, 14, 5, 16);
			slotArray_Trap.push(33, 14, 29, 10, 21, 10, 13, 10, 5, 10, 35, 11);
			slotArray_Door.push(29, 9, 29, 11, 21, 11, 21, 9, 13, 9, 13, 11, 5, 11, 5, 9, 32, 14);
			//slotArray_Chest.push(3, 12, 7, 12, 7, 16, 3, 16);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, -.2, 2, 3);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}


		// multi entrance
		public static function get dungeon_07(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			dungeonArray.push(80, 40);

			floorArray.push(5, 5, 35, 15);
			floorArray.push(3, 9, 29, 11);
			floorArray.push(3, 9, 43, 15);
			floorArray.push(18, 1, 25, 23);
			floorArray.push(18, 1, 32, 11);
			floorArray.push(1, 12, 25, 11);
			floorArray.push(1, 12, 49, 11);
			floorArray.push(35, 1, 20, 17);
			floorArray.push(1, 22, 37, 6);


			entranceArray.push(20, 17, 25, 11, 37, 6, 54, 17, 49, 22, 37, 27);

			slotArray_Monster.push(30, 18, 30, 15, 44, 16, 44, 19, 35, 19, 39, 15, 44, 11, 30, 23, 35, 15, 39, 19);
			slotArray_Trap.push(25, 17, 37, 11, 49, 17, 37, 23, 37, 21, 33, 17, 37, 13, 41, 17);
			slotArray_Door.push(37, 14, 40, 17, 37, 20, 34, 17, 37, 22, 32, 17, 37, 12, 42, 17, 28, 17, 46, 17);
			//slotArray_Chest.push(36, 17, 38, 17, 37, 16, 37, 18);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, -.5, 3, 4);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}


		// new dungeon 1
		public static function get dungeon_new_01(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor
			var decorArray_Wall: Array = []; // wall decor

			dungeonArray.push(40, 25);

			floorArray.push(9, 1, 10, 3);
			floorArray.push(8, 5, 11, 4);
			floorArray.push(2, 6, 11, 8);
			floorArray.push(13, 4, 3, 14);
			floorArray.push(1, 1, 3, 13);
			floorArray.push(5, 9, 4, 10);
			floorArray.push(4, 1, 5, 9);
			floorArray.push(3, 1, 6, 8);
			floorArray.push(1, 1, 18, 9);
			floorArray.push(4, 1, 18, 10);
			floorArray.push(1, 4, 22, 10);
			floorArray.push(1, 5, 23, 9);
			floorArray.push(2, 2, 20, 12);
			floorArray.push(4, 1, 24, 11);
			floorArray.push(1, 7, 27, 4);
			floorArray.push(7, 1, 27, 4);
			floorArray.push(3, 3, 31, 3);

			entranceArray.push(32, 4);

			slotArray_Monster.push();
			slotArray_Trap.push();
			slotArray_Door.push(27, 8);
			//slotArray_Chest.push();

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, -.5, 3, 4, decorArray_Floor, decorArray_Wall, new DungeonSprite01());
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}


		public static function get small(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			//dungeonArray.push(24,16);
			dungeonArray.push(30, 20);

			floorArray.push(8, 8, 5, 5);
			floorArray.push(9, 1, 12, 13);
			floorArray.push(1, 6, 21, 8);
			floorArray.push(3, 3, 20, 7);

			portalArray.push(8, 8);

			entranceArray.push(21, 8);
			spawnPointArray.push(5, 5, M_Mummy);

			chestArray.push(7, 5);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}

		public static function get intro(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			var decorArray_Floor: Array = []; // floor decor

			//dungeonArray.push(24,16);
			dungeonArray.push(30, 20);

			floorArray.push(6, 4, 5, 10);
			floorArray.push(3, 1, 11, 12);
			floorArray.push(1, 5, 13, 7);

			portalArray.push(7, 11);

			entranceArray.push(13, 7);

			spawnPointArray.push(10, 10, M_ScaredyCat);

			chestArray.push(5, 10);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}

		public static function get big(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];
			var slotArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			//dungeonArray.push(24,16);
			dungeonArray.push(50, 30);

			floorArray.push(6, 6, 4, 4);
			floorArray.push(9, 1, 10, 5);
			floorArray.push(2, 2, 13, 8);
			floorArray.push(3, 1, 10, 8);
			floorArray.push(1, 8, 18, 5);
			floorArray.push(3, 3, 17, 13);
			floorArray.push(6, 1, 11, 14);
			floorArray.push(4, 3, 7, 13);
			floorArray.push(1, 4, 8, 16);
			floorArray.push(17, 1, 8, 19);
			floorArray.push(1, 8, 24, 12);
			floorArray.push(3, 5, 23, 7);
			floorArray.push(8, 1, 26, 9);
			floorArray.push(1, 5, 33, 5);
			floorArray.push(4, 1, 25, 16);
			floorArray.push(3, 3, 28, 16);

			//floorArray.push(6, 1, 19, 9);
			floorArray.push(3, 3, 32, 4);

			//floorArray.push(3,1,4,15); 
			//floorArray.push(1,5,4,10); 

			portalArray.push(7, 13);

			entranceArray.push(33, 5);
			/*
			spawnPointArray.push(7, 5, M_Bat);
			spawnPointArray.push(10, 13, M_Mummy);
			spawnPointArray.push(24, 8, M_Shadow);
			spawnPointArray.push(24, 10, M_Skeleton);
			spawnPointArray.push(29, 17, M_SpittingLizard);
			spawnPointArray.push(18, 14, M_FireDragon);*/

			chestArray.push(13, 9);
			chestArray.push(14, 8);
			chestArray.push(14, 9);
			chestArray.push(32, 6);
			chestArray.push(34, 6);

			doorArray.push(26, 9);
			doorArray.push(24, 12);
			doorArray.push(26, 16);
			doorArray.push(8, 16);
			doorArray.push(11, 14);
			doorArray.push(10, 5);
			doorArray.push(10, 8);

			//unitArray.push(B_Snow, 6, 6);
			//unitArray.push(ArrowTrap, 28, 9);
			//unitArray.push(BoulderTrap, 11, 19);
			//unitArray.push(SpikeTrap, 14, 19);
			//unitArray.push(SpikeTrap, 17, 19);
			//unitArray.push(SpikeTrap, 18, 11);
			//unitArray.push(SpikeTrap, 18, 9);
			//unitArray.push(SpikeTrap, 13, 5);
			//
			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}

		public static function get hallway(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			//dungeonArray.push(24,16);
			dungeonArray.push(30, 20);

			floorArray.push(12, 1, 5, 5);
			floorArray.push(3, 3, 5, 5);
			floorArray.push(1, 6, 6, 6);

			chestArray.push(5, 7);
			chestArray.push(7, 7);


			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;
		}

		public static function get bigEmptyRoom(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			dungeonArray.push(30, 20);

			floorArray.push(15, 9, 5, 4);

			//entranceArray.push(11, 12);
			//entranceArray.push(12, 12);
			//entranceArray.push(13, 12);

			/*spawnPointArray.push(10, 10, M_Dicks);
			spawnPointArray.push(9, 9, M_Dicks);
			spawnPointArray.push(8, 8, M_Dicks);*/

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

		public static function get bigEmptyRoomWithSlots(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];
			var slotArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			dungeonArray.push(30, 20);

			floorArray.push(15, 9, 5, 4);

			entranceArray.push(18, 5, 6, 5);

			slotArray_Monster.push(18, 11, 6, 11, 16, 11, 8, 11, 14, 7);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, entranceArray, slotArray_Monster, slotArray_Trap, slotArray_Door, slotArray_Chest, 0, 4, 2);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}



		public static function get wallTest(): Array {
			var dungeonArray: Array = [];
			var floorArray: Array = [];
			var portalArray: Array = [];
			var entranceArray: Array = [];
			var spawnPointArray: Array = [];
			var chestArray: Array = [];
			var doorArray: Array = [];
			var unitArray: Array = [];

			var slotArray_Monster: Array = [];
			var slotArray_Trap: Array = [];
			var slotArray_Door: Array = [];
			var slotArray_Chest: Array = [];

			dungeonArray.push(30, 20);

			floorArray.push(2, 10, 5, 4);
			floorArray.push(2, 10, 10, 4);
			floorArray.push(5, 1, 7, 4);

			//entranceArray.push(11, 12);
			//entranceArray.push(12, 12);
			//entranceArray.push(13, 12);

			unitArray.push(M_SpittingLizard, 6, 8);
			unitArray.push(A_Knight, 6, 12);

			var codifiedArray: Array = [];

			codifiedArray.push(dungeonArray, floorArray, portalArray, entranceArray, spawnPointArray, chestArray, doorArray, unitArray);
			//trace("Dungeon Layout Codified Array: " + codifiedArray);
			return codifiedArray;

		}

	}
}