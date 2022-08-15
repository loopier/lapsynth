(
SynthDef(\white, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var sig = WhiteNoise.ar(amp);
	Out.ar(out, sig);
}).add;

SynthDef(\pink, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var sig = PinkNoise.ar(amp);
	Out.ar(out, sig);
}).add;

SynthDef(\brown, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var sig = BrownNoise.ar(amp);
	Out.ar(out, sig);
}).add;

SynthDef(\sine, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var feedback = \feedback.kr(0);
	var sig = SinOscFB.ar(freq, feedback, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\tri, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var width = \width.kr(0.5);
	var sig = VarSaw.ar(freq, 0, width, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\saw, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var sig = Saw.ar(freq, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\pulse, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var width = \width.kr(0.5);
	var sig = Pulse.ar(freq, width, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\lfpulse, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(1);
	var width = \width.kr(0.5);
	var sig = LFPulse.ar(freq, 0, width, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\envperc, {
	// var in = \in.kr(0);
	var out = \out.kr(0);
	var gate = \gate.kr(1);
	var env = EnvGen.ar(Env.perc(\atk.kr(0.01), \rel.kr(1)), gate, doneAction: 0);
	Out.ar(out, env);
}).add;

SynthDef(\vca, {
	// use with Ndef(\bla).bus
	// var in = \in.kr(0);
	// var sig = In.ar(in);

	// use with Ndef(\bla)
	var sig = \in.ar(0);

	var out = \out.kr(0);
	var amp = \amp.kr(1);
	Out.ar(out, sig * amp);
}).add;
)
