s.boot;
(
var specs = ControlSpec.specs.know_(true);
specs.width = ControlSpec(0.01, 0.99, \lin, 0.01, 0.5, nil, nil);
specs.atk = ControlSpec(0.01, 0.99, \lin, 0.0, 0.01, nil, nil);
specs.dec = ControlSpec(0.0, 0.99, \lin, 0.0, 0.3, nil, nil);
specs.sus = ControlSpec(0.0, 2.0, \lin, 0.0, 0.5, nil, nil);
specs.rel = ControlSpec(0.0, inf, \lin, 0.0, 1.0, nil, nil);
specs.feedback = ControlSpec(0.0, inf, \lin, 0.0, 0.0, nil, nil);

"synthdefs/synthdef-oscillators.scd".loadRelative;
"gui.scd".loadRelative;
// "keymap.scd".loadRelative;
// // set an oscillator
// Ndef(\osc, \tri);
// // lfo
// Ndef(\lfo, \lfpulse).set(\freq, 1);
// Ndef(\env, \envperc).set(\gate, Ndef(\lfo));
// Ndef(\out, \vca).set(\in, Ndef(\osc), \amp, Ndef(\env));
)

Ndef(\env).play
Ndef(\env).stop
Ndef(\out).play;
Ndef(\out).stop;
Ndef.all
Ndef.clear
Ndef.freeAll
s.freeAll
Ziva.synths
ControlSpec.specs.keys.asArray.sort.collect(_.postln);