(
~cmds = Dictionary();
~modules = Dictionary();
~waves = Dictionary();
~params = Dictionary();

~cmds.put(\16777219, {~reset.value}); // backspace
~cmds.put(\16777220, {~patch.value}); // return

// oscillators
~modules.put(\81, \osc1);	// q
~modules.put(\87, \osc2); 	// w
~modules.put(\69, \osc3);	// e
~modules.put(\82, \osc4);	// r
~modules.put(\65, \osc5); 	// a
~modules.put(\83, \osc6);	// s
~modules.put(\68, \osc7);	// d
~modules.put(\70, \osc8); 	// f
~modules.put(\90, \osc9);	// z
~modules.put(\88, \osc10);	// x
~modules.put(\67, \osc11); 	// c
~modules.put(\86, \osc12);	// v
~modules.put(\16777248, \mixer);	// r-shift

// fx
~modules.put(\84, \freeverb); 	// t
~modules.put(\89, \gverb); 		// y
~modules.put(\85, \delay);	 	// u
~modules.put(\73, nil); 	// i
~modules.put(\71, nil); 	// g
~modules.put(\72, nil); 	// h
~modules.put(\74, nil); 	// j
~modules.put(\75, nil); 	// k
// ~fx.put(\freeverb, {|in| FreeVerb.ar(in, room: \room.kr(0.5))});
// ~fx.put(\gverb, {|in| GVerb.ar(in, roomsize: \room.kr(10))});
// ~fx.put(\delay, {|in| var delt = \delt.kr(0.2); CombC.ar(in, delt, delt, \dect.kr(1))});

~params.put(\93, \gate);		// ]
~params.put(\91, \amp);		// [
~params.put(\80, \phase);	// p
~params.put(\79, \freq);	// o
~params.put(\76, \width);	// l
~params.put(\59, \fb);		// ;
// ~params.put(\65105, nil);	// '
// ~params.put(\35, nil);		// #

~waves.put(\49, \sine); 	// 1
~waves.put(\50, \tri); 	// 2
~waves.put(\51, \saw); 	// 3
~waves.put(\52, \pulse); // 4
~waves.put(\53, \lfpulse); // 5
~waves.put(\54, \white); // 6
~waves.put(\55, \pink); // 7
~waves.put(\56, \brown); // 8
~waves.put(\57, nil); // 9
~waves.put(\48, nil); // 0
)