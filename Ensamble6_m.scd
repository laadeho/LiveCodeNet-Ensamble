//==================================================
//codigo para ensamble casero local
//==================================================
// instala el quark Open Object
s.boot;
OpenObject.start; // prende el OpenObject
OpenObject.lookup=true; // habilita la opción de recibir control
OpenObject.openProxies; // habilita los proxies Ndef, Pdef, Tdef, Fdef
OpenObject.end; // cierra la comunicación de openboject

// declaras los Ndef, se prenden mas abajo con los mensajes "/oo"
Ndef(\uno)[0]= {|f1=200|Pan2.ar(LFTri.ar(f1,0,0.3),0)};
Ndef(\uno).quant_(4)[1]= \set -> Pbind(\dur,0.25, \f1, Pseq([200,410,500,900],inf));

Ndef(\dos)[0]= {|f1=300|Pan2.ar(SinOsc.ar(f1,0,0.3),0)};
Ndef(\dos).quant_(4)[1]= \set -> Pbind(\dur, 0.25, \f1, Pseq([300,400,550,910],inf));

// la secuencia de este Ndef esta en la casa (dentro del OSCdef) 
Ndef(\tres).play;
Ndef(\tres)[0]={|f1,t_trig=1| Pan2.ar(LFTri.ar(f1,0,0.5)*EnvGen.kr(Env.perc(0.02,0.3),t_trig))};

// recibir mensajes de forma simple
(
OSCdef(\x, { |msg|
	var x = msg[1].postln;
	var y = msg[2].postln;
	Ndef(\tres)[0]={|f1=210, f2=310| LFTri.ar([x,y],0,0.5)};
}, "/her").fix;
);
// recibir mensajes en array con el método .unfoldOSCArrays (requiere Open Object)
(
OSCdef(\y, { |msg|
	var x = msg.unfoldOSCArrays[1].postln;
	var y = msg.unfoldOSCArrays[2].postln;
	Ndef(\tres).quant_(4)[1] = \set -> Pbind(\dur, y,\f1, Pseq(x, inf), \t_trig, 1);
}, "/her2").fix;
);

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
	q.sendAll(\hist, \lalo, code);
};
)

s.quit;


"Hola bandaaaaaaaaaaasssss"