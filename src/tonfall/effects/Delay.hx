package tonfall.effects;

import tonfall.core.BlockInfo;
import tonfall.core.Processor;
import tonfall.core.Signal;
import tonfall.core.SignalBuffer;
import tonfall.core.SamplingRate;

class Delay extends Processor
{
	
	public var output(getOutput, never): SignalBuffer;
	
	private var _output : SignalBuffer;
	private var _input: SignalBuffer;
	
	private var _buffer: SignalBuffer;
	private var _bufferIndex: Int;
	private var _bufferSize: Int;
	
	private var _wet: Float;
	private var _dry: Float;
	private var _feedback: Float;
	
	public var input(getInput, setInput) : SignalBuffer;
	public var wet(getWet, setWet) : Float;
	public var dry(getDry, setDry) : Float;
	public var feedback(getFeedback, setFeedback) : Float;
	
	public function new( millis: Int )
	{
		super();
		
		_output = new SignalBuffer();
		
		_wet = 0.5;
		_dry = 0.8;
		
		_feedback = 0.4;
		
		_bufferSize = Math.floor(millis / 1000.0 * SamplingRate.RATE);

		_buffer = new SignalBuffer( _bufferSize );
		_bufferIndex = 0;
	}
	
	override public function process( info: BlockInfo ) : Void
	{
		var dly: Signal = _buffer.current;
		var inp: Signal = _input.current;
		var out: Signal = _output.current;
		
		var readL: Float;
		var readR: Float;
		
		var n: Int = info.numSignals;
		
		for(i in 0...n)
		{
			// READ FROM DELAY BUFFER
			readL = dly.l;
			readR = dly.r;
			
			// WRITE INPUT TO DELAY BUFFER
			dly.l = inp.l + readL * _feedback;
			dly.r = inp.r + readR * _feedback;

			// MIX INPUT AND DELAY TO OUTPUT
			out.l = inp.l * _dry + dly.l * _wet;
			out.r = inp.r * _dry + dly.r * _wet;
			
			dly = dly.next;
			inp = inp.next;
			out = out.next;
		}
		
		_buffer.advancePointer( info.numSignals );
		_output.advancePointer( info.numSignals );
	}
		
	public function getOutput() : SignalBuffer
	{
		return _output;
	}
		
	public function getInput() : SignalBuffer
	{
		return _input;
	}

	public function setInput( value: SignalBuffer ) : SignalBuffer
	{
		_input = value;
		return _input;
	}

	public function getWet() : Float
	{
		return _wet;
	}

	public function setWet( value: Float ) : Float
	{
		_wet = value;
		
		return _wet;
	}

	public function getDry() : Float
	{
		return _dry;
	}

	public function setDry( value: Float ) : Float
	{
		_dry = value;
		
		return _dry;
	}

	public function getFeedback() : Float
	{
		return _feedback;
	}

	public function setFeedback( value: Float ) : Float
	{
		_feedback = value;
		
		return _feedback;
	}
}
