package ;

import flash.Lib;

import tonfall.display.AbstractApplication;

import metronome.MetronomeSequencer;
import metronome.MetronomeGenerator;

class DemoMetronome extends AbstractApplication
{
	public function new()
	{
		super();
		
		var sequencer: MetronomeSequencer = new MetronomeSequencer();
		var generator: MetronomeGenerator = new MetronomeGenerator();

		sequencer.timeEventTarget = generator;

		engine.processors.push( sequencer );
		engine.processors.push( generator );

		engine.input = generator.output;
			
		showSpectrum = true;
	}
	
	public static function main() : Void
	{
		Lib.current.addChild(new DemoMetronome());
	}
}
