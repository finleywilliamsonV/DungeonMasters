package {

	public class DungeonPathfinder {

		// g/2
		// floors in doc class
		//

		public static var heuristic: Function = DungeonPathfinder.manhattan;
		public static var heuristic2: Function = DungeonPathfinder.avoidance;
		
		private static var openNodes:Array;
		private static var closedNodes:Array;
		private static var connectedNodes:Array;
		private static var tempArea: Array;
		
		private static var masterGridArray: Array;
		
		private static var tempArray:Array;
		private static var returnArray:Array;
		
		private static var path:Array;
		
		private static var ofThese:Array;

		public static function findPath(firstNode: INode, destinationNode: INode): Array {

			var nodeGrid: MasterGrid = firstNode.parentGrid;
			openNodes = [];
			closedNodes = [];
			var currentNode: INode = firstNode;
			var testNode: INode;
			//var connectedNodes: Array;
			var travelCost: Number = 1.0;
			var g: Number;
			var h: Number;
			var f: Number;
			currentNode.g = 0;
			currentNode.h = DungeonPathfinder.heuristic(currentNode, destinationNode, travelCost);
			currentNode.f = currentNode.g + currentNode.h;
			var l: int;
			var i: int;

			while (currentNode != destinationNode) {

				connectedNodes = nodeGrid.getAdjacentNodes(currentNode, true, false);
				l = connectedNodes.length;

				for (i = 0; i < l; i++) {
					testNode = connectedNodes[i];

					//if (testNode == currentNode || testNode.isTraversable == false || testNode == null) continue; // redundant?

					g = currentNode.g + travelCost;
					h = heuristic(testNode, destinationNode, travelCost);
					f = (g / 2) + h;

					if (DungeonPathfinder.isOpen(testNode, openNodes) || DungeonPathfinder.isClosed(testNode, closedNodes)) {

						if (testNode.f > f) {
							testNode.f = f;
							testNode.g = g;
							testNode.h = h;
							testNode.parentNode = currentNode;
						}

					} else {
						testNode.f = f;
						testNode.g = g;
						testNode.h = h;
						testNode.parentNode = currentNode;
						openNodes.push(testNode);
						//if (testNode != firstNode && testNode != destinationNode) testNode.gotoAndStop("open");
					}
				}

				closedNodes.push(currentNode);
				//if (currentNode != firstNode && currentNode != destinationNode) currentNode.gotoAndStop("closed");
				if (openNodes.length == 0) {
					return null;
				}
				openNodes.sortOn('f', Array.NUMERIC);
				currentNode = openNodes.shift() as INode;
			}

			return DungeonPathfinder.buildPath(destinationNode, firstNode);
		}

		public static function findFarthestPoint(startNode: INode, avoidNode: INode, distance: int, outOf: Array = null): INode {

			//trace("startNode: " + startNode);
			//trace("avoidNode: " + avoidNode);

			tempArea = [];
			
			if (outOf == null) {
				tempArea = getNodesInArea(startNode, distance);
			} else {
				tempArea = outOf;
			}

			//trace("tempArea: " + tempArea);

			//trace("tempArea: " + tempArea);

			var testNode: INode = tempArea[0];
			var tempFarthest: Number = heuristic2(testNode, avoidNode);
			var tempFarthestNode: INode = testNode;

			var f: Number;


			for (var j: int = 1; j < tempArea.length; j++) {

				testNode = tempArea[j];

				f = heuristic2(testNode, avoidNode);

				//trace("\nF: " + f);

				if (f < tempFarthest) {
					tempFarthest = f;
					tempFarthestNode = testNode;
				}
			}

			//trace("Temp Farthest: " + tempFarthestNode);
			return tempFarthestNode;
		}

		public static function getNodesInArea(thisNode: INode, distance: int): Array {		//!!!! DOES NOT RETURN THIS NODE
			
			if (distance == 1) {
				return thisNode.parentGrid.getAdjacentNodes(thisNode, true, false);
			}

			masterGridArray = thisNode.parentGrid.gridArray;

			var tempCol: int = thisNode.col;
			var tempRow: int = thisNode.row;
			tempArea = [];
			var tempElement: GraphicNode;

			var colMod: int;
			var rowMod: int;

			for (var col: int = -distance; col <= distance; col++) {
				for (var row: int = -distance; row <= distance; row++) {

					colMod = thisNode.col - col;
					rowMod = thisNode.row - row;
					
					if (Math.abs(col) + Math.abs(row) > distance) continue;

					if (colMod >= 0 && colMod < thisNode.parentGrid.columns && rowMod >= 0 && rowMod < thisNode.parentGrid.rows) {

						tempElement = masterGridArray[colMod][rowMod];

						if (tempElement && tempElement.isTraversable && tempElement != thisNode) {
							tempArea.push(tempElement);
						}
					}
				}
			}

			//trace("\ntempArea: " + tempArea);
			return tempArea;
		}

		
		// idk what this is
		/*public static function getNodesInAreaUnoccupied(thisNode: INode, distance: int): Array {
			
			var tempArray : Array = getNodesInArea(thisNode, distance);
			var returnArray : Array = [];
			
			for (var i : int = 0; i < tempArray.length; i ++ ) {
				if ( tempArray[i].isOccupied == false) {
					returnArray.push(tempArray[i]);
				}
			}
			
			return returnArray;
		}*/

		public static function getNodesInAreaUnoccupied(thisNode: INode, mg: MasterGrid, distance:int = 1): Array {
			
			tempArray = [];
			returnArray = [];
			
			if (distance == 1) {
				tempArray = mg.getAdjacentNodes(thisNode, true, true);
			} else {
				tempArray = getNodesInArea(thisNode, distance);
			}

			for (var i: int = 0; i < tempArray.length; i++) {
				if (tempArray[i].isOccupied == false) {
					returnArray.push(tempArray[i]);
				}
			}

			return returnArray;
		}


		public static function buildPath(destinationNode: INode, startNode: INode): Array {
			path = [];
			var node: INode = destinationNode;
			path.push(node);
			while (node != startNode) {
				// 	---------------- swap v
				path.unshift(node);
				node = node.parentNode; // swapped ^
			}
			return path;
		}

		public static function isOpen(test: INode, list: Array): Boolean {
			for (var i: int = 0; i < list.length; i++) {
				if (list[i] == test) {
					return true;
				}
			}

			return false;
		}

		public static function isClosed(test: INode, list: Array): Boolean {
			for (var i: int = 0; i < list.length; i++) {
				if (list[i] == test) {
					return true;
				}
			}

			return false;
		}
		
		public static function closestPoint(toThisNode:INode, ofThese:Array): INode {
			var closest:INode = ofThese[0];
			var dist: Number = manhattan(toThisNode, closest);
			var tempDist:Number;
			for (var i : int = 1; i < ofThese.length; i++) {
				tempDist = manhattan(toThisNode, ofThese[i]);
				//trace("			DP: " + toThisNode + " is " + tempDist + " nodes from " + ofThese[i]);
				
				if (tempDist < dist) {
					dist = tempDist;
					closest = ofThese[i];
					//trace("DP: Closest set to " + closest);
				}
			}
			//trace("			DP: Returning " + closest);
			return closest;
		}
		
		public static function findClosestWithinRange(toThisNode:INode, enemyNode:INode, thisRange:int): INode {
			//trace("*** find closest within range");
			ofThese = getNodesInArea(enemyNode, thisRange);
			//trace("*** " + ofThese);
			var closest:INode = toThisNode;
			var dist: Number = Number.MAX_VALUE;
			var tempDist:Number;
			var tempNode : INode;
			
			for (var i : int = 0; i < ofThese.length; i++) {

				tempNode = ofThese[i];
				
				if (tempNode == toThisNode) {
					return tempNode;
				}
				
				if (tempNode.isOccupied && (tempNode.occupier is IMonster || tempNode.occupier is IAdventurer)) {
					continue;
				}
				
				tempDist = manhattan(toThisNode, ofThese[i]);
				
				//trace("*** " + toThisNode, ofThese[i]);
				//trace("*** " + tempDist);
				
				if (tempDist < dist) {
					dist = tempDist;
					closest = ofThese[i];
					//trace("DP: Closest set to " + closest);
				}
			}
			//trace("			DP: Returning " + closest);
			return closest;
		}

		public static function manhattan(node: INode, destinationNode: INode, cost: Number = 1.0): Number {

			return Math.abs(node.col - destinationNode.col) + Math.abs(node.row - destinationNode.row);
		}


		public static function avoidance(node: INode, destinationNode: INode, cost: Number = 1.0): Number {

			var distance: Number = Math.abs(node.col - destinationNode.col) + Math.abs(node.row - destinationNode.row);

			//trace("\nNode: " + node.col, node.row);
			//trace("    DISTANCE    : " + distance);


			if (distance == 0) {
				return 10;
			} else {
				return ((1 / distance) * 10);
			}

		}
		
		
		public static function findPathUnoccupied(firstNode: GraphicNode, destinationNode: GraphicNode): Array {

			var nodeGrid: MasterGrid = firstNode.parentGrid;
			openNodes = [];
			closedNodes = [];
			
			var currentNode: GraphicNode = firstNode;
			var testNode: GraphicNode;
			connectedNodes = [];
			var travelCost: Number = 1.0;
			var g: Number;
			var h: Number;
			var f: Number;
			currentNode.g = 0;
			currentNode.h = DungeonPathfinder.heuristic(currentNode, destinationNode, travelCost);
			currentNode.f = currentNode.g + currentNode.h;
			var l: int;
			var i: int;

			while (currentNode != destinationNode) {

				connectedNodes = nodeGrid.getAdjacentNodes(currentNode, true, true);
				l = connectedNodes.length;

				for (i = 0; i < l; i++) {
					testNode = connectedNodes[i];

					//if (testNode == currentNode || testNode.isTraversable == false || testNode == null) continue; // redundant?

					g = currentNode.g + travelCost;
					h = heuristic(testNode, destinationNode, travelCost);
					f = (g / 2) + h;

					if (DungeonPathfinder.isOpen(testNode, openNodes) || DungeonPathfinder.isClosed(testNode, closedNodes)) {

						if (testNode.f > f) {
							testNode.f = f;
							testNode.g = g;
							testNode.h = h;
							testNode.parentNode = currentNode;
						}

					} else {
						testNode.f = f;
						testNode.g = g;
						testNode.h = h;
						testNode.parentNode = currentNode;
						openNodes.push(testNode);
						//if (testNode != firstNode && testNode != destinationNode) testNode.gotoAndStop("open");
					}
				}

				closedNodes.push(currentNode);
				//if (currentNode != firstNode && currentNode != destinationNode) currentNode.gotoAndStop("closed");
				if (openNodes.length == 0) {
					return null;
				}
				openNodes.sortOn('f', Array.NUMERIC);
				currentNode = openNodes.shift() as GraphicNode;
			}

			return DungeonPathfinder.buildPath(destinationNode, firstNode);
		}

	}

}