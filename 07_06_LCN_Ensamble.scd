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
¼
	History.enter(msg[2].asString, msg[1]);
}, \hist).fix;
History.localOff;

History.forwardFunc = { |code|
	q.sendAll(\hist, \Lalo1, code);
};
);
"me ven? soy paquito, ya no hare travesuras"

//MANDELHUB LIB
m = MandelHub.start("LALO LIDER"); // SER EL LIDER

MandelHub.join("Lalo", action: {m=MandelHub.instance}); //UNIRSE A SESION DEL LIDER

m.clear //limpiar el mandel
m.gui	 //iniciar gui de mandel

m.changeTempo(1, 10);
m.changeTempo(60/60, 120);
m.changeTempo(120/60, 200);
m.changeTempo(140/60, 120);
m.TempoClock.default.tempo_(120/60)

//////////////////////////////////////
/////////////SYNTHS/////////////////
///////////////NDEF/////////////////
///////////////////////////////////////

//BUFFER
b=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/04/lo03.wav");
//b.bufnum			b.numFrames
Ndef(\eho_buf).play
//sin freeverb
Ndef(\eho_buf)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(b.numChannels,b.bufnum,rate,t_trig,posc,loop:1)*EnvGen.kr(Env.perc(1,1),t_trig),pan,amp)}

//con freeverb
Ndef(\eho_buf)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(FreeVerb.ar(PlayBuf.ar(b.numChannels,b.bufnum,rate,t_trig,posc,loop:1)*EnvGen.kr(Env.perc(0.1,0.75),t_trig),pan,amp),0.7, 0.5,0.8, amp)}

Ndef(\eho_buf).quant_(4)[1]=\set -> Pbind(\dur, Pseq([5,9],inf), \posc, Prand([0.52,0.5,0.55,0.48,0.1]*b.numFrames,inf),\rate, Pseq([-0.5],inf), \amp, Prand([0.4,0.5,0.6],inf), \pan, Prand([0],inf), \t_trig,1);
//posiciones 0.1, 0.13, 0.1,0.14

//Pitch, Echo, Reverb, 
Ndef(\eho_buf).release
b.release
(
Tdef (\retas, { loop
	{ [13,15].choose.wait;
		m.chat(["Live", "Code", "Net", "Ensamble"].choose);//.speak);
	}
}
).play
)
Tdef (\retas).stop

/04/lo01...lo13.wav
/04/loa01..loa03.aif
/////////////
c=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/01/lo02.wav");    
Ndef(\eho_buf2).play
Ndef(\eho_buf2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(c.numChannels,c.bufnum,rate,t_trig,posc,loop:1)*amp,0)*EnvGen.kr(Env.perc(0.1,0.05),t_trig)}

Ndef(\eho_buf2).quant_(4)[1]=\set -> Pbind(\dur, Prand([7,9,11,15].scramble,inf), \posc, Pseq([0.3,0.5,0.8]*c.numFrames,inf),\amp,0.5, \rate, Prand([0.5,0.6,0.7],inf), \t_trig,1)

//[Array.series(10,0,0.1)].choose*c.numFrames,inf

Ndef(\eho_buf2).release
c.release

Ndef(\ehox).play
Ndef(\ehox)[0]={|t_trig=1, freq=80, freq2=4, amp = 0.1| Pan2.ar(SinOsc.ar(freq,0,amp),0)*EnvGen.kr(Env.perc(1,8),t_trig)}

Ndef(\ehox).quant_(4)[1]=\set -> Pbind(\dur, Prand([8],inf),\amp, Prand([0.6,0.5,0.8,0.7],inf), \freq, Prand([80,84,86]-10, inf), \t_trig, 1);

Ndef(\ehox).release

////////REVISAR
Ndef(\eho3).play
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5, res= 4| Pan2.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1),0)*EnvGen.kr(Env.perc(1,5),t_trig)}

//Con resonador
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5, res = 4| Pan2.ar(RHPF.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1), FSinOsc.kr(XLine.kr(0.7,300,20), 0, 3600, 4000), 0.2),0)*EnvGen.kr(Env.perc(1,3),t_trig)}

//Con resonador en pdef
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5, res = 4| Pan2.ar(RHPF.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1), res, 0.2),0)*EnvGen.kr(Env.perc(1,3),t_trig)}

//prand resonando
Ndef(\eho3).quant_(4)[1]=\set -> Pbind(\dur, Prand([5,7,10,16],inf), \ac0,Prand([0,3,7,15],inf), \ac1,Prand([15,10,8,2],inf), \av0, Prand([8,6,8,10],inf), \av1, Prand([5,8],inf, \res, Prand([2,4,6,8,10]*500,inf)), \t_trig, 1);

Ndef(\eho3).release

///////////// 
g=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s03.aif");    
Ndef(\eho_buf2).play
Ndef(\eho_buf2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(g.numChannels,g.bufnum,rate,t_trig,posc,loop:1)*amp,0)*EnvGen.kr(Env.perc(0.05,0.2),t_trig)}

Ndef(\eho_buf2).quant_(4)[1]=\set -> Pbind(\dur, Prand([1].scramble,inf), \posc, Pseq([Array.series(18,0.1,0.05)]*g.numFrames,inf), \amp,1, \rate,Prand([1],inf), \t_trig,1)

//[Array.series(10,0,0.1)].choose*c.numFrames,inf

Ndef(\eho_buf2).release
c.release

///////////// VOZ
d=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s03.aif");
Ndef(\eho_buf3).play
Ndef(\eho_buf3)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.2,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(d.numChannels,d.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.01,0.1),t_trig)}

Ndef(\eho_buf3).quant_(4)[1]=\set -> Pbind(\dur, Pseq(([0.25]),inf), \posc, Prand(d.numFrames/[10],inf), \amp, Prand([0.75,0.7,0.6,0.5],inf), \rate, Prand([1],inf), \t_trig,1)

Ndef(\eho_buf3).release
d.release

/////////////Perc
e=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/04/lo13.wav");
Ndef(\eho_buf0)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(e.numChannels,e.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.1,0.1),t_trig)}

Ndef(\eho_buf0).quant_(4)[1]=\set -> Pbind(\dur, Prand([0.5,1,0.5,0.25]*4,inf), \posc,Pseq(e.numFrames/[15.2],inf), \amp, Prand([0.8,0.5,0.9],inf), \rate, Prand([1],inf), \t_trig,1)
Ndef(\eho_buf0).play
Ndef(\eho_buf0).release
e.release
///////////////////////////////////////////

f=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s02.aif");
Ndef(\eho_buf1)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(f.numChannels,f.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.2,0.01),t_trig)}

Ndef(\eho_buf1).quant_(4)[1]=\set -> Pbind(\dur, Pseq([2,4,6,8,1,1,2],inf), \posc,Pseq(f.numFrames/[2,4,6,8],inf), \amp, Prand([0.35],inf), \rate, Prand([1],inf), \t_trig,1)
Ndef(\eho_buf1).play
Ndef(\eho_buf1).release
f.release
