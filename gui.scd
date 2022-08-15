(
var width = 800;
var height = 800;
var rows = 4;
var cols = 4;
var win = Window.new("LapSynth", Rect(200,200, width, height));
var view = CompositeView.new(win,800@260);
var knobs;
var inputprompt = StaticText(win, Rect(4, height - 35,800,50));
var keysdown = List();
var keycodes = Dictionary(); // easy map input to keydict
var keydict = Dictionary(); // keyboard map
// oscillators
keydict.put(\113, Ndef(\osc1));	// q
keydict.put(\97, Ndef(\osc2)); 	// a
keydict.put(\122, Ndef(\osc3));	// z
// wave shapes
keydict.put(\49, \sine);
keydict.put(\50, \tri);
keydict.put(\51, \saw);
keydict.put(\52, \white);

// win = Window.new("LapSynth", Rect(200,200, 1920,1080));
win.front;
win.view.decorator = FlowLayout(win.view.bounds);
win.view.decorator.gap = 2@2;
view.decorator = FlowLayout(view.bounds);
view.decorator.gap = 2@2;

knobs = Array.fill(16, {|i|
	EZKnob(
		parent: view,
		bounds: 175@60,
		label: "kn %".format(i),
		controlSpec: \freq,
		action: {|a| a.value.debug("ezknob")},
		unitWidth: 30,
		labelHeight: 40,
		layout: \line2,
		knobSize: 60@60,
		margin: 5@5
	)
	.setColors(
		stringBackground: Color.gray,
		stringColor: Color.gray(0.8),
		numBackground: Color.grey,
		numStringColor: Color.red,
		numNormalColor: Color.white,
		numTypingColor: Color.yellow,
		knobColors: [
			Color.gray, // bg
			Color.white, // value
			Color.gray, // rest
			Color.gray(0.3), // handle
		],
		background: Color.gray(0.45),
	)
	.font_(Font("Helvetica", 14));
});

// keyboard events
win.view.keyDownAction = {|doc, char, mod, unicode, keycode, key|
	if(keysdown.indexOf(keycode).isNil) {
		keycodes.put(keycode, char.asSymbol);
		keysdown.add(keycode);
		inputprompt.string = keysdown.debug;
		// keysdown.debug("keys down");
	};
};
win.view.keyUpAction =  {|doc, char, mod, unicode, keycode, key|
	if(keysdown.indexOf(keycode).isNil.not) {
		keysdown.remove(keycode);
		inputprompt.string = keysdown;
		// prUpdateGui;
		// keysdown.debug("keys up");
	}
};

inputprompt.stringColor = Color.gray;
)
