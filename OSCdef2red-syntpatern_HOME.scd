//==================================================
//codigo para redes usando OSCdef + synthdef pattern
//==================================================
// 1 prender
s.boot;
// 2 declarar syntes y oscdef
(
(
SynthDef(\y, {|frec=48, vol=0.5, durd2=0.1|
var sen, env;
sen=SinOsc.ar(frec,0,vol);
env=EnvGen.kr(Env.perc(0.1,durd2),doneAction:2);
Out.ar(0,Pan2.ar(sen*env,0,1))
}).add;

OSCdef(\y, { |msg|
	 var x = msg[1]-12;
	Pdef(\vivo, Pbind(\instrument, \y,\frec,Pseq([[x, x+7, x+12], x+10, x+14, x+15, x+19, x+7, x+7],inf).midicps,\dur,Prand([1, 0.5,0.5,0.5, 0.25, 0.25],inf),\durd2,Prand([1, 0.5,0.5,0.5, 0.25, 0.25],inf), \vol,0.75));
}, "/vivo").fix;
);

(
SynthDef(\x,{|frec=200,vol=0.25, durd=0.1|
var sen, env;
sen=LFSaw.ar(frec,0.5,vol);
env=EnvGen.kr(Env.perc(0.1,durd),doneAction:2);
Out.ar(0,Pan2.ar(sen*env))
}).add;

OSCdef(\x, { |msg|
	var y = msg[1], x = 60;
	Pdef(\muerto, Pbind(\instrument, \x,\frec,Prand([[x, x+7, x+12], x+10, x+14, x+15, x+19, x+7, x+7],inf).midicps,\dur,Prand([0.5, 0.25,0.25,0.25, 0.125, 0.125]*y,inf),\vol,0.25, \durd, Prand([0.5, 0.25,0.25,0.25, 0.125, 0.125]*y,inf)));
}, "/muerto").fix;
);
)
// 3 prender los pdef (quiza no suene hasta que manden el mensaje .sendAll de abajo)
(
Pdef(\vivo).play;
Pdef(\muerto).play;
)
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
(
q.sendAll("/vivo", 60);
q.sendAll("/muerto", 2);
)

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
	q.sendAll(\hist, \nombre, code);
};
)

(
SynthDef(\x,{|frec=200,vol=0.25, durd=0.5|
var sen, env;
sen=LFSaw.ar(frec,0.5,vol);
env=EnvGen.kr(Env.perc(0.1,durd),doneAction:2);
Out.ar(0,Pan2.ar(sen*env))
}).add;

OSCdef(\x, { |msg|
	var y = msg[1], x = 60;
	Pdef(\muerto, Pbind(\instrument, \x,\frec,Pseq([x, x+3,x+5,x+7],inf).midicps,\dur,0.5 ,\vol,0.25, \durd, 0.5));
}, "/muerto").fix;
)


s.quit;