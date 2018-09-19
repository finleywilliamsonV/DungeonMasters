package {

	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;


	public class UI_UnitViewer extends MovieClip {

		private var _masterGrid:MasterGrid;
		private var _bitmapData : BitmapData;
		private var _bitmap:Bitmap;
		private static var _rect:Rectangle = new Rectangle(0,0,_pixelWidth,_pixelWidth);
		private static var _pixelWidth : int = 78.5;

		public function UI_UnitViewer(mg:MasterGrid = null) {
			
			_masterGrid = mg;
			_bitmapData = new BitmapData(_pixelWidth, _pixelWidth, true, 0x000000);	// pixel width
			_bitmap = new Bitmap(_bitmapData);
			addChild(_bitmap);
		}
		
		public function update(mc:MovieClip) : void {
			
			if (mc is EmptySlot) return;
			
			trace(this + " is updating");
			
			reset();
			
			if ((mc is Adventurer || mc is Monster) && mc._healthBar) {
				mc._healthBar.visible = false;
			}
			
			var mat :Matrix = new Matrix(1, 0, 0, 1, -mc.getBounds(mc).x + (width/8), -mc.getBounds(mc).y + (height/5));
			//_bitmapData.draw(mc.currentNode);
			_bitmapData.draw(mc,mat);
			
			if ((mc is Adventurer || mc is Monster) && mc._healthBar) {
				mc._healthBar.visible = true;
			}
			
			//x = 1294 -width/2;
			//y = 117 -height/2;

			
			//_bitmap.bitmapData = _bitmapData;
			
		}
		
		public function reset() : void {
			
			_bitmapData.fillRect(_rect, 0x000000);
		}
		
		public function destroy() : void {
			_masterGrid = null;
			_bitmapData = null;
			_bitmap = null;
		}
	}

}