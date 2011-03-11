package ;

import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import tonfall.core.Engine;
import tonfall.core.TimeConversion;
import tonfall.display.AbstractApplication;
import tonfall.effects.Delay;
import tonfall.poly.PolySynth;
import tonfall.poly.simple.SimplePolySynthVoiceFactory;

import tonematrix.Button;
import tonematrix.TonematrixSequencer;

class DemoToneMatrix extends AbstractApplication
{
	private var sequencer : TonematrixSequencer;
	private var generator : PolySynth;
	private var delay: Delay;
	
	private var _container: Sprite;
	private var _selectMode: Bool;
	
	public function new()
	{
		super();
		
		sequencer = new TonematrixSequencer();
		generator = new PolySynth( SimplePolySynthVoiceFactory.INSTANCE );
		delay = new Delay( Math.floor(TimeConversion.barsToMillis(3.0/16.0, Engine.getInstance().bpm)) );
		
		initView();
		initAudio();
	}
	
	public static function main() : Void
	{
		Lib.current.addChild(new DemoToneMatrix());
	}
	
	private function initView() : Void
	{
		_container = new Sprite();
		_container.x = 128;
		_container.y = 128;
		
		addChild( _container );
		
		for(u in 0...16)
		{
			for(v in 0...16)
			{
				var button: Button = new Button( u, v );
				
				button.x = ( u << 5 );
				button.y = ( v << 5 );
				
				_container.addChild( button );
			}
		}
		
		showSpectrum = true;
		
		addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
		addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
	}
	
	private function initAudio() : Void
	{
		engine.processors.push( sequencer );
		engine.processors.push( generator );
		engine.processors.push( delay );

		delay.input = generator.output;

		sequencer.receiver = generator;

		engine.input = delay.output;
	}
	
	private function changePattern( u: Int, v: Int, value: Bool ): Void
	{
		sequencer.pattern[u][v] = value;
	}
	
	override public function resize() : Void
	{
		super.resize();
		
		if( null != _container )
		{
			_container.x = ( stage.stageWidth  - 512 ) >> 1;
			_container.y = ( stage.stageHeight - 512 ) >> 1;
		}
	}
	
	override public function handleResize( event : Event ) : Void
	{
		resize();
	}

	private function handleMouseMove( event : MouseEvent ) : Void
	{
		if(Std.is(event.target, Button))
		{
			var button: Button = cast(event.target, Button);
			
			if( event.buttonDown && null != button )
			{
				button.selected = _selectMode;
				
				changePattern( button.u, button.v, button.selected );
			}
		}
	}

	private function handleMouseDown( event : MouseEvent ) : Void
	{
		if(Std.is(event.target, Button))
		{
			var button: Button = cast(event.target, Button);
			
			if( null != button )
			{
				button.selected = _selectMode = !button.selected;
				
				changePattern( button.u, button.v, button.selected );
			}
		}
	}
}
