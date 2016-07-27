(
Tdef(\lcn, { 
s.options.sampleRate=44100;
0.5.wait;
s.boot.doWhenBooted( {
0.5.wait;
s.meter;
0.5.wait;
s.makeGui;
0.5.wait;
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
0.5.wait;
(
History.start;
History.makeWin;

OSCdef(\hist, { |msg| 
	/*msg.postln;*/
	History.enter(msg[2].asString,msg[1]);
}, \hist).fix;
History.localOff;

History.forwardFunc = { |code| 
	q.sendAll(\hist, \lalo, code);
};
);
0.5.wait;
Ndef(\soundcheck).play;
0.5.wait;

Ndef(\soundcheck)[0]={|vol=0.55,paner=0|Pan2.ar(PinkNoise.ar(vol),paner)}; // the synth
0.5.wait;
Ndef(\soundcheck)[1]=\set -> Pbind(\dur,1,\vol,Pseq([0,0.55,0,0.55],inf),\paner,Pseq([-1,-1,1,1],inf)); // the sequencer
4.wait;

Ndef(\soundcheck).stop; // stop that noise!!
0.5.wait;

//m = MandelHub.start("lalo"); // if I start as the leader
//0.5.wait;
//m.gui; // a gui of MandelHub

MandelHub.join("lalo", action:{m=MandelHub.instance});// if I join the leader
0.5.wait;
m.gui; // a gui of MandelHub*/
})
}).play
)

0.5.wait;
//m.takeLead; // to take the leader
//m.timer.reset; // to reset time

m.changeTempo(122/60, 1); // to change the time (bpm, time)

m.clear; // to finish the Mandel connection
