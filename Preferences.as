package {
	public class Preferences {
		public static var pref;
		public function Preferences() {
			//pref = new Object();
			//pref.txtFile = "FLxER";
		}
		public static function customizePref(p) {
			pref = p
		}
		public static function createPref(ww,hh) {
			pref.w = ww;
			pref.h = hh;
		}
		public static function updatePref(cnt) {
			pref.startUrl = cnt;
			var myPath = cnt.substring(0, cnt.indexOf("/", 7))
			pref.myPath = myPath;
			updatePrefPath();
			//pref.myFsPath = myPath+pref.myFsPath;
		}
		public static function updatePrefPath() {
			pref.downPath = pref.myPath+Starter.myReplace(pref.downPath, pref.myPath,"");
			pref.myViPath = pref.myPath+Starter.myReplace(pref.myViPath, pref.myPath,"");
			pref.fpUpPath = pref.myPath+Starter.myReplace(pref.fpUpPath, pref.myPath,"");
			pref.embePath = pref.myPath+Starter.myReplace(pref.embePath, pref.myPath,"");
		}
	}
}