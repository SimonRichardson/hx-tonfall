package tonfall.poly.simple;

import tonfall.core.Engine;
import tonfall.core.Signal;
import tonfall.core.TimeConversion;
import tonfall.core.TimeEvent;
import tonfall.core.TimeEventNote;
import tonfall.core.SamplingRate;
import tonfall.core.NoteToFrequency;
import tonfall.util.WaveFunction;


class SimplePolySynthVoice implements IPolySynthVoice
{
	private var volume: Float;
	
	private var engine: Engine;
	
	private var _phase: Float;
	private var _phaseIncr: Float;
	
	private var _duration: Int;
	private var _remaining: Int;
	
	public function new()
	{
		volume = 0.2;
		engine = Engine.getInstance();
	}
	
	public function start( event: TimeEvent ) : Void
	{
		var noteEvent: TimeEventNote = cast( event, TimeEventNote ); 
		
		_phase = 0.0;
		_phaseIncr = NoteToFrequency.convert( noteEvent.note ) / SamplingRate.RATE;
		
		_duration = _remaining = Math.floor(TimeConversion.barsToNumSamples( noteEvent.barDuration, engine.bpm ));
	}
	
	public function stop() : Void
	{
		// not implemented
	}

	public function processAdd( current: Signal, numSignals: Int ) : Bool
	{
		var envelope: Float;
		var amplitude: Float;
		
		for(i in 0...numSignals)
		{
			if( _remaining >= 0 )
			{
				envelope = ( --_remaining ) / _duration - 1.0;
				envelope = 1.0 - envelope * envelope;

				amplitude = WaveFunction.biSinus( _phase ) * envelope * volume;

				current.l += amplitude;
				current.r += amplitude;
				current = current.next;

				_phase += _phaseIncr;
				if( _phase >= 1.0 )
					_phase -= 1.0;
			}
			else
			{
				// COMPLETE
				return true;
			}
		}
		
		return false;
	}

	public function dispose() : Void {}
}
