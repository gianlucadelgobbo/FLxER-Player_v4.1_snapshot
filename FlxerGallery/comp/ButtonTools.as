﻿package FlxerGallery.comp {
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.MouseEvent;
	import StarterGallery;
	public class ButtonTools extends MovieClip {
		var txt:String;
		var fnz:Function;
		var fnzOut:Function;
		var param;
		///////
		public var lab;
		public var simb:MovieClip;
		public var puls:MovieClip;
		public var pulsInt:MovieClip;
		var alt;
		//
		public function ButtonTools() {
		}
		public function avvia(obj) {
			var myCol:ColorTransform
			trace("bella"+this.name)
			if (obj.txt != undefined) {
				this.lab.text = obj.txt;
				//this.lab.antiAliasType = Preferences.pref.antiAliasType;
				this.lab.width = int(this.lab.textWidth+Preferences.pref.deltaT);
				this.puls.width = int(this.lab.width);
				this.pulsInt.width = int(this.puls.width-2);
				this.lab.textColor = Preferences.pref.btnSimb;
			} else {
				myCol = this.simb.transform.colorTransform;
				myCol.color = Preferences.pref.btnSimb;
				simb.transform.colorTransform = myCol;
			}
			
			myCol = this.puls.transform.colorTransform;
			myCol.color = Preferences.pref.btnBorder;
			this.puls.transform.colorTransform = myCol;
			
			myCol = pulsInt.transform.colorTransform;
			myCol.color = Preferences.pref.btnBkg;
			pulsInt.transform.colorTransform = myCol;
			
			fnz = obj.fnz;
			param = obj.param;
			alt = obj.alt;
			fnzOut = obj.fnzOut;
			enable();
		}
		public function enable() {
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			this.buttonMode=true;
		}
		public function disable() {
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			this.buttonMode=false;
			mouseOutHandler(null);
		}
		function mouseDownHandler(e) {
			//disable()
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			mouseOutHandler(e);
			if (fnz is Function) {
				fnz(param);
			}
		}
		function mouseUpHandler(e) {
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			trace("mouseUpHandler")
			mouseOutHandler(e);
			if (fnzOut is Function) {
				fnzOut(param);
			}
			//enable()
		}
		function mouseOverHandler(e) {
			var myCol:ColorTransform
			if (this.simb is MovieClip) {
				myCol = simb.transform.colorTransform;
				myCol.color = Preferences.pref.btnSimbOver;
				simb.transform.colorTransform = myCol;
			} else {
				this.lab.textColor = Preferences.pref.btnSimbOver;
			}
			myCol = this.puls.transform.colorTransform;
			myCol.color = Preferences.pref.btnBorderOver;
			this.puls.transform.colorTransform = myCol;

			myCol = pulsInt.transform.colorTransform;
			myCol.color = Preferences.pref.btnBkgOver;
			pulsInt.transform.colorTransform = myCol;

			if (alt) {
				Preferences.pref.myAlt.avvia(alt);
			}
		}
		function mouseOutHandler(e) {
			trace("bella"+this.name)
			var myCol:ColorTransform
			if (this.simb is MovieClip) {
				myCol = simb.transform.colorTransform;
				myCol.color = Preferences.pref.btnSimb;
				simb.transform.colorTransform = myCol;
			} else {
				this.lab.textColor = Preferences.pref.btnSimb;
			}
			myCol = this.puls.transform.colorTransform;
			myCol.color = Preferences.pref.btnBorder;
			this.puls.transform.colorTransform = myCol;

			myCol = pulsInt.transform.colorTransform;
			myCol.color = Preferences.pref.btnBkg;
			pulsInt.transform.colorTransform = myCol;

			Preferences.pref.myAlt.stoppa();
		}
	}
}
