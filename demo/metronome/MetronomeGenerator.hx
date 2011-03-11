package metronome;

import tonfall.core.Signal;
import tonfall.core.SignalBuffer;
import tonfall.core.SignalProcessor;
import tonfall.core.TimeEvent;
import tonfall.core.NoteToFrequency;
import tonfall.core.SamplingRate;

class MetronomeGenerator extends SignalProcessor
{
	public var _output : SignalBuffer;
	
	private var duration: Int;
	
	private var _phase: Float;
	private var _phaseIncr: Float;
	private var _remaining: Int;
	
	public var output(getOutput, never) : SignalBuffer;

	public function new() 
	{
		super();
		
		_output = new SignalBuffer();
		duration = Math.floor(SamplingRate.RATE * 0.050); // 50ms
	}
	
	public function getOutput() : SignalBuffer
	{
		return _output;
	}
	
	override public function processTimeEvent( event: TimeEvent ) : Void
	{
		if( Std.is(event, MetronomeEvent) )
		{
			_phase = 0.0;
			_remaining = duration;
			
			var metronomeEvent = cast(event, MetronomeEvent);
			if( 0 == metronomeEvent.beat )
			{
				_phaseIncr = NoteToFrequency.convert( 84 ) / SamplingRate.RATE;
			}
			else
			{
				_phaseIncr = NoteToFrequency.convert( 72 ) / SamplingRate.RATE;
			}
		}
	}

	override public function processSignals( numSignals: Int ) : Void
	{
		var envelope: Float;
		var amplitude: Float;
		
		var signal: Signal = _output.current;
		
		for(i in 0...numSignals)
		{
			if( _remaining > 0 )
			{
				envelope = ( --_remaining ) / duration; // LINEAR \

				amplitude = Math.sin( _phase * 2.0 * Math.PI ) * envelope;

				signal.l =
				signal.r = amplitude;

				_phase += _phaseIncr;

				if( _phase >= 1.0 )
					_phase -= 1.0;
			}
			else
			{
				signal.l = 0.0;
				signal.r = 0.0;
			}

			signal = signal.next;
		}

		_output.advancePointer( numSignals );
	}
}
