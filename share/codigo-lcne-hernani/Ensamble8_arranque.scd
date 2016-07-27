//=============================================
//ENSAMBLE CODE - arranque
//=============================================
s.boot;
s.meter;
s.makeGui;
s.queryAllNodes
s.plotTree
NdefMixer(s)
//=============================================
//conexion a la red
//=============================================
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
);
//===============================================
//History
//===============================================
(
History.start;
History.makeWin;

OSCdef(\hist, { |msg| 
	/*msg.postln;*/
	History.enter(msg[2].asString,msg[1]);
}, \hist).fix;
History.localOff;

History.forwardFunc = { |code| 
	q.sendAll(\hist, \hernani, code);
};
);
//=================================
//MandelHub
//=================================
m = MandelHub.start("hernani");
m.gui
MandelHub.join("hernani", action:{m=MandelHub.instance});
m.gui
//tomar liderazgo
m.takeLead;
// reiniciar tiempo
m.timer.reset
// cambiar tempo
m.changeTempo(122/60,1)
// fin
m.clear
//=================================
//codigo sonoro
//=================================
Ndef(\primero).play
Ndef(\primero)[0]= {|freq=48,t_trig=1,vol=0.25,pan=0| Pan2.ar(Saw.ar(freq,vol),pan)*EnvGen.kr(Env.perc(0.01,0.3),t_trig)}

Ndef(\primero).quant_(4)[1]=\set -> Pbind(\dur, 1/4,\freq,Pseq([79,\r,Pn(74,2),\60,50,48,65].midicps,inf),\t_trig,1,\vol,Pseq([0.1,0.3,0.2,0.1]*0.8,inf),\pan, Pseq([0],inf));

Ndef(\primero).release
// --- extra lowfreq //sin midicps
Ndef(\segundo).play
Ndef(\segundo)[0]={|freq=400,t_trig=1,vol=0.45| Pan2.ar(LFTri.ar(freq,0,LFCub.kr(16,0,0.1,0.25)),0,vol)*EnvGen.kr(Env.perc(0.01,0.8),t_trig)}

Ndef(\segundo).quant_(4)[1]=\set -> Pbind(\dur, Pseq([1],inf),\freq,Pseq([55],inf),\t_trig,1)//no midi
Ndef(\segundo).quant_(4)[1]=\set -> Pbind(\dur, Pseq([1,1,0.5,0.5,1],inf),\freq,Pseq([48,72,48,71].midicps,inf),\t_trig,1)

Ndef(\segundo).release
// --- no seq
Ndef(\oko).play
Ndef(\oko,{Pan2.ar(LFNoise0.ar(1.0.rrand(12.0))*LFTri.ar(rrand(200,700),0,0.15),-1.rrand(1.0))*EnvGen.kr(Env.perc(0.2.rrand(0.5),1.5.rrand(0.5)),doneAction:2)})
// ---
Ndef(\oki).play
Ndef(\oki)[0]={|frec=400,t_trig=1|Pan2.ar(SinOsc.ar(frec,0,0.3),0)*EnvGen.kr(Env.perc(0.5,0.6),t_trig)}

Ndef(\oki)[1]=\set -> Pbind(\dur,Pseq([1/2,1/4,8],inf),\t_trig,1,\frec,Pseq([48,51].midicps,inf),\t_trig,1)
Ndef(\oki).stop(2)
// --- no seq
Ndef(\okl).play
Ndef(\okl,{LFTri.ar([rrand(100.0,200.0),rrand(100.0,3000.0)],0,LFNoise0.kr(5)*0.5)*EnvGen.kr(Env.perc(0,5))*0.2})
// --- prip
Ndef(\osc).play
Ndef(\osc)[0]={|frec=13000,t_trig=1,pan=0,rel=0.3,vol=0.1|Pan2.ar(LFTri.ar(frec,0,vol),pan)*EnvGen.kr(Env.perc(0.01,rel),t_trig)}

Ndef(\osc)[1]=\set -> Pbind(\dur,Prand([0.012,0.025,0.03,0.05,8],inf),\frec,Pwhite(100,10000,inf),\t_trig,1,\pan, Pseq([1,-1,0],inf),\rel,Pwhite(0.01,0.05,inf),\vol,Pwhite(0.1,0.2,inf))
Ndef(\osc).stop(3)

// --- WhiteNoisy
Ndef(\wh).play
Ndef(\wh, {|time=9.5| Pan2.ar(SinOsc.ar(300.0.rrand(1450.0),0,Line.kr(0.01,0.25,time,doneAction:2))*BrownNoise.ar(Line.kr(0.01,0.55,time,doneAction:2)),0)})
// ---
Ndef(\cc).play
Ndef(\cc,{Pan2.ar(LFTri.ar(100.0.rrand(2000.0),0,SinOsc.kr(16,0,0.1,0.1)),0)*EnvGen.kr(Env.perc(9,0.001,-4),doneAction:2)}*0.25)

// --- funcional synth
Ndef(\rev).play
Ndef(\rev).fadeTime=3
Ndef(\rev,{FreeVerb.ar(Ndef.ar(\y),0.2,0.85,1)})

Ndef(\y)[0]={|f1=60,f2=63,f3=67,f4=72,v1=0.1,v2=0.1,v3=0.1,v4=0.1,t_trig=1| Splay.ar(Saw.ar([f1.midicps,f2.midicps,f3.midicps,f4.midicps],[v1,v2,v3,v4])) * EnvGen.kr(Env.perc(0.01,1),t_trig)}

Ndef(\y).quant_(4)[1]=\set -> Pbind(\dur,2, \t_trig,1)

Ndef(\rev).stop


