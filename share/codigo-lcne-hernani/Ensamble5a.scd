//==================================================
// codigo para ensamble LCNE - post-vivo2013
//==================================================
s.boot;
s.makeGui
// ---
Ndef(\unoA).play
Ndef(\unoA)[0]={|f1=48,t_trig=1,amp=0.05| Pan2.ar(LFTri.ar(f1,0,LFTri.kr(16,0,0.1,0.2)),0,add:1)};

Ndef(\unoA).quant_(4)[1]= \set -> Pbind(\dur,Pseq([1.5,0.5],inf),\f1, Pseq([48,51,48,53].midicps,inf),\amp,0.2);
Ndef(\unoA).stop(3)
// ---
Ndef(\hhH).play
Ndef(\hhH)[0]={|freq=12000,vol=0.2,t_trig=1| Pan2.ar(MoogFF.ar(WhiteNoise.ar(vol),freq),0.1)*EnvGen.kr(Env.perc(0.01,0.1),t_trig)}

Ndef(\hhH).quant_(4)[1]=\set -> Pbind(\dur,1/4,\t_trig,1,\freq,Pseq([\12000,\12000,12000,\12000],inf))
Ndef(\hhH).stop(2)
//convertir
Ndef(\hhH).quant_(4)[1]= \set -> Pbind(\dur, Pseries(0,1,1000).select({|num|((num%3)==0).or((num%7)==0)}).differentiate, \stretch, 1/4, \vol, Pseq([0,0.3],inf),\t_trig, 1, \freq, 12000);

// --- bd 
Ndef(\bdH).play
Ndef(\bdH)[0]={|frec=100,vol=0.9,t_trig=1| Pan2.ar(SinOsc.ar(frec,pi,vol)*EnvGen.kr(Env.perc(0.01,0.1),t_trig),0)};

Ndef(\bdH).quant_(4)[1]= \set -> Pbind(\dur, Pseq([1],inf), \vol, 0.9, \t_trig, 1, \frec,100);
//[1.5,2.5],[1,1,0.5,0.5,1],[1,1,0.25,0.5,0.25,1],[1,0.75,0.25,0.25,0.25,0.5,1]
Ndef(\bdH).stop(8)

// --- sd
(
SynthDef(\sdH, {|amp,line|
			var sig, sig2, freq, env, env2;
			
			freq=XLine.kr([450,line],100,0.2);
			sig=SinOsc.ar(freq,0,0.7)!2;
			sig2=WhiteNoise.ar(0.4);
			env2=EnvGen.kr(Env.perc(0.01,0.15,1,-8),doneAction:2);
			env=EnvGen.kr(Env.perc(0.01,0.2,1,-8),doneAction:2);
			Out.ar(0,(sig*env)+(sig2*env2)*amp*0.4);
			}).add;
);
~sd=Pdef(\sdH, Pbind(\instrument,\sdH,\dur,1/4,\amp, Pseq([0,0,0,0,0.35,0,0,0],inf),\line,Pseq([100],inf))).quant_(4);
~sd.play;
~sd.stop

//===================================================================
// SET abstract
//===================================================================
Ndef(\uno).play;
Ndef(\uno).fadeTime=8; 
Ndef(\uno, {LFTri.ar({200.0.rrand(510.0)}.dup(3),0,{0.1.rand}.dup(3))});
Ndef(\uno).release;
Ndef(\uno).send;

Ndef(\moog).play; // mouseX
Ndef(\moog,{|mod=30|MoogFF.ar(Pulse.ar(LFNoise0.kr(mod,200,501),0.3,0.2),MouseY.kr(300,7000,1),LFNoise1.kr(40,2.0,2.0))!2});
Ndef(\moog).fadeTime=5;
Ndef(\moog).release;
Ndef(\moog).xset(\mod,100)
Ndef(\moog).stop(6);

// Ndef con envolvente, un solo impuslo
Ndef(\dos).play;
Ndef(\dos, {|f1=120,f2=300| LFTri.ar([f1,f2+rrand(20.0,600.0)],0,LFNoise0.kr(50))*EnvGen.kr(Env.perc(0.03,0.9),doneAction:2)*0.2})
Ndef(\dos).rebuild;
Ndef(\dos).fadeTime=1;

Ndef(\partial).play;
Ndef(\partial).fadeTime=10;
Ndef(\partial,{|f1=100| Pan2.ar(LFTri.ar(f1+{200.rrand(216.0)}.dup(8),{-2pi.rrand(2pi)}.dup(8),0.01+SinOsc.kr({0.01.rrand(0.1)}.dup(8),0,0.1)),0)})
Ndef(\partial).release;
Ndef(\partial).xset(\f1,300);

Ndef(\rms).play;
Ndef(\rms).fadeTime=5;
Ndef(\rms,{|sum=100, mod=70|Mix(Array.fill(3,{Pan2.ar(SinOsc.ar(((Array.series(10,rrand(200,210),100).sqrt)+sum).postln,0,0.2),0,0.3*Saw.ar(mod,0.75),rrand(-1.0,1.0),1.0.rand)}))*0.4});
Ndef(\rms).send;
Ndef(\rms).release;
Ndef(\rms).xset(\sum,260,\mod, 12);
// --- atmos
Ndef(\atmos).play;

Ndef(\atmos)[0]={|f1=222, pan=0,t_trig=1,rel=0.09| Pan2.ar(DynKlank.ar(`[[f1,f1*1.62,f1*1.9,f1*4.8],nil,[0.5,0.5,0.8,0.5]],PinkNoise.ar(0.0024)),pan,1)*EnvGen.kr(Env.perc(0.02,rel),t_trig)*3};

Ndef(\atmos).quant_(4)[1]=\set -> Pbind(\dur,Pseq([Pn(1/2,1),6,1,8],inf),\f1,Pbrown(100,700,10,inf),\t_trig, 1,\rel,Pwhite(0.09,1.5));
Ndef(\atmos).stop(2);

// ---
Ndef(\smallSeq).play;
Ndef(\smallSeq)[0]={|f1,f2,t_trig=1,rel=0.1| Pan2.ar(SyncSaw.ar(f1,f2,0.1)*EnvGen.kr(Env.perc(0.01,rel),t_trig),0)};

Ndef(\smallSeq).quant_(4)[1]= \set -> Pbind(\dur, Pseq([2,5,1],inf), \f1, Pseq([80,130],inf),\f2,Prand([60,180,120,300].mirror,inf),\t_trig,1,\rel,0.9);
Ndef(\smallSeq).stop(2);

// ---
Ndef(\cd).play;
Ndef(\cd)[0]={|f1,t_trig=1,rel=0.03| Pan2.ar(LFTri.ar(f1,0,0.4)*EnvGen.kr(Env.perc(0.02,rel),t_trig))};

Ndef(\cd).quant_(4)[1] = \set -> Pbind(\dur, Pseq([1/4,Pn(1/8,4),1/4],inf),\f1, Pseq([160,80,120,400,80,230], inf), \t_trig, 1,\rel, Pseq([0.03,Pn(0.01,3),0.5,1],inf));
Ndef(\cd).stop(2)




