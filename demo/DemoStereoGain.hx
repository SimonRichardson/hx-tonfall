package ;

import flash.Lib;
import flash.events.Event;

import tonfall.display.AbstractApplication;

import stereogain.StereoSine;


class DemoStereoGain extends AbstractApplication
{
	private var processor: StereoSine;
	
	public function new()
	{
		super();
		
		processor = new StereoSine();
		
		engine.processors.push( processor );

		engine.input = processor.output;
	}
	
	public static function main() : Void
	{
		Lib.current.addChild(new DemoStereoGain());
	}
	
	override public function added() : Void
	{
		super.added();
		
		stage.addEventListener( Event.ENTER_FRAME, enterFrame );
	}
	
	override public function resize(): Void
	{
		var wHalf: Float = stage.stageWidth * 0.5;
		var height: Float = stage.stageHeight;

		graphics.clear();
		graphics.lineStyle( 0.0, 0xFF0000 );
		graphics.moveTo( wHalf, 0.0 );
		graphics.lineTo( wHalf, height );
		
		super.resize();
	}

	private function enterFrame( event: Event ): Void
	{
		var wHalf: Float = stage.stageWidth * 0.5;

		var pan: Float = ( mouseX - wHalf ) / wHalf;
		
		processor.matrix.linear( 0.5, pan );
	}
}
