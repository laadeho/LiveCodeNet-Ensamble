//Ensamble 3 y 4

s.boot;
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

Ndef(\sonar).play
Ndef(\sonar).stop
Ndef(\sonar)[0]={|pul = 0.05| SinOsc.ar(120,0,0.5)*Pulse.ar(pul,0.5,0.2)!2}

(
OSCdef(\a, {|msg|
		var x = msg[1];
		Ndef(\sonar).quant_(4)[1] = \set -> Pbind(\dur, x/2, \pul, Pseq(x, inf));
}, "eho").fix;
);

q.sendAll("\eho", 4); // pulsos

(
SynthDef(\a, {|frec=48, vol=0.75, durd2=0.1|
var sen, env;
sen=SinOsc.ar(frec,0,vol*0.7)*Pulse.ar(4,0.5,0.2);
env=EnvGen.kr(Env.perc(0.1,durd2),doneAction:2);
Out.ar(0,Pan2.ar(sen*env,0,1))
}).add;

OSCdef(\a, { |msg|
	 var x = msg[1], y = msg[2];
	Pdef(\eho, Pbind(\instrument, \a,\frec,Prand([x, 1.2, x*1.5],inf).midicps,\dur,Prand([y, y*1.25, y*0.75],inf),\durd2,Prand([y, y*1.5, y*2],inf), \vol,0.5));
}, "/eho").fix;
);

Pdef(\eho).play;
Pdef(\eho).stop;


/////////////////////// OTRO 04 AJUSTAR NUEVO CODE A 
(
SynthDef(\a, {|frec=48, vol=0.5, durd2=0.1, pulsos = 0.5|
var sen, env;
sen=SinOsc.ar(frec*0.7,0,vol)*Pulse.ar(4,0.5,0.2)+ SinOsc.ar(120, 0,0.75)*Saw.ar(pulsos, vol);
env=EnvGen.kr(Env.perc(0.1,durd2),doneAction:2);
Out.ar(0,Pan2.ar(sen*env,0,1))
}).add;

OSCdef(\a, { |msg|
	//CAMBIAR A
	var x = msg.unfoldOSCArrays[1].postln, y = msg.unfoldOSCArrays[2].postln;
	Pdef(\eho, Pbind(\instrument, \a,\frec,Prand([x, x*1.25, x*2, x*1.5],inf).midicps,\dur,Pseq([1, 0.5,0.5,0.5, 0.25, 0.125,0.25,0.125]*y,inf),\durd2,Prand([1, 0.5,0.5,0.5, 0.25, 0.125,0.25,0.125]*y,inf), \pulsos, Prand([y, y*2, y*0.5],inf), \vol,0.75));
}, "/eho").fix;
);


/////////////////////// OTRO 04

(
q.sendAll("/eho", 60, 1); //[frecuencias en midicps] [pulsos]
)
//////////////// CAMBIAR A
q.sendAll("/eho", *[60,1].asOSCArgArray); //[frecuencias en midicps] [pulsos]
//var x = msg.unfoldOSCArrays[1].postln;


"Hola".postln

Algo

(
SynthDef(\n, {| pul = 8 , durd = 2, freq = 440|
	var sen, env;
	sen = BPF.ar(WhiteNoise.ar(0.125), SinOsc(5, freq), 100 / SinOsc(5, freq), 0.5);
	env = EnvGen.kr(Env.perc(0.1,durd), doneAction:2);
	Out.ar(0,Pan2.ar(sen,0,1))
}).add;

OSCdef(\n, { |msg|
	 var x = msg[1];
	Pdef(\eho2, Pbind(\instrument, \n, \pul, Pseq([x,x/2, x/4, x/2, x, x, x/2],inf), \dur,Psesq([10, 12, 14, 16]*x, inf), \durd, Pseq([10, 12, 14, 16]*x,inf)));
}, "/eho2").fix;
)

a = Synth(\n)
a.play

"van armon’as en 60,63,65"


Pdef(\eho2).play;

(
q.sendAll("/eho", 36, 2); //[frecuencias en midicps] [pulsos]
q.sendAll("/eho2", 2); // [pulsos del noise]
)



///// DE HERNANI
Ndef(\cuat).quant_(4)[1]= \set -> Pbind(\dur,0.25, \f1, Pseq([Pn(75,2),48,\rest,55,\rest,59,78,66,Pn(77,2),69].midicps,inf), \t_trig, 1)

