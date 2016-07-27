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
Ndef(\eho).quant_(4)[1]=\set -> Pbind(\frec, Prand([180, 0, 158, 170],inf),\dur, Prand([1],inf), \t_trig, 1);

/*=================================================================================
Basically, we have two sections, 
- We start with the "ambient" stuff, some atmospheres; everyone's playing their own synths.
*///=================================================================================

"L C N ".speak
"Live Code Net".speak //, we are Live Code Net Ensamble".speak

//////	AMBIENT ZONE	//////

///// We prepare son synth with an OSCdef to share the value of the arguments in the net, 
(
SynthDef(\va, {|frec=48, vol=0.4, durd2=0.1|
var sen, env;
sen=SinOsc.ar(frec,0,vol);
env=EnvGen.kr(Env.perc(0.1,durd2),doneAction:2);
Out.ar(0,Pan2.ar(sen*env,0,1))
}).add;

OSCdef(\va, { |msg|
	 var x = msg[1], y = msg[2];
	Pdef(\eho0, Pbind(\instrument, \va,\frec,Prand([x, x*1.2, x*1.5],inf).midicps,\dur,Pseq([1,0.25,0.25]*y,inf),\durd2,Prand([1,0.25,0.25]*y,inf), \vol,0.4));
}, "/eho0").fix;
);

//Playing the shared synth
Pdef(\eho0).play;
//Pdef(\eho0).stop

//Sending the data to the net
//they can now change the freq and the value of pulses
q.sendAll("/eho0", 50, 1.15); // freq - pulse

//////	This ones are only for play in my computer and the players can't change the values
Ndef(\eho01)[0]={|dur = 0.1, t_trig = 1| SinOsc.ar([160,180]*0.5,0,0.3)*SinOsc.kr(0.1,0,0.2,0.4)*EnvGen.kr(Env.perc(0.1, dur),t_trig)!2}
Ndef(\eho01).quant_(4)[1]=\set -> Pbind(\frec, Pseq([180, 0, 180, 180, 178, 180, 0],inf),\dur,Prand([1.5, 2.5],inf), \t_trig, 1);
Ndef(\eho01).play
Ndef(\eho01).stop
// whitenoise
Ndef(\eho02)[0]={|dur = 0.1, t_trig = 1| Out.ar(0, BPF.ar(WhiteNoise.ar(0.05)*Saw.kr(0.015), 2500, 0.8, 0.75))}
Ndef(\eho02)[0]={|dur = 0.1, t_trig = 1| Out.ar(1, BPF.ar(WhiteNoise.ar(0.5)*Saw.kr(12), 4500, 0.8, 0.75))}
Ndef(\eho02).play
Ndef(\eho02).fadeTime = 2;
// brownnoise
Ndef(\eho03)[0]={|dur = 0.1, t_trig = 1| Out.ar(1, BPF.ar(BrownNoise.ar(0.001)))}
Ndef(\eho03).play
Ndef(\eho03).fadeTime = 2;

Ndef(\eho01).stop
Ndef(\eho02).stop
Ndef(\eho03).stop


//////	SYNC ZONE	//////
//////	PLAYING SYNC ZONE	//////
// One of the performers evaluate this section (usually Hernani), to activate the rythm version, all we are with amplitudes at almost "0" and go up step by step
/*
Ndef(\eho).play
Ndef(\hernani).play
Ndef(\libertad).play
Ndef(\emilio).play
Ndef(\joseCaos).play
Ndef(\katya).play
*/

//modifying the values 
Ndef(\eho).quant_(4)[1]=\set -> Pbind(\frec, Prand([180, 0, 158, 170]*1.2,inf),\dur, Prand([1,2,3,4]*0.25,inf), \t_trig, 1);

//////	STOPPING SYNC ZONE	//////
/*
Ndef(\eho).stop; 			Ndef(\eho).release;
Ndef(\hernani).stop;
Ndef(\libertad).stop;
Ndef(\emilio).stop;
Ndef(\joseCaos).stop;
Ndef(\katya).stop;
*/



