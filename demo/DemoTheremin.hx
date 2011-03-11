package ;

import flash.Lib;
import flash.events.MouseEvent;

import tonfall.display.AbstractApplication;
import tonfall.util.Mapping;

import theremin.ThereminProcessor;

class DemoTheremin extends AbstractApplication
{
	private var theremin: ThereminProcessor;

	public function new()
	{
		super();
		
		theremin = new ThereminProcessor();
		
		engine.processors.push( theremin );

		engine.input = theremin.output;
		
		showSpectrum = true;
	}
	
	override public function added() : Void
	{
		stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
	}
	
	private function mouseMove( event: MouseEvent ): Void
	{
		// Map Y to gain
		var gain: Float = mouseY / stage.stageHeight;
		
		theremin.setGain( gain );
		
		// Map X to frequency log-style (20-22050Hz)
		var normFreq: Float = mouseX / stage.stageWidth;
		
		theremin.setFrequency( Mapping.mapExp(normFreq, 20.0, 22050.0) );
	}
	
	public static function main() : Void
	{
		Lib.current.addChild(new DemoTheremin());
	}
}
