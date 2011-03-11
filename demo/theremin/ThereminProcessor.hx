package theremin;

import tonfall.core.Signal;
import tonfall.core.SignalBuffer;
import tonfall.core.SignalProcessor;

class ThereminProcessor extends SignalProcessor
{
	public var _output: SignalBuffer;
	
	private static inline var INTERPOLATION_DURATION: Int = Math.floor(44100 * 0.1); // 100ms
	
	private static inline var PI_2: Float = Math.PI * 2.0;
	
	private var _phase: Float;
	
	private var _phaseIncrCurrent: Float;
	private var _phaseIncrTarget: Float;
	private var _phaseIncrVelocity: Float;
	private var _phaseIncrInterpolationRemaining: Int;
	
	private var _gainCurrent: Float;
	private var _gainTarget: Float;
	private var _gainVelocity: Float;
	private var _gainInterpolationRemaining: Int;
	
	public var output(getOutput, never) : SignalBuffer;

	public function new()
	{
		super();
		
		_output = new SignalBuffer();
		
		_phase = 0.0;
		
		_phaseIncrCurrent = _phaseIncrTarget = 0.0;
		
		_gainCurrent = _gainTarget = 0.0;
	}
	
	public function getOutput() : SignalBuffer
	{
		return _output;
	}
	
	/**
	 * @param value Frequency between zero and 22050Hz
	 */
	public function setFrequency( value: Float ): Void
	{
		if( value < 0.0 )
			value = 0.0;
		else
		if( value > 22050.0 )
			value = 22050.0;
		
		var phaseIncr: Float = value / 44100.0;
		
		if( phaseIncr != _phaseIncrCurrent )
		{
			_phaseIncrTarget = phaseIncr;
			_phaseIncrVelocity = ( _phaseIncrTarget - _phaseIncrCurrent ) / INTERPOLATION_DURATION;
			_phaseIncrInterpolationRemaining = INTERPOLATION_DURATION;
		}
	}
	
	/**
	 * @param value Gain between zero and one
	 */
	public function setGain( value: Float ): Void
	{
		if( value < 0.0 )
			value = 0.0;
		else
		if( value > 1.0 )
			value = 1.0;
		
		if( _gainCurrent != value )
		{
			_gainTarget = value;
			_gainVelocity = ( _gainTarget - _gainCurrent ) / INTERPOLATION_DURATION;
			_gainInterpolationRemaining = INTERPOLATION_DURATION;
		}
	}
	
	override public function processSignals( numSignals: Int ): Void
	{
		var signal: Signal = _output.current;
		
		for(i in 0...numSignals)
		{
			//-- GENERATE AMPLITUDE
			signal.l = signal.r = Math.sin( _phase * PI_2 ) * _gainCurrent;
			signal = signal.next;

			//-- ADVANCE WAVESHAPE PHASE
			_phase += _phaseIncrCurrent;
			_phase -= Math.floor( _phase );
			
			//-- INTERPOLATE FREQUENCY (IN PHASE DOMAIN)
			if( _phaseIncrInterpolationRemaining > 0 ) // greater than zero
			{
				if( 0 == --_phaseIncrInterpolationRemaining )
					_phaseIncrCurrent = _phaseIncrTarget; // done interpolate
				else
					_phaseIncrCurrent += _phaseIncrVelocity; // interpolate
			}

			//-- INTERPOLATE GAIN
			if( _gainInterpolationRemaining > 0 ) // greater than zero
			{
				if( 0 == --_gainInterpolationRemaining )
					_gainCurrent = _gainTarget; // done interpolate
				else
					_gainCurrent += _gainVelocity; // interpolate
			}
		}
	}		
}
