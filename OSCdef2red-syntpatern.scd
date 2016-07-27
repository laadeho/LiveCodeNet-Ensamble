//==================================================
//codigo para redes usando OSCdef + synthdef pattern
//==================================================
// 1 prender
s.boot;
// 2 declarar syntes y oscdef
(
(
SynthDef(\y, {|frec=300, vol=0.5|
var sen, env;
sen=SinOsc.ar(frec,0,vol);
env=EnvGen.kr(Env.perc(0.1,0.1),doneAction:2);
Out.ar(0,Pan2.ar(sen*env,0,1))
}).add;

OSCdef(\y, { |msg|
	 var x = msg[1].postln.asString.ascii;
	Pdef(\vivo, Pbind(\instrument, \y,\frec,Pseq(x*10,inf).trace,\dur,0.5,\vol,0.5));
}, "/vivo").fix;
);

(
SynthDef(\x,{|frec=200,vol=0.5|
var sen, env;
sen=LFTri.ar(frec,0,vol);
env=EnvGen.kr(Env.perc(0.1,0.1),doneAction:2);
Out.ar(0,Pan2.ar(sen*env))
}).add;

OSCdef(\x, { |msg|
	var x = msg[1].postln.asString.ascii;
	Pdef(\muerto, Pbind(\instrument, \x,\frec,Pseq(x*2.7,inf),\dur,0.25,\vol,0.5));
}, "/muerto").fix;
);
)
// 3 prender los pdef (quiza no suene hasta que manden el mensaje .sendAll de abajo)
Pdef(\vivo).play;
Pdef(\vivo).stop;

Pdef(\muerto).play;
Pdef(\muerto).stop;

// 4 comenzar a compartir 
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
// 5 enviar strings que seran decodificados como ascii
q.sendAll("/vivo", "48algosepuedemandar");
q.sendAll("/muerto", "i5ddd");

// 6declarando history veremos el codigo de cada uno en nuestra History window , el tag \nombre cambienlo por el suyo
(
History.start;
History.makeWin;

OSCdef(\hist, { |msg| 
	msg.postln;
	History.enter(msg[2].asString, msg[1]);
}, \hist).fix;

History.localOff;

History.forwardFunc = { |code| 
	q.sendAll(\hist, \eduardo, code);
};
)

s.quit;