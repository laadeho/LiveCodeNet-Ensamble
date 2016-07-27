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
//History
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

//Preparar contenidos para las 3 secciones de la presetaci—n, 

//MANDELHUB LIB
m = MandelHub.start("LALO L"); // SER EL LIDER

MandelHub.join("Lalo", action: {m=MandelHub.instance}); //UNIRSE A SESION DEL LIDER

m.clear //limpiar el mandel
m.gui	 //iniciar gui de mandel

m.timer.reset

m.changeTempo(80/60, 0); //
m.changeTempo(60/60, 120);

m.changeTempo(110/60, 60);

m.changeTempo(140/60, 120);
m.TempoClock.default.tempo_(120/60);


//////
(
Tdef (\t, { loop
	{ 180.wait;
		m.chat(["han pasado 3 minutos, cambio, reta o algo"]);//.speak);
	}
}
).play
)
Tdef (\t).stop

("Live Code Net Ensamble").speak

////////////////////////////////////////////
/////////////SYNTHS/////////////////
///////////////NDEF///////////////////
////////////////////////////////////////////
m.timer.reset

s.scope
//BASS
Ndef(\eho1).play
Ndef(\eho1)[0]={|frec=80, t_trig=1, amp=0.5, dur2=12| Pan2.ar(WhiteNoise.ar(0.001)+SinOsc.ar(frec,0,amp),0)*EnvGen.kr(Env.perc(0.01,0.1),t_trig)}
//
Ndef(\eho1).quant_(4)[1]=\set -> Pbind(\dur, Pseq([1,2,1],inf), \frec, Prand([60,62,61],inf), \amp, Prand([0.3,0.45,0.2,0.15]*1.4,inf), \t_trig,1)
//
Ndef(\eho1).release
60,80,100,120

Ndef(\eho2).play
Ndef(\eho2)[0]={|t_trig=1, freq=80, amp=0.2| Pan2.ar(WhiteNoise.ar(0.2)+SinOsc.ar(0.05,0,0.4,0.4)*Saw.kr(40,0.4),0)*EnvGen.kr(Env.perc(5,5),t_trig)}

Ndef(\eho2).quant_(4)[1]=\set -> Pbind(\dur, Prand([13,15],inf), \freq,Pseq([80,82],inf), \amp, Prand([0.3,0.4,0.6]*0.6,inf), \t_trig, 1);
Ndef(\eho2).release

"good bye".speak

[60,63,67,71,74] o cual estan usando?
//////ATARI
Ndef(\eho3).play
Ndef(\eho3)[0]={|t_trig=1, pulsos= 4, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5| Pan2.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1),0)*EnvGen.kr(Env.perc(0.01,0.1),t_trig)}

Ndef(\eho3).quant_(4)[1]=\set -> Pbind(\dur, Prand([4,8],inf), \pulsos, Prand([40],inf), \ac0,Pseq([14],inf), \ac1,Prand([12],inf), \av0, Prand([1,2,3],inf), \av1, Prand([3,2,1],inf), \t_trig, 1);
Ndef(\eho3).release

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
		m.chat(["Live", "Code", "Net", "Ensamble"].choose.speak);//.speak);
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
Ndef(\ehox)[0]={|t_trig=1, freq=80, freq2=4, amp = 0.1| Pan2.ar(SinOsc.ar(freq,0,amp),0)*EnvGen.kr(Env.perc(0.05,0.2),t_trig)}

Ndef(\ehox).quant_(4)[1]=\set -> Pbind(\dur, Prand([2],inf),\amp, Prand([0.6,0.5,0.8,0.7],inf), \freq, Prand([80,84,86]-10, inf), \t_trig, 1);

Ndef(\ehox).release

////////REVISAR
Ndef(\eho3).play
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5, res= 4| Pan2.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1),0)*EnvGen.kr(Env.perc(0.1,0.15),t_trig)}

//Con resonador
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5, res = 4| Pan2.ar(RHPF.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1), FSinOsc.kr(XLine.kr(0.7,300,20), 0, 3600, 4000), 0.2),0)*EnvGen.kr(Env.perc(1,3),t_trig)}

//Con resonador en pdef
Ndef(\eho3)[0]={|t_trig=1, ac0= 10, ac1= 15, af0= 3, af1= 4, av0= 5, av1= 5, res = 4| Pan2.ar(RHPF.ar(Atari2600.ar(ac0, ac1, af0, af1, av0, av1), res, 0.2),0)*EnvGen.kr(Env.perc(1,3),t_trig)}

//prand resonando
Ndef(\eho3).quant_(4)[1]=\set -> Pbind(\dur, Prand([8,16,24],inf), \ac0,Prand([0,3,7,15,10],inf), \ac1,Prand([15,10,8,2],inf), \av0, Prand([8,6,8,10],inf), \av1, Prand([5,8],inf, \res, Prand([2,4,6,8,10]*500,inf)), \t_trig, 1);

Ndef(\eho3).release