//======
//Ndef
//======
m.TempoClock.default.tempo_(120/60)
Ndef(\eho1).play
Ndef(\eho1)[0]={|frec=400,t_trig=1| Pan2.ar(FSinOsc.ar(frec,0,0.5),0)*EnvGen.kr(Env.perc(0.01,0.3),t_trig)}

Ndef(\eho1).quant_(4)[1]=\set -> Pbind(\dur, Pseq([5],inf), \frec, Pseq([70,80,90]*3,inf),\t_trig,1) 

Ndef(\eho2).play
Ndef(\eho2)[0]={|frec=80,t_trig=1| Pan2.ar(SinOsc.ar(frec,0,0.85),0)*EnvGen.kr(Env.perc(0.01,0.03),t_trig)}

Ndef(\eho2).quant_(4)[1]=\set -> Pbind(\dur, Pseq([2],inf), \frec, Prand([70,80]*1.1,inf),\t_trig,1) 


Ndef(\dos).play
Ndef(\dos,{|frec=400| Pan2.ar(LFTri.ar(frec,0,0.5),0)*EnvGen.kr(Env.perc(0.01,0.1),doneAction:2)})

// poner esto en un Tdef
Ndef(\dos).spawn([\frec,[500,900].choose])

