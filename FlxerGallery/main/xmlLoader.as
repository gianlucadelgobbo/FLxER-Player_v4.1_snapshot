class main.xmlLoader {
	var c
	var owner
	function xmlLoader(myUrl, trgt, myName, trgtF, fnz) {
		trgt[myName] = new XML();
		trgt[myName].ignoreWhite = true;
		trgt[myName].owner = this
		trgt[myName].onLoad = function(s:Boolean) {
			if (s) {
				trgtF[fnz](trgt[myName]);
			} else {
				trgtF["xmlLoadFailed"]();
			}
		};
		trgt[myName].load(myUrl);
	}
}
