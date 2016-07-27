//==================================================
//codigo para ensamble casero local
//==================================================
// instala el quark Open Object
s.boot;
OpenObject.start; // prende el OpenObject
OpenObject.lookup=true; // habilita la opciÃ³n de recibir control
OpenObject.openProxies; // habilita los proxies Ndef, Pdef, Tdef, Fdef
OpenObject.end; // cierra la comunicaci—n de openboject

// declaras los Ndef, se prenden mas abajo con los mensajes "/oo"
Ndef(\aa)[0]={SinOsc.ar([180,185],0,0.75)};
Ndef(\aa).play
Ndef(\aa).free

Ndef(\bb)[0]={SinOsc.ar([180,185]*2,0,0.75)*Pulse.kr(0.05)};
Ndef(\bb).play
Ndef(\bb).free

NdefMixer(s)   //GUI DE NDEFS ACTIVOS

Ndef(\eho).quant_(4)[1]= \set -> Pbind(\dur,0.25, \f1, Pseq([200,410,500,900],inf));

Ndef(\aa).quant_(4)[1]= \set -> Pbind(\dur,0.25, \f1, Pseq([200,410,500,900],inf));

Ndef(\bb)[0]= {|f1=300|Pan2.ar(SinOsc.ar(f1,0,0.3),0)};
Ndef(\bb).quant_(4)[1]= \set -> Pbind(\dur, 0.25, \f1, Pseq([300,400,550,910],inf));

// la secuencia de este Ndef esta en la casa (dentro del OSCdef) 
Ndef(\cc).play;
Ndef(\cc)[0]={|f1,t_trig=1| Pan2.ar(LFTri.ar(f1,0,0.5)*EnvGen.kr(Env.perc(0.02,0.3),t_trig))};

// recibir mensajes de forma simple // modificado

////////////////////////////////////////
	Ndef(\eho).quant_(4)[0]={|f1=90, f2=95| SinOsc.ar([f1,f2]*2,0,0.75)*Pulse.kr(1)+WhiteNoise.kr(0.7)*Impulse.kr(2)};
	Ndef(\eho).quant_(4)[0]={|f1=90, f2=95, t_trig=1| SinOsc.ar([f1,f2]*[0.5,0.7,1,2].choose,0,0.7)*EnvGen.kr(Env.perc(0.02,0.3),t_trig)}
///////////////////////////////////////
	
Ndef(\eho2).quant_(1)[0]={|f1=90, f2=95| WhiteNoise.ar([SinOsc.kr(SinOsc.kr(0.5,0,0.2,0.04),0,0.05,0.1), SinOsc.kr(0.05,0,0.05,0.1)])*Crackle.kr(0.9)*SinOsc.kr(0.1,0,1,2)+SinOsc.ar([180,190],0,0.2)*Pulse.kr(0.025)*0}
Ndef(\eho2).play;
Ndef(\eho2).free

////////////////////////////////////////

[f1,f2]*[0.5,0.7,1,2].choose,0,0.75)*Pulse.kr(2)};

///////// DE LIBERTAD
Ndef(\liber3)[0]= {|f1=640, amp=0.1| Pan2.ar(SinOsc.ar(f1),0,0.5)};
Ndef(\liber3).quant_(4)[1]= \set -> Pbind(\dur, 0.25, \f1, Pxrand([840,440,940,740],inf), \amp, Pxrand([0.1,0,0.1,0,0.3],inf));
////////

	Ndef(\eho).quant_(4)[0] = \set -> Pbind(\f1, Prand([0.5,0.25,1,2]*90,inf), \t_trig, 1 );
	Ndef(\eho).fadeTime = 0;
	
// recibir mensajes en array con el mŽtodo .unfoldOSCArrays (requiere Open Object)
(
OSCdef(\y, { |msg|
	var x = msg.unfoldOSCArrays[1].postln;
	var y = msg.unfoldOSCArrays[2].postln;
	Ndef(\cc).quant_(4)[1] = \set -> Pbind(\dur, y,\f1, Pseq(x, inf), \t_trig, 1);
}, "/her2").fix;
);

"no quiero"

// establecer NetAddr para enviar datos a todos los conectados en la red
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

// enviar datos
q.sendAll("/her", 400, 500); // valores simples
q.sendAll("/her", 1.0.rrand(3.0), 2.0.rrand(4.0))// valores simples entre 1.0 y 3.0, 2.0 y 4.0

q.sendAll("/her2", *[[200,201,208,900,300,800,789,230],0.25].asOSCArgArray);//array y valor

q.sendAll("/muerto", "9xxxcccc") // ascii
// declarando estas lineas dices que se prendan al mismo tiempo dos Ndef
(
q.sendAll("/oo", \Ndef_uno, \play);
q.sendAll("/oo", \Ndef_dos, \play);
)

// compartir codigo mediante History
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

s.quit;
