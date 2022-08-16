(
~reset = {
	~cursrc = nil;
	~curdest = nil;
	~curparam = nil;
	~curwave = nil;
	~curvaluex = 0;
	~curvaluey = 0;
};

~patch = { |src, dest, param|
	~inputprompt.string = "Ndef('%').set('%', Ndef('%'))".format(~cursrc, ~curparam, ~curdest);
};

// return the keys of the controls for the given Ndef
~getparams = { |ndef|
	var controls = List();
	ndef = ndef.asSymbol;
	Ndef(ndef).controlNames.do{ |ctl|
		// controls.add([ctl.name, Ndef(ndef).get(ctl.asSymbol) ? ctl.defaultValue ]);
		controls.add(ctl.name);
	};
	// ^controls.debug("params %".format(ndef));
	controls;
};

~setsrc = { |src, def|
	"Ndef('%', '%')".format(src, def).debug("set source");
	Ndef(src.asSymbol, def.asSymbol);
};
)