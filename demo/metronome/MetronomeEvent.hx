package metronome;

import tonfall.core.TimeEvent;

class MetronomeEvent extends TimeEvent
{
	public var bar: Int;

	public var beat: Int;
	
	public function new()
	{
		super();
		
		bar = 0;
		beat = 0;
	}
	
	override public function dispose() : Void
	{
		bar = 0;
		beat = 0;
	}
	
	public function toString(): String
	{
		return '[MetronomeEvent' +
				' position: ' + bar + 
				', bar: ' + bar + 
				', beat: ' + beat + 
				']';
	}
}
