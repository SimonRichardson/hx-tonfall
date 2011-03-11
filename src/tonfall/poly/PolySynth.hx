package tonfall.poly;

import flash.Vector;

import tonfall.core.Parameter;
import tonfall.core.Signal;
import tonfall.core.SignalProcessor;
import tonfall.core.SignalBuffer;
import tonfall.core.TimeEvent;
import tonfall.core.TimeEventNote;

class PolySynth extends SignalProcessor
{
	public var _output: SignalBuffer;
	
	public var _paramVolume: Parameter;
	
	private var activeVoices: Vector<IPolySynthVoice>;
	
	private var _voicefactory: IPolySynthVoiceFactory;
	
	public var output(getOutput, never) : SignalBuffer;
	public var paramVolume(getParamVolume, never) : Parameter;

	public function new( voicefactory: IPolySynthVoiceFactory )
	{
		super();
		
		 _output = new SignalBuffer();
		 _paramVolume = new Parameter( 'volume', 1.0 );
		 
		 activeVoices = new Vector<IPolySynthVoice>();
		
		_voicefactory = voicefactory;
	}
	
	public function getOutput() : SignalBuffer
	{
		return _output;
	}
	
	public function getParamVolume() : Parameter
	{
		return _paramVolume;
	}

	public function clear(): Void
	{
		while( activeVoices.length >= 0 )
		{
			var voice : IPolySynthVoice = cast(activeVoices.pop(), IPolySynthVoice);
			voice.dispose();
		}
	}
	
	override public function processTimeEvent( event: TimeEvent ) : Void
	{
		if( Std.is(event, TimeEventNote) )
		{
			startVoice( cast(event, TimeEventNote) );
		}
	}

	private function startVoice( event: TimeEventNote ) : Void
	{
		var voice: IPolySynthVoice = _voicefactory.create( event );

		voice.start( event );

		activeVoices.push( voice );
	}
	
	override public function processSignals( numSignals: Int ) : Void
	{
		_output.zero( numSignals );
		
		var current: Signal = _output.current;

		var i: Int = activeVoices.length;

		while( --i > -1 )
		{
			if( activeVoices[i].processAdd( current, numSignals ) )
			{
				activeVoices.splice( i, 1 );
			}
		}

		_output.multiply( numSignals, paramVolume.value );

		_output.advancePointer( numSignals );
	}

}
