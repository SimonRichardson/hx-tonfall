package tonfall.core;

import flash.Vector;
import flash.utils.ByteArray;

class Engine 
{
	
	private static var instance: Engine;
	
	private var blockInfo: BlockInfo;
	
	private var _barPosition: Float; // BAR POSITION
	private var _bpm: Float; // BEATS PER MINUTE
	private var _processors: Vector<Processor>; // LINEAR LIST OF PROCESSORS
	private var _input: SignalBuffer;
	
	public var barPosition(getBarPosition, setBarPosition) : Float;
	public var bpm(getBpm, setBpm) : Float;
	public var processors(getProcessors, never) : Vector<Processor>;
	public var input(never, setInput) : SignalBuffer;
	
	private function new()
	{
		if( instance != null )
		{
			throw 'AudioEngine is Singleton.';
		}
		
		_processors = new Vector<Processor>();
		
		blockInfo = new BlockInfo();
		
		_barPosition = 0.0;
		_bpm = 120.0;
	}
	
	public static function getInstance(): Engine
	{
		if( null == instance )
		{
			instance = new Engine();
		}

		return instance;
	}

	public function render( target: ByteArray, numSignals: Int ) : Void
	{
		var to: Float = _barPosition + TimeConversion.numSamplesToBars( numSignals, _bpm );

		blockInfo.reset( numSignals, _barPosition, to );

		renderProcessors();
		
		_barPosition = to;
		
		if( null != _input )
		{
			writeInput( target, numSignals );
		}
	}

	private function renderProcessors() : Void
	{
		var n: Int = _processors.length;

		for(i in 0...n)
		{
			_processors[i].process( blockInfo );
		}
	}

	private function writeInput( target: ByteArray, num: Int ) : Void
	{
		var signal: Signal = _input.current;

		for( i in 0...num)
		{
			target.writeFloat( signal.l );
			target.writeFloat( signal.r );
			
			signal = signal.next;
		}
	}

	public function getBarPosition() : Float
	{
		return _barPosition;
	}

	public function setBarPosition( value: Float ) : Float
	{
		_barPosition = value;
		
		return _barPosition;
	}

	public function getBpm() : Float
	{
		return _bpm;
	}

	public function setBpm( value: Float ) : Float
	{
		_bpm = value;
		
		return _bpm;
	}

	public function getProcessors() : Vector<Processor>
	{
		return _processors;
	}

	public function setInput( value: SignalBuffer ) : SignalBuffer
	{
		_input = value;
		return _input;
	}

	public function deltaBlockIndexAt( position: Float ) : Int
	{
		var value: Int = Math.floor(TimeConversion.barsToNumSamples( position - _barPosition, _bpm ));

		if( value < 0 || value >= Driver.BLOCK_SIZE )
		{
			throw 'Index out of Block. index: ' + value;
		}
		
		return value;
	}
}
