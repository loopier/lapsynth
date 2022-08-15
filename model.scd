s.boot;
(
var oscdict = Dictionary.new;
var envdict = Dictionary.new;
var vcadict = Dictionary.new;
var specs = ControlSpec.specs.know_(true);
specs.width = ControlSpec(0.01, 0.99, \lin, 0.01, 0.5, nil, nil);
// specs.atk = ControlSpec(0.01, 0.99, \lin, 0.0, 0.01, nil, nil);
// specs.dec = ControlSpec(0.0, 0.99, \lin, 0.0, 0.3, nil, nil);
// specs.sus = ControlSpec(0.0, 2.0, \lin, 0.0, 0.5, nil, nil);
// specs.rel = ControlSpec(0.0, inf, \lin, 0.0, 1.0, nil, nil);
specs.feedback = ControlSpec(0.0, inf, \lin, 0.0, 0.0, nil, nil);
oscdict.put(\sine, { SinOsc.ar(
	\freq.kr(spec: specs.freq),
	\phase.kr(spec: specs.phase)
)});
oscdict.put(\tri, { LFTri.ar(
	\freq.kr(spec: specs.freq),
	\iphase.kr(spec: specs.phase)
)});
oscdict.put(\saw, { Saw.ar(\freq.kr(spec: specs.freq)) });
oscdict.put(\pulse, { Pulse.ar(
	\freq.kr(spec: specs.freq),
	\width.kr(spec: specs.width)
)});
oscdict.put(\white, { WhiteNoise.ar() });
oscdict.put(\pink, { PinkNoise.ar() });
oscdict.put(\brown, { BrownNoise.ar() });
envdict.put(\adsr, { EnvGen.ar(envelope: Env.adsr(specs.envadsr), gate: \t_gate.kr(specs.gate))});
envdict.put(\perc, { EnvGen.ar(envelope: Env.perc(\atk.kr(0.01), \rel.kr(1)), gate: \gate.kr(1), doneAction: 2) });
vcadict.put(\vca1, { \in.ar * \amp.ar });

Ndef(\lfo1, oscdict[\pulse]).set(\freq, 1/2);
Ndef(\vco1, oscdict[\pulse]).set(\freq, 100);
Ndef(\env1, envdict[\perc]).set(\gate, Ndef(\lfo1));
Ndef(\out, vcadict[\vca1]).set(\in, Ndef(\vco1), \amp, Ndef(\env1));
// Ndef(\env, envdict[\adsr]);
)
ControlSpec.specs.keys.asArray.sort.collect(_.postln)
ControlSpec.specs[\envadsr].class
ControlSpec.specs[\gate]
s.boot.meter

EnvGen.ar(Env(ControlSpec.specs.envadsr.asSpec))
ControlSpec.specs
s.boot;
s.scope
Ndef(\out).stop
Ndef(\out).play
Ndef.freeAll
d = IdentityDictionary.new.know_(true)