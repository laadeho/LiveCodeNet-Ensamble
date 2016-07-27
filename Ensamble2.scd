//==================================================
//codigo para ensamble: modelo datos Ndef sint patern
//==================================================
// falta usar envolvente sobre los Ndef
s.boot;

Ndef(\sinte1).play; // .release o .stop para parar
Ndef(\sinte1)[0]={|f1=400| LFTri.ar(f1,0,0.3)!2} // sinte

(
OSCdef(\x, { |msg|
	var x = msg.unfoldOSCArrays[1].postln;
	Ndef(\sinte1).quant_(4)[1]= \set -> Pbind(\dur, 0.25, \f1, Pseq(x, inf)); //secuencia
}, "/her").fix;
);

(
q = ();
NetAddr.broadcastFlag = true;
q.addrs = (0..7).collect { |x| 
		NetAddr("255.255.255.255", 57120 + x)
};
q.sendAll = { |q ... args|
		q.addrs.do { |addr|
				addr.sendMsg(*args)
		}; ""
}
)

q.sendAll("/her", *[[200,500,950,789,500]].asOSCArgArray); // hasta que corres esta linea suena

(
History.start;
History.makeWin;

OSCdef(\hist, { |msg| 
	msg.postln;
	History.enter(msg[2].asString, msg[1]);
}, \hist).fix;
History.localOff;

History.forwardFunc = { |code| 
	q.sendAll(\hist, \hernani, code);
};
)

s.quit;


"que es eso hernani"