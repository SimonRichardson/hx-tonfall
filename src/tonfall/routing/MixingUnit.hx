package tonfall.routing;

import flash.Vector;

public class MixingUnit extends SignalProcessor
{
	public var output: SignalBuffer;
	
	private var _numInputs: Int;
	private var _inputs: Vector.<SignalBuffer>;
	private var _gains: Vector.<Number>;
	private var _pans: Vector.<Number>;
	
	public function MixingUnit( numInputs: Int )
	{
		output = new SignalBuffer();
		
		_numInputs = numInputs;

		_inputs = new Vector.<SignalBuffer>( numInputs, true );
		_gains = new Vector.<Number>( numInputs, true );
		_pans = new Vector.<Number>( numInputs, true );
		
		for(i in 0...numInputs)
		{
			_gains[i] = 0.7; // DEFAULT GAIN
		}
	}
	
	/**
	 * Connect a SignalBuffer with passed index
	 */
	public function connectAt( output: SignalBuffer, index: Int ): Void
	{
		_inputs[ index ] = output;
	}
	
	/**
	 * Disconnect SignalBuffer at passed index
	 */
	public function disconnectAt( index: Int ): Void
	{
		_inputs[ index ] = null;
	}
	
	/**
	 * @param gain Value between zero and one
	 */
	public function setGainAt( gain: Number, index: Int ): Void
	{
		_gains[ index ] = gain;
	}
	
	public function getGainAt( index: Int ): Number
	{
		return _gains[ index ];
	}
	
	/**
	 * @param pan Value between -1 (left) and +1 (right)
	 */
	public function setPanAt( pan: Number, index: Int ): Void
	{
		_pans[ index ] = pan;
	}
	
	public function getPanAt( index: Int ): Number
	{
		return _pans[ index ];
	}
	
	override protected function processSignals( numSignals: Int ): Int
	{
		var input: SignalBuffer;
		
		var first: Boolean = true;
		
		var out: Signal = output.current;
		
		var n: Int = _inputs.length;
		
		for( i in 0...n)
		{
			input = _inputs[i];

			if( null == input )
				continue;

			//-- CONSTANT POWER PANNING
			//   0 is center (gain: 1 / sqrt(2))
			//  -1 is full left
			//  +1 is full right
			var x: Number = ( _pans[i] + 1.0 ) * Math.PI * 0.25;
			var y: Number = _gains[i];

			var gainL: Number = Math.cos( x ) * y;
			var gainR: Number = Math.sin( x ) * y;
			
			if( first )
			{
				processReplace( input.current, out, numSignals, gainL, gainR );
				first = false;
			}
			else
			{
				processAdd( input.current, out, numSignals, gainL, gainR );
			}
		}
	}

	private function processReplace( inp: Signal, out: Signal, numSignals: Int, gainL: Number, gainR: Number ): Void
	{
		for(i in 0...numSignals)
		{
			out.l = inp.l * gainL;
			out.r = inp.r * gainR;

			out = out.next;
			inp = inp.next;
		}
	}
	
	private function processAdd( inp: Signal, out: Signal, numSignals: Int, gainL: Number, gainR: Number ): Void
	{
		for(i in 0...numSignals)
		{
			out.l += inp.l * gainL;
			out.r += inp.r * gainR;

			out = out.next;
			inp = inp.next;
		}
	}
}
