//written by @joseCao5
//03oct2013
//
s.boot;
s.quit;
s.scope;
s.makeWindow;// usa -3db master
//LC valores:
// demand triggers = 0.033,0.33,0.66,1,3,6 tiempos
// GVerb roomsize = (1..12) da buenos colores
//multiplicador de la frecuencia modulada "var senal" 0.033,0.066,0.33,0.66,1,3,6
//quitar y poner las variables(senales)
(//cada que se evalua cambia el reverb
x=Ndef(\nosheet,{
			var t=Impulse,left,right,senal,senal2,vroom;
			var mods=Demand.kr(t.kr(3),0,Drand([1,3,6],inf));
			var panl=Demand.kr(t.kr(3),0,Dxrand([-0.7,-0.5,-0.3,-0.1,0.1,0.3,0.5,0.7],inf));
			var freq=Demand.kr(t.kr(mods),0,Drand(Array.series(24,100,600),inf));
			var qr=Duty.kr(Dseq([0.66,0.33],inf),0,Dxrand([0.1,0.3,0.5,0.6],inf));
			left=panl;
			right=panl;
			vroom=[1,1.1,1.3,1.5,1.75,2,2.4,3,6,9,12].scramble.pyramid.choose.postcln;
			senal=LFTri.ar(Pulse.ar(Mix(mods/3,mods*0.33),panl,freq,freq+(freq/4)),0,0.2)*Pulse.ar(mods,panl,0.1);
			senal=Compander.ar(senal,senal,0.5,0.45,0.25);
			senal=Limiter.ar(senal,0.65);
			senal=GVerb.ar(senal,vroom,qr*1.66,0.05);
			senal2=BPF.ar(senal,Phasor.kr(t.kr(0.33),1,1440,14000),qr*2);
			senal2=CombC.ar(senal2,0.33,mods/9,mods/6);
			senal2-Limiter.ar(senal2,0.75);
			Out.ar(0,Limiter.ar(Compander.ar(Pan2.ar(senal+senal2,[left,right]),0.5,0.51,0.5),0.1));
				});
);
x.play;
x.free;
//
Help.gui
y=Ndef(\graves,{Out.ar(0,Pan2.ar(SinOsc.ar(LFNoise0.kr(4)+32.midicps,0,0.5)*LFNoise2.ar(8),[1,-1]))});
y.play;
//y.free;
//
//Phasor.kr(t.kr(mods),0.01,600,12000)//

