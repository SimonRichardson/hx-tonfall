package stereogain;

import tonfall.core.Signal;
import tonfall.core.SignalBuffer;
import tonfall.core.SignalProcessor;
import tonfall.util.StereoMatrix;

class StereoSine extends SignalProcessor
{
	public var _output: SignalBuffer;
	
	public var _matrix: StereoMatrix;
	
	private var _phaseL: Float;
	private var _phaseR: Float;
	
	private var _phaseIncrL: Float;
	private var _phaseIncrR: Float;
	
	public var output(getOutput, never) : SignalBuffer;
	public var matrix(getMatrix, never) : StereoMatrix;
	
	public function new()
	{
		super();
		
		_output = new SignalBuffer();
		_matrix = new StereoMatrix();
		
		_phaseL = 0.0;
		_phaseR = 0.0;
		
		_phaseIncrL = 440.0 / 44100.0;
		_phaseIncrR = 330.0 / 44100.0;
	}
	
	public function getOutput() : SignalBuffer
	{
		return _output;
	}
	
	public function getMatrix() : StereoMatrix
	{
		return _matrix;
	}
	
	override public function processSignals( numSignals: Int ): Void
	{
		var s: Signal = _output.current;
		
		for(i in 0...numSignals)
		{
			s.l = Math.sin( _phaseL * Math.PI * 2.0 );
			s.r = Math.sin( _phaseR * Math.PI * 2.0 );
			
			_phaseL += _phaseIncrL;
			_phaseL -= Math.floor( _phaseL );
			_phaseR += _phaseIncrR;
			_phaseR -= Math.floor( _phaseR );
			
			matrix.transform( s, s );
			
			s = s.next;
		}
	}
}