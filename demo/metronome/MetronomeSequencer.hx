package metronome;

import tonfall.core.BlockInfo;
import tonfall.core.Processor;

class MetronomeSequencer extends Processor
{
	private var _timeEventTarget: Processor;
	
	private var _upper: Int;
	private var _lower: Int;
	
	public var upper(getUpper, setUpper) : Int;
	public var lower(getLower, setLower) : Int;
	public var timeEventTarget(getTimeEventTarget, setTimeEventTarget) : Processor;
	
	public function new() 
	{
		super();
		
		_upper = 4;
		_lower = 4;
	}

	override public function process( info: BlockInfo ) : Void
	{
		if( null == _timeEventTarget )
			throw 'No event target defined.';
		
		var position:Float = Math.floor( info.barFrom * _lower ) / _lower;

		var beat:Int;
		var bar:Int;

		var event: MetronomeEvent;

		do
		{
			if( position >= info.barFrom )
			{
				beat = Math.floor(position * _lower);
				bar  = Math.floor( beat / _upper );
				beat %= _upper;

				event = new MetronomeEvent();
				event.bar = Math.floor(position);
				event.bar = bar;
				event.beat = beat;

				_timeEventTarget.addTimeEvent( event );
			}

			position += 1.0 / _lower;
		}
		while( position < info.barTo );
	}

	public function getUpper() : Int
	{
		return _upper;
	}

	public function setUpper( value: Int ) : Int
	{
		_upper = value;
		
		return _upper;
	}

	public function getLower() : Int
	{
		return _lower;
	}

	public function setLower( value: Int ) : Int
	{
		_lower = value;
		
		return _lower;
	}

	public function getTimeEventTarget() : Processor
	{
		return _timeEventTarget;
	}

	public function setTimeEventTarget( target: Processor ) : Processor
	{
		_timeEventTarget = target;
		
		return _timeEventTarget;
	}
}
