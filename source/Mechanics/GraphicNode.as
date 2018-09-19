package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class GraphicNode extends MovieClip implements INode {

		private var _f: Number;
		private var _g: Number;
		private var _h: Number;
		private var _parentNode: INode;
		private var _connectedNodes: Array;

		private var _col: int;
		private var _row: int;
		private var _parentGrid: MasterGrid;
		private var _obstacleMC: MovieClip;
		private var _pixelWidth: int;

		private var _isTraversable: Boolean;

		private var _isOccupied: Boolean;
		private var _occupiers: Array;
		private var _tempOccupier: DisplayObjectContainer;
		
		public var hasStructure:Boolean = false;
		private var _structure:Sprite;
		
		public var hasDecor:Boolean = false;
		private var _decor:DisplayObject;
		
		public var units:int = 0;

		private var _graphic: DisplayObjectContainer;
		
		private var _spawnPoint : SpawnPoint;
		private var _isEntrance : Boolean;


		public function GraphicNode(colNum: int, rowNum: int, parGrid: MasterGrid, pxWidth: int) {

			gotoAndStop(1);

			_col = colNum;
			_row = rowNum;
			_parentGrid = parGrid;
			_pixelWidth = pxWidth;
			
			_obstacleMC = _parentGrid.obstacleMC;

			width = _pixelWidth;
			height = _pixelWidth;

			_isTraversable = false;
			_isOccupied = false;
			_occupiers = [];
			
			_isEntrance = false;
			//_entrance.width = _pixelWidth*.5;
			//_entrance.height = _pixelWidth*.5;
			
		}
		
		public function set structure(value :*) : void {
			_structure = value;
			
			if (_structure) hasStructure = true;
			else hasStructure = false;
		}

		public function showGrid(): void {
			gotoAndStop(2);
		}

		public function hideGrid(): void {
			gotoAndStop(1);
		}

		public function get f(): Number {
			return _f;
		}

		public function get g(): Number {
			return _g;
		}

		public function get h(): Number {
			return _h;
		}

		public function get col(): int {
			return _col;
		}

		public function get row(): int {
			return _row;
		}

		public function get parentNode(): INode {
			return _parentNode;
		}

		public function get isTraversable(): Boolean {
			return _isTraversable;
		}


		public function get connectedNodes(): Array {
			return _connectedNodes;
		}

		public function get parentGrid(): * {
			return _parentGrid;
		}

		public function set f(value: Number): void {
			_f = value;
		}

		public function set g(value: Number): void {
			_g = value;
		}

		public function set h(value: Number): void {
			_h = value;
		}

		public function set col(value: int): void {
			_col = value;
		}

		public function set row(value: int): void {
			_row = value;
		}

		public function set parentNode(value: INode): void {
			_parentNode = value;
		}

		public function set isTraversable(value: Boolean): void {
			_isTraversable = value;
		}


		public function set parentGrid(value: * ): void {
			_parentGrid = value;
		}



		public function get graphic(): DisplayObjectContainer {
			return _graphic;
		}

		public function set graphic(value: DisplayObjectContainer): void {
			
			//trace("\nGraphic Node set graphic, start - " + _graphic);

			if (_graphic) {
				//trace("ALREADY HAS " + _graphic + " TRYING TO REPLACE WITH " + value);
				if (_graphic is IWall || _graphic is ICorner || _graphic is IDecor) {
					_obstacleMC.removeChild(_graphic);
				} else {
					removeChild(_graphic);
				}
				
				_isTraversable = false;
			}

			_graphic = value;

			if (_graphic) {
				
				if (_graphic is IWall || _graphic is ICorner || _graphic is IDecor) {
					//trace("adding " + _graphic + " to " + _obstacleMC);
					_obstacleMC.addChild(_graphic);
					_graphic.x = x;
					_graphic.y = y;
				} else {
					addChild(_graphic);
				}
				//_graphic.width = _pixelWidth;
				//_graphic.height = _pixelWidth;
				
				if (_graphic is IFloor) {
					_isTraversable = true;
				}
			}

			//trace("setting " + this + " to " + value);
			//trace("																											current graphic - " + _graphic);
		}

		public function addElement(element: DisplayObject): void {

		}

		public function removeElement(element: DisplayObject): void {

		}

		public function get pixelWidth(): int {
			return _pixelWidth;
		}
		
		public function get isOccupied(): Boolean {
			return _isOccupied;
		}

		public function set isOccupied(value: Boolean): void {
			_isOccupied = value;
		}

		public function get occupier(): DisplayObjectContainer {
			//trace(_occupiers);
			return _occupiers[_occupiers.length - 1];
		}
		
		public function get occupiers(): Array {
			//trace(_occupiers);
			return _occupiers;
		}
		
		public function setAsEntrance(sp:SpawnPoint): void {
			_isEntrance = true;
			_spawnPoint = sp;
			//_entrance = new EntranceMarker();
			//addChild(_entrance);
			//setChildIndex(_entrance, numChildren-1);
			//_entrance.x =16;
			//_entrance.y =16;
		}
		
		public function removeAsEntrance() : void {
			_isEntrance = false;
			_spawnPoint = null;
		}
		
		public function get isEntrance() : Boolean {
			return _isEntrance;
		}
		
		public function addDecor(element:*) : void {
			if (hasDecor) {
				trace(this + " ALREADY HAS DECOR: " + _decor);
				return;
			}
			_decor = element;
			graphic.addChild(element);
			hasDecor = true;
			
			if (element is IDecor) {
				isTraversable = false;
				enterNode(element);
			}
		}

		public function enterNode(element: *): void {
			//trace("\n - - - " + element + " entering " + this + " - - - ");
			//trace("Current Occupiers: " + _occupiers + "\n");
			

			if (element is IDoor || element is IDecor) {
				_parentGrid.obstacleMC.addChild(element);
			} else {
				_parentGrid.addChild(element);
				_parentGrid.setChildIndex(element, _parentGrid.numChildren-1);
			}
			
			if (element is IDecor == false) element.currentNode = this;

			_isOccupied = true;
			_occupiers.push(element);
			
			if (element is IGameUnit) {
				units++;
			}
			
			if (units == 2) {
				var otherUnit = _occupiers[_occupiers.length - 2];
				otherUnit.x = x + _pixelWidth / 2;
				otherUnit.y = y;
				
				element.x = x + _pixelWidth / 2;
				element.y = y + _pixelWidth / 8 * 5;
			} else if (element is IMultiNode) {
				element.x = x;
				element.y = y;
			} else {
				element.x = x + _pixelWidth / 2;
				element.y = y + _pixelWidth / 2;
			}
			
		}
		
		public function removeOccupier(element : *) {
			_occupiers.splice(_occupiers.indexOf(element), 1);
			if (_occupiers.length == 0) {
				_isOccupied = false;
			}
		}
		
		public function addOccupier(element : *) {
			_occupiers.push(element);
			_isOccupied = true;
		}

		public function exitNode(element: *): void {
			//trace("\n - - - " + element + " exiting " + this + " - - - ");
			//trace("Current Occupiers: " + _occupiers + "\n");
			
			if (element.parent == _parentGrid.obstacleMC)_parentGrid.obstacleMC.removeChild(element);
			else _parentGrid.removeChild(element);
			
			if (element is IDecor == false) element.currentNode = null;

			_occupiers.splice(_occupiers.indexOf(element), 1);
			if (_occupiers.length == 0) {
				_isOccupied = false;
			}
			
			if (element is IGameUnit) {
				units--;
			}
			
			if (units == 1) {
				var otherUnit = _occupiers[_occupiers.length - 1];
				otherUnit.x = x + _pixelWidth / 2;
				otherUnit.y = y + _pixelWidth / 2;
			}
		}
		
		public function get spawnPoint() : SpawnPoint {
			return _spawnPoint;
		}

		public function destroy(): void {

			if (_isEntrance) {
				removeAsEntrance();
			}
			
			_connectedNodes = null;
			_graphic = null;
			_occupiers = null;
			_parentGrid = null;
			_parentNode = null;
			_tempOccupier = null;
			_structure = null;
		}

		public function getStats(): String {
			return ("GraphicNode (" + _col + ", " + _row + ")\n" +
				" - Graphic: " + graphic + "\n" +
				" - isTraversable: " + _isTraversable + "\n" +
				" - isOccupied: " + _isOccupied + "\n" +
				" - Occupiers: " + _occupiers);
		}
		override public function toString(): String {
			return ("GraphicNode (" + _col + ", " + _row + ")");
		}

	}

}