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
~valuextext = StaticText(~win, Rect(4, ~height - (35 * 7),800,50));
~valueytext = StaticText(~win, Rect(4, ~height - (35 * 6),800,50));
~srcmenu = EZPopUpMenu(~win, Rect(0, 0, 230, 22), "src", ~modules.values.asArray.sort);
~destmenu= EZPopUpMenu(~win, Rect(0, 22, 230, 22), "dest", ~modules.values.asArray.sort);
~paramsmenu= EZPopUpMenu(~win, Rect(0, 44, 230, 22), "params", ~params.values.asArray.sort); //.enabled_(false);
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

"synthdefs/synthdef-oscillators.scd".loadRelative;
"funcs.scd".loadRelative;
"keymap.scd".loadRelative;

~cursrc = nil; // current patch source
~curdest = nil; // current patch destination
~curparams = Dictionary(); // current patch parameter list
~curparam = nil; // active patch parameter
~curwave = nil; // current oscillator waveform
~curfx = nil; // current effect
~curvaluex = 0; // current mouse-controled value
~curvaluey = 0; // current mouse-controled value

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
		~keycodes.put(key, char.asSymbol);
		~keysdown.add(key);
		// ~inputprompt.string = ~keysdown.debug(char);
		// ~inputprompt.string =
		// 	~modules[keycode.asSymbol] ?
		// 	~params[keycode.asSymbol] ?
		// 	~waves[keycode.asSymbol];
		~keysdown.do{ |k,i|
			k = k.asSymbol;
			// patch.add( ~modules[k] ? ~params[k] ? ~waves[k] );

			// case
			// { ~cmds.includesKey(k) } { ~cmds[k].value }
			// { ~modules.includesKey(k) } {
			// 	if(~keysdown.size == 1) {
			// 		~cursrc = ~modules[k];
			// 	};
			// 	if(~keysdown.size == 2) { ~curdest = ~modules[k] };
			// }
			// { ~params.includesKey(k) } { ~curparam = ~params[k] }
			// { ~waves.includesKey(k) } { ~curwave = ~waves[k] }

			if (~keysdown.size == 1) {
				case
				{ ~cmds.includesKey(k) } 	{ ~cmds[k].value }
				{ ~modules.includesKey(k) } { ~cursrc = ~modules[k] }
				{ ~params.includesKey(k) }	{ ~curparam = ~params[k] }
				{ ~waves.includesKey(k) } 	{ ~curwave = ~waves[k] }
			};

			if (~keysdown.size == 2) {
				case
				{ ~modules.includesKey(k) }	{
					~curdest = ~modules[k];
					// patch src to dest
				}
				{ ~params.includesKey(k) }	{
					~curparam = ~params[k];
					// set param for src ndef
				}
				{ ~waves.includesKey(k) } 	{
					~curwave = ~waves[k];
					// set source for src ndef
					~setsrc.value( ~cursrc, ~curwave );
					// ~getparams.value(~cursrc);
				}
			};
		};
		// ~inputprompt.string = patch;
		// ~inputprompt.string = [~cursrc, ~curparam, ~curwave];

		// ~keysdown.debug(char);
		// [unicode, keycode, key].debug(char);
		~srctext.string = "src:\t" + ~cursrc;
		~desttext.string = "dest:\t" + ~curdest;
		~paramtext.string = "param:\t" + ~curparam;
		~wavetext.string = "wave:\t" + ~curwave;
		~srcmenu.value = ~modules.values.asArray.sort.indexOf(~cursrc);
		~destmenu.value = ~modules.values.asArray.sort.indexOf(~curdest);
		~curparams = ~getparams.value(~cursrc).debug("% params".format(~cursrc));
		// ~paramsmenu.value = ~curparams.asArray.sort.indexOf(~curparam) ? ~params.asArray.sort.indexOf(~curparam ? \freq);
		~paramsmenu.items = ~curparams.asArray.sort ? ~params.asArray.sort;
		~paramsmenu.value = ~curparams.asArray.sort.indexOf(~curparam) ? 0;
	};
};

~win.view.keyUpAction =  {|doc, char, mod, unicode, keycode, key|
	if(~keysdown.indexOf(key).isNil.not) {
		~keysdown.remove(key);
		// ~inputprompt.string = ~keysdown;
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

// mouse wheel
~win.view.mouseWheelAction = { | view, x, y, mods, dx, dy |
	[x,y,mods, dx,dy].debug;
	if (dx > 0) { ~curvaluex = ~curvaluex + 1 };
	if (dx < 0) { ~curvaluex = ~curvaluex - 1 };
	if (dy > 0) { ~curvaluey = ~curvaluey + 1 };
	if (dy < 0) { ~curvaluey = ~curvaluey - 1 };
	~valuextext.string = "value x:\t" + ~curvaluex;
	~valueytext.string = "value y:\t" + ~curvaluey;
	// ~inputprompt.string = "%.set('%', %)".format(~cursrc, ~curparam, x);

	// ~paramsmenu.value = (~paramsmenu.value + ~curvaluey).mod( ~paramsmenu.items.size );
};

~inputprompt.stringColor = Color.gray;
~srctext.stringColor = Color.gray;
~desttext.stringColor = Color.gray;
~paramtext.stringColor = Color.gray;
~wavetext.stringColor = Color.gray;
~valuextext.stringColor = Color.gray;
~valueytext.stringColor = Color.gray;
)