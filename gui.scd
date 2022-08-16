(
~width = 800;
~height = 800;
~rows = 4;
~cols = 4;
~win = Window.new("LapSynth", Rect(200,200, ~width, ~height));
~view = CompositeView.new(~win,800@260);
~inputprompt = StaticText(~win, Rect(4, ~height - 35,800,50));
~srctext = StaticText(~win, Rect(4, ~height - (35 * 5),800,50));
~desttext = StaticText(~win, Rect(4, ~height - (35 * 4),800,50));
~paramtext = StaticText(~win, Rect(4, ~height - (35 * 3),800,50));
~wavetext = StaticText(~win, Rect(4, ~height - (35 * 2),800,50));
~keysdown = List();
~keycodes = Dictionary(); // easy map input to keydict

// win = Window.new("LapSynth", Rect(200,200, 1920,1080));
~win.front;
~win.view.focus;
~win.view.acceptsMouseOver = true;
~win.view.decorator = FlowLayout(~win.view.bounds);
~win.view.decorator.gap = 2@2;
~view.decorator = FlowLayout(~view.bounds);
~view.decorator.gap = 2@2;

"keymap.scd".loadRelative;

~cursrc = nil; // current patch source
~curdest = nil; // current patch destination
~curparam = nil; // current patch parameter
~curwave = nil; // current oscillator waveform

// ~knobs = Array.fill(16, {|i|
// 	EZKnob(
// 		parent: ~view,
// 		bounds: 175@60,
// 		label: "kn %".format(i),
// 		controlSpec: \freq,
// 		action: {|a| a.value.debug("ezknob")},
// 		unitWidth: 30,
// 		labelHeight: 40,
// 		layout: \line2,
// 		knobSize: 60@60,
// 		margin: 5@5
// 	)
// 	// .enabled_(false) // disable to override default keybindings
// 	.setColors(
// 		stringBackground: Color.gray,
// 		stringColor: Color.gray(0.8),
// 		numBackground: Color.grey,
// 		numStringColor: Color.red,
// 		numNormalColor: Color.white,
// 		numTypingColor: Color.yellow,
// 		knobColors: [
// 			Color.gray, // bg
// 			Color.white, // value
// 			Color.gray, // rest
// 			Color.gray(0.3), // handle
// 		],
// 		background: Color.gray(0.45),
// 	)
// 	.font_(Font("Helvetica", 14));
// });

// keyboard events

~win.view.keyDownAction = {|doc, char, mod, unicode, keycode, key|
	if(~keysdown.indexOf(keycode).isNil) {
		var patch = List();
		~keycodes.put(keycode, char.asSymbol);
		~keysdown.add(keycode);
		// ~inputprompt.string = ~keysdown.debug(char);
		// ~inputprompt.string =
		// 	~oscs[keycode.asSymbol] ?
		// 	~params[keycode.asSymbol] ?
		// 	~waves[keycode.asSymbol];
		~keysdown.do{ |k,i|
			k = k.asSymbol;
			// patch.add( ~oscs[k] ? ~params[k] ? ~waves[k] );

			case
			{ ~oscs.includesKey(k) } {
				if(~keysdown.size == 1) { ~cursrc = ~oscs[k.asSymbol] };
				if(~keysdown.size == 2) { ~curdest = ~oscs[k.asSymbol] };
			}
			{ ~params.includesKey(k) } { ~curparam = ~params[k.asSymbol] }
			{ ~waves.includesKey(k) } { ~curwave = ~waves[k.asSymbol] }
		};
		// ~inputprompt.string = patch;
		// ~inputprompt.string = [~cursrc, ~curparam, ~curwave];

		// ~keysdown.debug("keys down");
		~srctext.string = "src:\t" + ~cursrc;
		~desttext.string = "dest:\t" + ~curdest;
		~paramtext.string = "param:\t" + ~curparam;
		~wavetext.string = "wave:\t" + ~curwave;
	};
};
~win.view.keyUpAction =  {|doc, char, mod, unicode, keycode, key|
	if(~keysdown.indexOf(keycode).isNil.not) {
		~keysdown.remove(keycode);
		~inputprompt.string = ~keysdown;
		// ~keysdown.debug("keys up");
	}
};

// with mouse button pressed
// ~win.view.mouseMoveAction = { | view, x, y |
// 	y.debug(x);
// };

// mouse over gui
// ~win.view.mouseOverAction = { | view, x, y |
// 	y.debug(x);
// 	~inputprompt.string = "%.set('%', %)".format(~cursrc, ~curparam, x);
// };

~inputprompt.stringColor = Color.gray;
~srctext.stringColor = Color.gray;
~desttext.stringColor = Color.gray;
~paramtext.stringColor = Color.gray;
~wavetext.stringColor = Color.gray;
~srctext.string = "alo";
)
"0x27".hexToInt
27.asHexString.hexToInt
0x27
~win = nil