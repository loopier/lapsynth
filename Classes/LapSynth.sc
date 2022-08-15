LapSynth {
	var <>win;
	var <>knobs;
	var <>texts;
	var <>inputprompt;
	var <>width;
	var <>height;
	var <>keysdown;
	var <>keydict;
	var <>keycodes; // to easily map input to keydict
	var <>oscillators;
	var <>opsdict; // operators (functions)

	/////////////////////////////////
	/// class methods
	/////////////////////////////////
	*new {
		^super.new.init;
	}

	/// @brief return a list of the controls for the given synth
    *synthControls { |synth|
        var controls = List();
        SynthDescLib.global.at(synth).controls.do{ |ctl|
            controls.add([ctl.name, ctl.defaultValue]);
        }
        ^controls
    }

	/// @brief list controls for the given synth
	*controls { |synth|
        "% controls".format(synth).postln;
        this.synthControls(synth).collect(_.postln)
	}

	/////////////////////////////////
	/// instance methods
	/////////////////////////////////
	init {
		Spec.add(\out, ControlSpec(0, Server.default.options.numOutputBusChannels));
		Spec.add(\pan, ControlSpec(-1, 1));
		Spec.add(\atk, ControlSpec(0.01, 0.3, units: "secs"));
		Spec.add(\dec, ControlSpec(0.01, 0.3, units: "secs"));
		Spec.add(\sus, ControlSpec(0.0, 1.0));
		Spec.add(\rel, ControlSpec(0.01, 1.0, units: "secs"));
		Spec.add(\feedback, ControlSpec(0.0, 1.0));
		this.debug("LapSynth");
		this.keysdown = List();
		this.keycodes = Dictionary();
		this.makeWindow();
		this.makeTexts();
		this.setupKeyboardInterface();
		this.makeOscillators();
		this.makeOpsdict();
		this.makeKeydict();
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
		this.inputprompt.stringColor = Color.gray;
	}

	setupKeyboardInterface {
		this.win.view.keyDownAction = {|doc, char, mod, unicode, keycode, key|
			if(this.keysdown.indexOf(keycode).isNil) {
				this.keycodes.put(keycode, char.asSymbol);
				this.keysdown.add(keycode);
				this.prUpdateGui;
				// this.keysdown.debug("keys down");
			};
		};
		this.win.view.keyUpAction =  {|doc, char, mod, unicode, keycode, key|
			if(this.keysdown.indexOf(keycode).isNil.not) {
				this.keysdown.remove(keycode);
				// this.prUpdateGui;
				// this.keysdown.debug("keys up");
			}
		};
	}

	makeOscillators {
		this.oscillators = List();
		Server.default.waitForBoot {
			(Platform.userExtensionDir++"/LapSynth/synthdefs/synthdef-oscillators.scd").load;

			Server.default.sync;

			this.oscillators.add( Ndef(\osc1, \sine) );
			this.oscillators.add( Ndef(\osc2, \sine) );
			this.oscillators.debug("oscillators");
		}

	}

	/// @brief create a dictionary of modules
	makeOpsdict {

	}

	/// @brief create a dictionary to map keyboard input
	makeKeydict {
		this.keydict = Dictionary();
		this.keydict.put(\q, Ndef(\osc1));
		this.keydict.put(\a, Ndef(\osc2));
	}


	/////////////////////////////////
	/// private methods
	/////////////////////////////////
	prUpdateGui {
		var obj = this.prGetObjectFromKeycode(this.keysdown[0]);
		this.prUpdateKnobs(obj);
		this.inputprompt.string = this.keysdown;
		// obj.debug("obj");
	}

	prUpdateKnobs { |obj|
		var controls = Dictionary.newFrom(LapSynth.synthControls(Ndef(\osc1).source).flat);
		controls.debug("prUpdateKnobs");
		// controls.keys.do{|key, i|
		// 	var val = obj.get(key);
		// 	[key, val].debug(i);
		// 	this.knobs[i].set(label:key);
		// 	this.knobs[i].controlSpec = key.asSpec;
		// 	// this.knobs[i].label = key;
		// 	this.knobs[i].value = val;
		// };
		// obj.source.debug("knobs for");
	}

	/// @brief get object from keyboard keycode
	prGetObjectFromKeycode { |keycode|
		^this.keydict[ this.keycodes[ keycode ] ];
	}

}