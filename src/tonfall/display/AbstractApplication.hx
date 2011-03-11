package tonfall.display;

import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.events.Event;

import haxe.Timer;

import tonfall.core.Driver;
import tonfall.core.Engine;
import tonfall.core.Parameter;
import tonfall.core.SharedMemory;

class AbstractApplication extends Sprite
{
	public var driver : Driver;
	public var engine : Engine;
	public var spectrum : Spectrum;
	
	private var _showSpectrum : Bool;
	private var _sliderIndex : Int;
	
	public var showSpectrum(getShowSpectrum, setShowSpectrum) : Bool;
	
	public function new()
	{
		super();
		
		driver = Driver.getInstance();
		engine = Engine.getInstance();
		
		spectrum = new Spectrum();
		
		_sliderIndex = 0;
		
		if(stage == null)
		{
			addEventListener( Event.ADDED_TO_STAGE, addedToStage );
		}
		else
		{
			added();
		}
		
		
		// preallocate memory for processing
		SharedMemory.memory.length = Driver.BLOCK_SIZE << 3;
		
		driver.engine = engine;

		// delay call to avoid glitches (Flashplayer issue)
		var timer:Timer = new Timer(100);
        timer.run = function()
        {
            Driver.getInstance().init();
            
            timer.stop();
        };
	}
	
	public function addParameterSlider( parameter: Parameter ) : ParameterSlider
	{
		var slider : ParameterSlider = new ParameterSlider( parameter );
		
		slider.x = 16.0;
		slider.y = 36.0 * ( _sliderIndex++ ) + 16.0;
		
		addChild( slider );
		
		return slider;
	}
	
	public function getShowSpectrum() : Bool
	{
		return _showSpectrum;
	}

	public function setShowSpectrum( value: Bool ) : Bool
	{
		if( _showSpectrum != value )
		{
			if( value )
				addChild( spectrum );
			else
				removeChild( spectrum );
			
			_showSpectrum = value;
		}
		
		return _showSpectrum;
	}
	
	public function resize() : Void
	{
		spectrum.x = ( stage.stageWidth - spectrum.getWidth() ) / 2;
		spectrum.y = ( stage.stageHeight - spectrum.getHeight() ) / 2;
	}
	
	public function added() : Void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addEventListener( Event.RESIZE, handleResize );
		stage.frameRate = 1000.0;
		
		resize();
	}
	
	public function handleResize( event: Event ) : Void
	{
		resize();
	}
	
	public function addedToStage( event: Event ): Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, addedToStage );
		
		added();
	}
}
