s.boot
s.options.sampleRate=44100
s.meter

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
WebView
(
History.start;
History.makeWin;
OSCdef(\hist, {|msg|
	/*msg.postln;*/    /* Para no tener cometarios duplicados en post */
	History.enter(msg[2].asString, msg[1]);
}, \hist).fix;
History.localOff;

History.forwardFunc = { |code|
	q.sendAll(\hist, \Lalo, code);
};
);

//MANDELHUB LIB
m = MandelHub.start("Lalo L"); // SER EL LIDER
m.takeLead;
MandelHub.join("Lalo", action: {m = MandelHub.instance}); //UNIRSE A SESION DEL LIDER

m.clear //limpiar el mandel
m.gui	 //iniciar gui de mandel

m.changeTempo(1, 10);
m.changeTempo(60/60, 1);
m.changeTempo(118/60, 1);
m.changeTempo(140/60, 1);
m.TempoClock.default.tempo_(120/60)
m.timer.reset;
//////////////////////////////////////
/////////////SYNTHS/////////////////
///////////////NDEF/////////////////
///////////////////////////////////////

//======
//Atmosfera
//======
(
SynthDef(\at01, {|amp=0.4 freq=600| Out.ar(0,Pan2.ar(FreeVerb.ar(BPF.ar(WhiteNoise.ar(amp)*Saw.kr(8)*SinOsc.kr(0.0015, 0, 0.4), SinOsc.kr(0.2,0,50,freq), 100/freq, 0.85), MouseX.kr(0.1,1,0), MouseY.kr(0.1,1,0),0.4,0.1)),0)}
).add
)
a = Synth(\at01)
a.set(\freq, 800, \amp, 0.75);
a.free
(
SynthDef(\at02, {|amp=0.05 freq=600| Out.ar(0,Pan2.ar(FreeVerb.ar(      )),0)}
).add
)
b = Synth(\at02)
b.set(\freq, 800, \amp, 0.75);
b.free



//BUFFER
b=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/04/lo03.wav");
//b.bufnum			b.numFrames
Ndef(\eho_buf).play
Ndef(\eho_buf)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(b.numChannels,b.bufnum,rate,t_trig,posc,loop:1)*EnvGen.kr(Env.perc(0.1,0.1),t_trig),pan,amp)}

Ndef(\eho_buf).quant_(4)[1]=\set -> Pbind(\dur, Prand([2,4],inf), \posc, Prand([0.1,0.2,0.3]*b.numFrames,inf),\rate,Prand([1],inf), \amp, Prand([0.1],inf), \pan, Prand([0],inf), \t_trig,1)

//Pitch, Echo, Reverb,
Ndef(\eho_buf).release
b.release

/////////////
c=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/01/lo02.wav");
Ndef(\eho_buf2).play
Ndef(\eho_buf2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(c.numChannels,c.bufnum,rate,t_trig,posc,loop:1)*amp,0)*EnvGen.kr(Env.perc(0.1,0.05),t_trig)}

Ndef(\eho_buf2).quant_(4)[1]=\set -> Pbind(\dur, Prand([1,3,4,5].scramble,inf), \posc, Pseq([0.3]*c.numFrames,inf),\amp,0.25, \rate, Prand([0.5,0.6,0.7],inf), \t_trig,1)

//[Array.series(10,0,0.1)].choose*c.numFrames,inf

Ndef(\eho_buf2).release
c.release

/////////////
g=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s03.aif");
Ndef(\eho_buf2).play
Ndef(\eho_buf2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(g.numChannels,g.bufnum,rate,t_trig,posc,loop:1)*amp,0)*EnvGen.kr(Env.perc(0.05,0.05),t_trig)}

Ndef(\eho_buf2).quant_(4)[1]=\set -> Pbind(\dur, Prand([0.25,0.5,1].scramble,inf), \posc, Pseq([Array.series(18,0.1,0.05)]*g.numFrames,inf), \amp,1.7, \rate,Prand([1],inf), \t_trig,1)

//[Array.series(10,0,0.1)].choose*c.numFrames,inf

Ndef(\eho_buf2).release
g.release

/////////////BASS
d=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s01.aif");
Ndef(\eho_buf3).play
Ndef(\eho_buf3)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.2,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(d.numChannels,d.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(2,2),t_trig)}

Ndef(\eho_buf3).quant_(4)[1]=\set -> Pbind(\dur, Prand(([4]).scramble,inf), \posc, Prand(d.numFrames/[Array.series(10,0.1)].scramble.choose,inf), \amp, Prand([0.35,0.5,0.6]*1.1,inf), \rate, Prand([0.2],inf), \t_trig,1)

//o bien
Ndef(\eho_buf3).quant_(4)[1]=\set -> Pbind(\dur, Prand([2,1,1,1,0.5,0.5],inf), \posc, Prand([Array.series(20,0,0.5)*d.numFrames].scramble.choose,inf), \amp, Prand([0.3]*0.35,inf), \rate, Prand([-1],inf), \t_trig,1)
Ndef(\eho_buf3).release
d.release

/////////////VOZ Long
h=Buffer.read(s,"/Users/eduardobieta/Dropbox/eho/Voces_grabaciones/Hüseyin/Hüseyin_gf_poem.wav");
Ndef(\eho_poem).play
Ndef(\eho_poem)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.05,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(h.numChannels,h.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(2,12),t_trig)}

Ndef(\eho_poem).quant_(4)[1]=\set -> Pbind(\dur, Pseq([16],inf), \posc,Prand([0.7,0.5,0.4,0.2]*h.numFrames,inf), \amp, Prand([0.1,0.15,0.18],inf), \rate, Prand([1],inf), \t_trig,1)

Ndef(\eho_poem).release
h.release
/////////////VOZ Long
i=Buffer.read(s,"/Users/eduardobieta/Dropbox/eho/Voces_grabaciones/Hüseyin/Hüseyin_poem.wav");
Ndef(\eho_poem2).play
Ndef(\eho_poem2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.15,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(i.numChannels,i.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.15,0.15),t_trig)}

Ndef(\eho_poem2).quant_(4)[1]=\set -> Pbind(\dur, Prand([4,8],inf), \posc,Prand([0.4]*i.numFrames,inf), \amp, Prand([0.15,0.18],inf), \rate, Prand([1,-0.5],inf), \t_trig,1)

Ndef(\eho_poem2).release
h.release

/////////////VOZ
e=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s02.aif");
Ndef(\eho_buf0).play
Ndef(\eho_buf0)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.05,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(e.numChannels,e.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.05,0.25),t_trig)}

Ndef(\eho_buf0).quant_(4)[1]=\set -> Pbind(\dur, Prand([8],inf), \posc,Prand([0.05,0.7,0.3,0.1,0.22,0.5]*e.numFrames,inf), \amp, Prand([0.6,0.7,0.8],inf), \rate, Prand([0.1,0.12,0.05,0.25],inf), \t_trig,1)

Ndef(\eho_buf0).release
e.release1

f=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s03.aif");
Ndef(\eho_buf00).play
Ndef(\eho_buf00)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.15,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(f.numChannels,f.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.1,0.1),t_trig)}

Ndef(\eho_buf00).quant_(4)[1]=\set -> Pbind(\dur, Prand([2],inf), \posc,Pseq([0.12,0.35]*f.numFrames,inf), \amp, Prand([0.6,0.7,0.8]*0.8,inf), \rate, Pseq([1],inf), \t_trig,1)

Ndef(\eho_buf0).release
e.release
Ndef(\eho_buf00).release
f.release


s.prepareForRecord

m.changeTempo(125/60, 10);


//======
//Ritmos
//======
//kick buffer
k=Buffer.read(s,"/Users/eduardobieta/Dropbox/eho/Voces_grabaciones/Hüseyin/kick.wav");
Ndef(\eho_k).play
Ndef(\eho_k)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.5,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(k.numChannels,k.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.01,0.2),t_trig)}

Ndef(\eho_k).quant_(4)[1]=\set -> Pbind(\dur, Prand([1,1,1,0.5,0.5,2,1,1],inf), \posc,Prand([0.1]*k.numFrames,inf), \amp, Prand([0.7,0.6,0.8]*0.7,inf), \rate, Prand([1],inf), \t_trig,1)

Ndef(\eho_k).release
k.release

//kick synth
Ndef(\eho1).play
Ndef(\eho1)[0]={|frec=80,t_trig=1, dur=1, amp = 0.85| Pan2.ar(FSinOsc.ar(frec,0,0.5),0)*EnvGen.kr(Env.perc(0.01,0.2),t_trig)}

Ndef(\eho1).quant_(4)[1]=\set -> Pbind(\dur, Prand([1],inf), \frec, Prand([60,61]-24.midicps,inf), \amp, Prand([0.5,0.6,0.7,0.8,0.9]*2,inf), \t_trig,1)
Ndef(\eho1).release

///////////////////////////////////////////
Ndef(\eho2).play
Ndef(\eho2)[0]={|amp=0.5, t_trig=1| Pan2.ar(WhiteNoise.ar(0.025))*EnvGen.kr(Env.perc(0.01,0.01, amp),t_trig)}

Ndef(\eho2).quant_(4)[1]=\set -> Pbind(\dur, Pseq([1],inf), \amp, Prand([0.5,0.4,0.3],inf), \t_trig,1)
Ndef(\eho2).release

Ndef(\eho3).play
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 2, av1= 2| Pan2.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1),0)*EnvGen.kr(Env.perc(0.1,0.75),t_trig)}
Ndef(\eho3).quant_(4)[1]=\set -> Pbind(\dur, Prand([4, 8, 12],inf), \ac0,Prand([0,2],inf), \ac1,Prand([2,4,6,8,10],inf), \af0, Prand([2],inf), \af1, Prand([4,6,8], inf), \av0, Pseq([8,6,8,10]*0.25,inf), \av1, Prand([8,12,14]*0.25,inf), \t_trig, 1);
Ndef(\eho3).release

//fadeTime - release - send
Ndef(\eho2).release
Ndef(\eho3).release
