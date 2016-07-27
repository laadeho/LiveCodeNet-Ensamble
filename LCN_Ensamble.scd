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

(
History.start;
History.makeWin;
OSCdef(\hist, {|msg|
	/*msg.postln;*/    /* Para no tener cometarios duplicados en post */
	History.enter(msg[2].asString, msg[1]);
}, \hist).fix;
History.localOff;

History.forwardFunc = { |code|
	q.sendAll(\hist, \Lalo1, code);
};
);

"me ven? soy yo"
"ya no hare travesuras"
"Ya te vi, tienes iniciado el lider del mandel?"

//MANDELHUB LIB
m = MandelHub.start("LALO LIDER"); // SER EL LIDER

MandelHub.join("EL_LALO_01", action: {m = MandelHub.instance}); //UNIRSE A SESION DEL LIDER

m.clear //limpiar el mandel
m.gui	 //iniciar gui de mandel

m.changeTempo(1, 10);
m.changeTempo(10/60, 6);
m.changeTempo(120/60, 120);
m.TempoClock.default.tempo_(120/60)

//////////////////////////////////////
/////////////SYNTHS/////////////////
///////////////NDEF/////////////////
///////////////////////////////////////

//======
//Atm—sferas
//======

(
SynthDef(\at01, {|amp=0.4 freq=600| Out.ar(0,Pan2.ar(FreeVerb.ar(BPF.ar(WhiteNoise.ar(amp)*Saw.kr(8)*SinOsc.kr(0.0015, 0, 0.4), SinOsc.kr(0.2,0,50,freq), 100/freq, 0.85), MouseX.kr(0.1,1,0), MouseY.kr(0.1,1,0),0.4,0.1)),0)}
).add
)
a = Synth(\at01)
a.set(\freq, 800, \amp, 0.75);
a.free

//BUFFER
b=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/01/lo03.wav");
//b.bufnum			b.numFrames
Ndef(\eho_buf).play
Ndef(\eho_buf)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(b.numChannels,b.bufnum,rate,t_trig,posc,loop:1)*EnvGen.kr(Env.perc(0.5,0.5,1,4),t_trig),pan,amp)}

Ndef(\eho_buf).quant_(4)[1]=\set -> Pbind(\dur, Prand([1,3,5,7],inf), \posc, Prand([Array.series(10,0,0.1)].choose*b.numFrames,inf),\rate, Pseq([1,0.8,0.6],inf), \amp, Prand([0.8,0.6,0.4]*0.5,inf), \pan, Prand([0],inf), \t_trig,1)
//Pitch, Echo, Reverb, 
Ndef(\eho_buf).release
b.release

/////////////
c=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/01/lo02.wav");    
Ndef(\eho_buf2).play
Ndef(\eho_buf2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(c.numChannels,c.bufnum,rate,t_trig,posc,loop:1)*amp,0)*EnvGen.kr(Env.perc(0.01,0.05),t_trig)}

Ndef(\eho_buf2).quant_(4)[1]=\set -> Pbind(\dur, Prand([2,4].scramble,inf), \posc, Prand([0.07,0.15]*c.numFrames,inf),\amp,0.3, \rate, Prand([0.1],inf), \t_trig,1)

//[Array.series(10,0,0.1)].choose*c.numFrames,inf

Ndef(\eho_buf2).release
c.release

/////////////
d=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s01.aif");
Ndef(\eho_buf3).play
Ndef(\eho_buf3)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(d.numChannels,d.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.25,1),t_trig)}

Ndef(\eho_buf3).quant_(4)[1]=\set -> Pbind(\dur, Prand(([2]).scramble,inf), \posc, Prand(d.numFrames/[Array.series(10,0,0.1)].scramble.choose,inf), \amp, Prand([0.5,0.5,0.6],inf), \rate, Prand([-0.5,-0.8,-0.3],inf), \t_trig,1)

//o bien
Ndef(\eho_buf3).quant_(4)[1]=\set -> Pbind(\dur, Prand([2,1,1,1,0.5,0.5],inf), \posc, Prand([Array.series(20,0,0.5)*d.numFrames].scramble.choose,inf), \amp, Prand([0.3]*0.35,inf), \rate, Prand([-1],inf), \t_trig,1)
Ndef(\eho_buf3).release
d.release

/////////////
e=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s11.aif");
Ndef(\eho_buf0).play
Ndef(\eho_buf0)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(e.numChannels,e.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.01,0.5),t_trig)}

Ndef(\eho_buf0).quant_(4)[1]=\set -> Pbind(\dur, Prand([4].scramble,inf), \posc, Prand(e.numFrames/[Array.fill(7, {10.rand})].scramble.choose,inf), \amp, Prand([0.85],inf), \rate, Prand([0.3],inf), \t_trig,1)

//o bien
Ndef(\eho_buf0).quant_(4)[1]=\set -> Pbind(\dur, Prand([4,6,8],inf), \posc, Prand([Array.series(20,0,0.05)*e.numFrames].scramble.choose,inf), \amp, Prand([1],inf), \rate, Prand([1],inf), \t_trig,1)

//Pseq([Array.series(10,0,0.1)*d.numFrames].choose.reverse,inf)

Ndef(\eho_buf0).release
e.release

s.prepareForRecord

//======
//Ritmos
//======

Ndef(\eho1).play
Ndef(\eho1)[0]={|frec=400,t_trig=1, div=3| Pan2.ar(LFSaw.ar(frec/div)*FSinOsc.ar(frec,0,0.05),0)*EnvGen.kr(Env.perc(0.35,1.75),t_trig)}

Ndef(\eho1).quant_(4)[1]=\set -> Pbind(\dur, Prand([14,12,8,15]*1.3,inf), \frec, Prand([60,63,66,72].midicps,inf),\div, Prand([3,4,7],inf), \t_trig,1)

Ndef(\eho2).play
Ndef(\eho2)[0]={|frec=80,t_trig=1| Pan2.ar(SinOsc.ar(frec,0,0.95),0)*EnvGen.kr(Env.perc(0.01,0.01),t_trig)}

Ndef(\eho2).quant_(4)[1]=\set -> Pbind(\dur, Prand([1,2],inf), \frec, Prand([80,82]*1.2,inf),\t_trig,1)

///Revisar este
Ndef(\eho3).play
Ndef(\eho3)[0]={|freq = 600, t_trig=1| Pan2.ar(BPF.ar(WhiteNoise.ar(0.35)*SinOsc.kr(0.015, 0, 0.4), SinOsc.kr(0.2,0,50,freq), 100/freq, 0.85),0)}

Ndef(\eho3).quant_(4)[1]=\set -> Pbind(\dur, Pseq([8],inf), \frec, Prand([600,700,800,900],inf), \t_trig, 1);

Ndef(\eho1).release

//fadeTime - release - send
Ndef(\eho2).release
Ndef(\eho3).release

/*
Ndef(\dos).play
Ndef(\dos,{|frec=400| Pan2.ar(LFTri.ar(frec,0,0.5),0)*EnvGen.kr(Env.perc(0.01,0.01),doneAction:2)})

// poner esto en un Tdef
Ndef(\dos).spawn([\frec,[500,900].choose])
*/