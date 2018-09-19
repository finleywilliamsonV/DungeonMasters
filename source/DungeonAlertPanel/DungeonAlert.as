package {

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.BlendMode;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.filters.DropShadowFilter;

	public class DungeonAlert extends TextField {


		private var _opacity: Number;
		private var _opacityTimer: int;
		private var _opacityTimerLimit: int;

		private var _textFormat: TextFormat;

		private static const TEXT_SIZE: int = 26;


		// constructor code
		public function DungeonAlert() {
			super();

			// set blend mode to allow for change in opactiy
			this.blendMode = BlendMode.LAYER;

			// member variables
			_opacity = 1;
			_opacityTimer = 0;
			_opacityTimerLimit = 100;
			
			// add drop shadow
			filters = [new DropShadowFilter(2,45,0,1,0,0,1)];

			// create and set default text format
			_textFormat = new TextFormat(GlobalVariables.DEFAULT_FONT.fontName, TEXT_SIZE, 0xFFFFFF);
			this.defaultTextFormat = _textFormat;

			// disable input
			this.selectable = false;
			this.type = TextFieldType.DYNAMIC;
			
			// set auto-size
			this.autoSize = TextFieldAutoSize.LEFT;
		}


		// set text to specified string
		public function setText(newText: String): void {
			this.text = newText;
		}


		// update timers & opacity
		public function update(): void {
			_opacityTimer++;
			
			// if timer > limit, calculate & apply opacity
			if (_opacityTimer >= _opacityTimerLimit) {
				_opacity = 1 - ((_opacityTimer - _opacityTimerLimit) * .1);
				if (_opacity < 0) _opacity = 0;

				// set alpha
				this.alpha = _opacity;
			}
		}


		// destroy
		public function destroy(): void {
			_textFormat = null;
		}

	}
}