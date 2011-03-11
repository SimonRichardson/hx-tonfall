package tonfall.core;

import flash.Vector;

class SignalBuffer 
{
	
	private var _current: Signal;
	private var _index: Int;
	private var _length: Int;
	
	private var _vector: Vector<Signal>;
	
	public var current(getCurrent, never) : Signal;
	public var vector(getVector, never) : Vector<Signal>;
	
	public function new( length: Int = 0 )
	{
		init( 0 >= length ? Driver.BLOCK_SIZE : length );
	}
	
	private function init( length: Int ): Void
	{
		var head: Signal;
		var tail:Signal;

		_vector = new Vector<Signal>( length, true );

		tail = head = _vector[0] = new Signal();

		for(i in 0...length)
		{
			tail = tail.next = _vector[i] = new Signal();
		}

		_current = tail.next = head;

		_index = 0;
		_length = length;
	}
	
	public function zero( num: Int ): Void
	{
		var signal: Signal = _current;
		
		for(i in 0...num)
		{
			signal.l =
			signal.r = 0.0;
			
			signal = signal.next;
		}
	}
	
	public function multiply( num: Int, gain: Float ): Void
	{
		var signal: Signal = _current;
		
		for(i in 0...num)
		{
			signal.l *= gain;
			signal.r *= gain;
			
			signal = signal.next;
		}
	}
	
	public function deltaPointer( delta: Int ): Signal
	{
		var index: Int = _index + delta;

		if( index < 0 )
			index += _length;
		else
		if( index >= _length )
			index -= _length;

		return _vector[ index ];
	}

	public function advancePointer( count: Int ): Void
	{
		if( 0 == count )
			return;
		
		_index += count;

		if( _index < 0 )
			_index += _length;
		else
		if( _index >= _length )
			_index -= _length;

		_current = _vector[ _index ];
	}
	
	public function getCurrent() : Signal
	{
		return _current;
	}

	public function getVector() : Vector<Signal>
	{
		return _vector;
	}	
}
