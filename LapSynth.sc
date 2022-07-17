LapSynth {
	var <>win;
	var <>knobs;
	var <>texts;
	var <>inputprompt;
	var <>width;
	var <>height;
	classvar <>keysdown;

	*new {
		^super.new.init;
	}

	init {
		this.debug("LapSynth");
		LapSynth.keysdown = List();
		this.makeWindow();
		this.makeTexts();
		this.setupKeyboardInterface();
	}

	makeWindow {
		this.width = 800;
		this.height = 800;
		this.win = Window.new("LapSynth", Rect(200,200, this.width, this.height));
		// this.win = Window.new("LapSynth", Rect(200,200, 1920,1080));
		this.win.front;
		this.win.view.decorator = FlowLayout(this.win.view.bounds);
		this.win.view.decorator.gap = 2@2;
		this.makeKnobs();
		// this.makeTexts();
	}

	makeKnobs { | rows = 4, cols = 4 |
		var view = CompositeView.new(this.win,800@260);
		view.decorator = FlowLayout(view.bounds);
		view.decorator.gap = 2@2;
		this.knobs = Array.fill(16, {|i|
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
	}

	makeTexts {
		this.inputprompt = StaticText(this.win, 800@50);
	}

	setupKeyboardInterface {
		this.win.view.keyDownAction = {|doc, char, mod, unicode, keycode, key|
			if(LapSynth.keysdown.indexOf(keycode).isNil) {
				LapSynth.keysdown.add(keycode);
				LapSynth.keysdown.debug("keys down");
				this.inputprompt.string = LapSynth.keysdown;
			};
		};
		this.win.view.keyUpAction =  {|doc, char, mod, unicode, keycode, key|
			if(LapSynth.keysdown.indexOf(keycode).isNil.not) {
				LapSynth.keysdown.remove(keycode);
				LapSynth.keysdown.debug("keys down");
				this.inputprompt.string = LapSynth.keysdown;
			}
		};
	}
}