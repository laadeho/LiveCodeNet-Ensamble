//=================================================================================
/////     LiveCodeNet Ensamble
//=================================================================================

s.boot;
s.scope(2);

/////     Start BroadCast
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

/////     Start History to share with the Ensamble
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

//////	Starting Open Object for a better synchronization
(
OpenObject.start; // prende el OpenObject
OpenObject.lookup=true; // habilita la opcion de recibir control
OpenObject.openProxies; // habilita los proxies Ndef, Pdef, Tdef, Fdef
//OpenObject.end; // cierra la comunicacide openboject
)

//////	WE START THIS LINES TO BE READY FOR PLAY WITH SYNCHRONIZATION LATER
//////	The *defs that need to be ready, with specific tag that "\eho" in my case
//////	SYNC ZONE	//////
Ndef(\eho)[0]={|dur = 0.1, t_trig = 1, frec = 180| SinOsc.ar(frec,0,0.5)*EnvGen.kr(Env.perc(0.01, dur),t_trig)!2}
Ndef(\eho).fadeTime = 2;
//////	EVALUAR AL MISMO TIEMPO
Ndef(\eho).quant_(4)[1]=\set -> Pbind(\frec, Prand([180, 0, 158, 170],inf),\dur, Prand([1],inf), \t_trig, 1);

/*=================================================================================
Basically, we have two sections, 
- We start with the "ambient" stuff, some atmospheres,
*/=================================================================================


//////	SYNC ZONE	//////
//////	PLAYING SYNC ZONE	//////
/*
Ndef(\eho).play
Ndef(\hernani).play
Ndef(\libertad).play
Ndef(\emilio).play
Ndef(\joseCaos).play
Ndef(\katya).play
*/

//////	STOPPING SYNC ZONE	//////
/*
Ndef(\eho).stop; 			Ndef(\eho).release;
Ndef(\hernani).stop;
Ndef(\libertad).stop;
Ndef(\emilio).stop;
Ndef(\joseCaos).stop;
Ndef(\katya).stop;
*/

"L C N ".speak

"ajuuuuuaaaa"

"Live Code Net".speak //, we are Live Code Net Ensamble".speak

///// ESTE ES EL QUE PUEDEN MODIFICAR POR LA RED
(
SynthDef(\va, {|frec=48, vol=0.4, durd2=0.1|
var sen, env;
sen=SinOsc.ar(frec,0,vol);
env=EnvGen.kr(Env.perc(0.1,durd2),doneAction:2);
Out.ar(0,Pan2.ar(sen*env,0,1))
}).add;

OSCdef(\va, { |msg|
	 var x = msg[1], y = msg[2];
	Pdef(\eho00, Pbind(\instrument, \va,\frec,Prand([x, x*0.9, x*1.15],inf).midicps,\dur,Pseq([2,0.5,0.25]*y,inf),\durd2,Prand([1,0.25,0.25]*y,inf), \vol,0.4));
}, "/eho00").fix;
);

Pdef(\eho00).play
Pdef(\eho00).stop

q.sendAll("\eho00", 120, 0.5); // frec - pulso

///// ACOMPA
Ndef(\eho01)[0]={|dur = 0.1, t_trig = 1| SinOsc.ar([160,180]*0.5,0,0.3)*SinOsc.kr(0.1,0,0.2,0.4)}//*EnvGen.kr(Env.perc(0.1, dur),t_trig)!2}
Ndef(\eho01).quant_(4)[1]=\set -> Pbind(\frec, Pseq([180, 0, 180, 180, 178, 180, 0],inf),\dur,Prand([1.5, 2.5],inf), \t_trig, 1);
Ndef(\eho01).play
Ndef(\eho01).stop

// whitenoise
Ndef(\eho02)[0]={|dur = 0.1, t_trig = 1| Out.ar(0, BPF.ar(WhiteNoise.ar(0.05)*Saw.kr(0.015), 2500, 0.8, 0.75))}
Ndef(\eho02)[0]={|dur = 0.1, t_trig = 1| Out.ar(1, BPF.ar(WhiteNoise.ar(0.5)*Saw.kr(12), 4500, 0.8, 0.75))}
Ndef(\eho02).play
Ndef(\eho02).fadeTime = 2;

"kill them all"
Ndef(\eho03)[0]={|dur = 0.1, t_trig = 1| Out.ar(1, BPF.ar(BrownNoise.ar(0.001)))}
Ndef(\eho03).play
Ndef(\eho03).fadeTime = 2;

Ndef(\eho04)[0]={|dur = 0.1, t_trig = 1| Crackle.ar(1.97, 0.05)!2}
Ndef(\eho04).play
Ndef(\eho04).fadeTime = 2;

Ndef(\eho05)[0]={|dur = 0.1, t_trig = 1| Dust.ar(10, 0.85)!2}
(\eho05).fadeTime = 2;
Ndef(\eho05).play

"que? algo de noise??"

Ndef(\eho01).stop
Ndef(\eho02).stop
Ndef(\eho03).stop
Ndef(\eho04).stop
Ndef(\eho05).stop
