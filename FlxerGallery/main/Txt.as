package FlxerGallery.main{
	import flash.text.TextField;
	import flash.text.TextField.defaultTextFormat 
	import flash.text.AntiAliasType;
	
	public class Txt extends TextField{
		public function Txt(xx:Number,yy:Number,ww,hh,t:String,tipo:String) {
			x = xx
			y = yy
			//border = true
			styleSheet = Preferences.pref.tsHtml
			htmlText=t;
			embedFonts=true;
			antiAliasType = AntiAliasType[Preferences.pref.myAntiAliasType];
			if (ww != null) {
				width = ww;
				multiline=true;
				wordWrap=true;
			} else {
				width=textWidth + 9;
			}
			if (hh != null) {
				height = hh;
			} else {
				height=textHeight + 4;
			}
			if (tipo == "input" || tipo == "puls") {
				selectable = (tipo == "input");
				if (tipo == "input") {
					type="input";
				}
				background=true;
				border=true;
				borderColor=Preferences.pref.altBorder;
				backgroundColor=Preferences.pref.altBkg;
			} else {
				selectable=false;
			}
		}
	}
}