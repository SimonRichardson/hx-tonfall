package tonfall.core;

/**
 * TimeEventNote describes a note event
 * 
 * @author Andre Michelle
 */
class TimeEventNote extends TimeEvent
{
	public var note: Float;
	
	public var velocity: Float;
	
	public var barDuration: Float;
	
	public function new()
	{
		super();
		
		note = 60.0;
		velocity = 1.0;
		barDuration = 0.0;
	}
	
	override public function dispose() : Void
	{
		note = 0.0;
		velocity = 0.0;
		barDuration = 0.0;
	}
	
	public function toString(): String
	{
		return '[TimeEventNote '+
				'barPosition: ' + barPosition + 
				', barDuration: ' + barDuration + 
				', note: ' + note + 
				', velocity: ' + velocity + 
				']';
	}
}
