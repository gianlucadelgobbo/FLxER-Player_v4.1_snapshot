class main.myTween {
	var owner
	function myTween(trgt, prop, func, myStart, myEnd, ms, trgtF, fnz) {
		trgt.tween = new mx.transitions.Tween(trgt, prop, func, myStart, myEnd, ms, false);
		trgt.tween.owner = trgtF;
		trgt.tween.onMotionFinished = function() {
			owner[fnz](trgt);
		};
	}
}
