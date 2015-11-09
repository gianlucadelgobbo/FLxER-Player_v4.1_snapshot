class comp.ButtonGra extends MovieClip {
	var w:Number;
	var txt:String;
	var fnzTrgt:MovieClip;
	var fnz:String;
	var param:String;
	///////
	var lab:MovieClip;
	var puls:MovieClip;
	var pulsInt:MovieClip;
	//
	function ButtonGra() {
		if (txt) {
			/* STANDARD 
			var deltaT =  4*/
			/* NGA FONT */
			var deltaT = 6;
			lab._width = lab.textWidth+deltaT;
			puls._width = lab._width+1;
			pulsInt._width = lab.textWidth+3;
		}
		puls.onPress = function() {
			this._parent.fnzTrgt[this._parent.fnz]();
			onRollOut();
		};
		puls.onRollOver = function() {
			if (this._parent["simb"]) {
				var trgt = this._parent["simb"]
			} else {
				var trgt = this
			}
			var col = new Color(trgt);
			col.setRGB(_root.myFlxerPlayerStyles.toolsColors["colorBkgOver"]);
			if (this._parent.alt) {
				_root.alt.avvia(this._parent.alt);
			}
		};
		puls.onRollOut = function() {
			if (this._parent["simb"]) {
				var trgt = this._parent["simb"]
			} else {
				var trgt = this
			}
			var col = new Color(trgt);
			col.setRGB(_root.myFlxerPlayerStyles.toolsColors["colorBkg"]);
			_root.alt.stoppa();
		};
	}
}
