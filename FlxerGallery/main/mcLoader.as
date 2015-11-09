class main.mcLoader extends MovieClip {
	function mcLoader(myUrl, trgt, trgtF, fnzInit, fnzProg, x, y, nome) {
		if (!nome) {
			nome = "trgt";
		}
		trgt.myMcl = new MovieClipLoader();
		trgt.createEmptyMovieClip(nome, trgt.getNextHighestDepth());
		if (x != undefined) {
			trgt[nome]._x = x;
			trgt[nome]._y = y;
		}
		trgt.myListener = new Object();
		if (fnzProg) {
			trgt.myListener.onLoadProgress = function(target_mc, loadedBytes, totalBytes) {
				trgtF[fnzProg](target_mc, loadedBytes, totalBytes);
			};
		}
		trgt.myListener.onLoadInit = function(target_mc) {
			trgtF[fnzInit](target_mc);
		};
		trgt.myMcl.addListener(trgt.myListener);
		trgt.myMcl.loadClip(myUrl, trgt[nome]);
	}
}
