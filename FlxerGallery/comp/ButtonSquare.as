package FlxerGallery.comp {
	import flash.display.MovieClip;
	public class ButtonSquare extends MovieClip {
		var x:Number;
		var y:Number;
		var w:Number;
		var h:Number;
		var fnz:String;
		var fnzOver:String;
		var param:String;
		var fnzTrgt:MovieClip;
		var src:String;
		var tipo:String;
		///////
		var puls:MovieClip;
		var owner:ButtonSquare;
		//
		function ButtonSquare() {
			this._x = x;
			this._y = y;
			if (src) {
				var col = _root.myFlxerPlayerStyles.playerColors["colorBkgOver"];
				_root.myFlxerPlayerStyles.drawer(this, "puls", 0, 0, w, h, col, null, 100);
				this.createEmptyMovieClip("imm", this.getNextHighestDepth());
				this["imm"]._x = w/2;
				this["imm"]._y = h/2;
				var myMcl = new main.mcLoader(src, this["imm"], this, "appare", "loadProg");
				if (tipo == "flv" || tipo == "mp3" || tipo == "swf") {
					if (tipo == "flv") {
						var tmp = "VIDEO";
					} else if (tipo == "swf") {
						var tmp = "FLASH MOVIE";
					} else {
						var tmp = "AUDIO";
					}
					_root.myFlxerPlayerStyles.textDrawerSP(this, "tipoTxt", "<p class=\"typeLabel\">"+tmp+"</p>", 5, h-24, w-10, 19, true);
					this["tipoTxt"]._alpha = 80;
				}
				this["puls"].owner = this;
				this["puls"].onPress = function() {
					_root.alt.stoppa();
					owner.fnzTrgt[owner.fnz](owner.param);
					_root.bip.play();
					onRollOut();
				};
				this["puls"].onRollOver = function() {
					owner["imm"]._xscale = owner["mask"]._xscale=92;
					owner["imm"]._yscale = owner["mask"]._yscale=89.2;
					_root.bip.play();
					if (owner.fnzOver) {
						owner.fnzTrgt[owner.fnzOver](owner.param);
					}
					if (owner._parent.lista.childNodes[owner.param+owner._parent.thumbPage].childNodes[1] != undefined) {
						var tmp = {x:this._x+(owner.w/2), y:this._y+(owner.h/2)};
						this.localToGlobal(tmp);
						_root.alt.avvia(owner._parent.lista.childNodes[owner.param+owner._parent.thumbPage].childNodes[1], tmp);
					}
				};
				this["puls"].onRollOut = function() {
					_root.alt.stoppa();
					owner["imm"]._xscale = owner["mask"]._xscale=owner["imm"]._yscale=owner["mask"]._yscale=100;
					if (owner.fnzOut) {
						owner.fnzTrgt[owner.fnzOut](owner.param);
					}
				};
			} else {
				var col = _root.myFlxerPlayerStyles.playerColors["colorBkg"];
				_root.myFlxerPlayerStyles.drawer(this, "puls", 0, 0, w, h, col, null, 100);
			}
		}
		function appare(t) {
			this.createEmptyMovieClip("mask", this.getNextHighestDepth());
			this["mask"]._x = w/2;
			this["mask"]._y = h/2;
			_root.myFlxerPlayerStyles.drawer(this["mask"], "mask", -w/2, -h/2, w, h, 0x000000, null, 100);
			this["imm"].setMask(this["mask"]);
			t._x = -t._width/2;
			t._y = -t._height/2;
		}
	}
}
