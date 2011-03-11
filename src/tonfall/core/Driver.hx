package tonfall.core;

import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.utils.ByteArray;

import haxe.Stack;

/**
 * Standard audio driver running on flash.media.Sound
 * 
 * @author Andre Michelle
 */
class Driver 
{
	public static inline var BLOCK_SIZE : Int = 3072;
	
	private static var instance: Driver;
		
	private var sound: Sound;
		
	private var zeroBytes: ByteArray;
	private var fillBytes: ByteArray;

	private var _engine: Engine;
	private var _soundChannel: SoundChannel;
	private var _latency: Float;
	private var _running: Bool;
	
	public var engine(getEngine, setEngine) : Engine;
	public var latency(getLatency, never) : Float;
	public var leftPeak(getLeftPeak, never) : Float;
	public var rightPeak(getRightPeak, never) : Float;
	public var running(getRunning, setRunning) : Bool;
	
	private function new()
	{
		if( instance != null )
		{
			throw 'AudioDriver is Singleton.';
		}
		
		_latency = 0.0;
		
		sound = new Sound();
		
		zeroBytes = new ByteArray();
		fillBytes = new ByteArray();
		
		zeroBytes.length = BLOCK_SIZE << 3;
		fillBytes.length = BLOCK_SIZE << 3;

		sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
	}
	
	public static function getInstance() : Driver
	{
		if( null == instance )
		{
			instance = new Driver();
		}
		
		return instance;
	}
	
	public function init() : Void
	{
		if ( null != _soundChannel )
		{
			throw 'Cannot inited twice.';
		}
		
		_soundChannel = sound.play();
		
		_running = true;
	}

	public function getEngine() : Engine
	{
		return _engine;
	}

	public function setEngine( value: Engine ) : Engine
	{
		if(_engine != value)
		{
			_engine = value;
		}
		
		return _engine;
	}

	public function getLatency() : Float
	{
		return _latency;
	}
	
	public function getLeftPeak(): Float
	{
		if( null == _soundChannel ) return 0.0;
		
		return _soundChannel.leftPeak;
	}
	
	public function getRightPeak(): Float
	{
		if( null == _soundChannel ) return 0.0;
		
		return _soundChannel.rightPeak;
	}

	public function getRunning(): Bool
	{
		return _running;
	}

	public function setRunning( running: Bool ): Bool
	{
		_running = running;
		return _running;
	}
	
	private function sampleData( event: SampleDataEvent ) : Void
	{
		if( _soundChannel != null )
		{
			// Compute difference from writing and audible audio data
			_latency = event.position / 44.1 - _soundChannel.position;
		}

		if( _engine == null || !_running )
		{
			event.data.writeBytes( zeroBytes );
		}
		else
		{
			fillBytes.position = 0;

			try
			{
				_engine.render( fillBytes, BLOCK_SIZE );
			}
			catch( e: Dynamic )
			{
				trace(e);
				
				trace( 'Error while rendering Audio.');
				trace(Stack.callStack());
				var stack = Stack.exceptionStack();
				for(i in 0...stack.length)
				{
					trace(stack[i]);	
				}
				
				return; // SHUT DOWN
			}

			event.data.writeBytes( fillBytes );
		}
	}
}
