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
m = MandelHub.start("LALO L"); // SER EL LIDER

MandelHub.join("Lalo", action: {m=MandelHub.instance}); //UNIRSE A SESION DEL LIDER

m.clear //limpiar el mandel
m.gui	 //iniciar gui de mandel

m.changeTempo(1, 10);
m.changeTempo(80/60, 0);
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
Ndef(\eho_buf)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(b.numChannels,b.bufnum,rate,t_trig,posc,loop:1)*EnvGen.kr(Env.perc(0.1,0.35),t_trig),pan,amp)}

//con freeverb
Ndef(\eho_buf)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(FreeVerb.ar(PlayBuf.ar(b.numChannels,b.bufnum,rate,t_trig,posc,loop:1)*EnvGen.kr(Env.perc(0.1,0.75),t_trig),pan,amp),0.7, 0.5,0.8, amp)}

Ndef(\eho_buf).quant_(4)[1]=\set -> Pbind(\dur, Prand([2],inf), \posc, Prand([0.13,0.5,0.75]*b.numFrames,inf),\rate, Prand([1],inf), \amp, Prand([0.15],inf), \pan, Prand([0],inf), \t_trig,1);
Ndef(\eho_buf).release

////////////////////
d=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s04.aif");
Ndef(\eho_buf3)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=0.2,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(d.numChannels,d.bufnum,rate,t_trig,posc,loop:1)*amp)*EnvGen.kr(Env.perc(0.5,1),t_trig)}

Ndef(\eho_buf3).quant_(4)[1]=\set -> Pbind(\dur, Pseq([4,8],inf), \posc, Prand(d.numFrames/[2,2.2,2.3,3],inf), \amp, Prand([0.2,0.25],inf), \rate, Prand([1,-1],inf), \t_trig,1)

Ndef(\eho_buf3).play
Ndef(\eho_buf3).release
d.release

///////////////////

/////////////////////
g=Buffer.read(s,"/Applications/SuperCollider_no_ide/sounds/03/s03.aif");    
Ndef(\eho_buf2).play
Ndef(\eho_buf2)[0]={|t_trig=1,rate=1,trig=0.5,posc=1000,amp=1,pan=0| var sen,env; sen=Pan2.ar(PlayBuf.ar(g.numChannels,g.bufnum,rate,t_trig,posc,loop:1)*amp,0)*EnvGen.kr(Env.perc(0.05,0.2),t_trig)}

Ndef(\eho_buf2).quant_(4)[1]=\set -> Pbind(\dur, Prand([1].scramble,inf), \posc, Pseq([Array.series(18,0.1,0.05)]*g.numFrames,inf), \amp,1, \rate,Prand([1],inf), \t_trig,1)

//[Array.series(10,0,0.1)].choose*c.numFrames,inf

Ndef(\eho_buf2).release
c.release
/////////////////////


Ndef(\eho3).play
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5| Pan2.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1),0)*EnvGen.kr(Env.perc(0.1,0.75),t_trig)}

Ndef(\eho3).quant_(4)[1]=\set -> Pbind(\dur, Prand([1,2,4,3,5],inf), \ac0,Prand([2,3,8,10],inf), \ac1,Prand([14,12],inf), \av0, Prand([8,6,8,10],inf), \av1, Prand([0],inf), \t_trig, 1);

Ndef(\eho3).release

//////////////////

Ndef(\eho_buf2).release
c.release

Ndef(\ehox).play
Ndef(\ehox)[0]={|t_trig=1, freq=80, freq2=4, amp = 0.1| Pan2.ar(SinOsc.ar(freq,0,amp),0)*EnvGen.kr(Env.perc(1,8),t_trig)}

Ndef(\ehox).quant_(4)[1]=\set -> Pbind(\dur, Prand([8],inf),\amp, Prand([0.6,0.5,0.8,0.7],inf), \freq, Prand([80,84,86]-10, inf), \t_trig, 1);

Ndef(\ehox).release

