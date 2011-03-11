package tonfall.core;

/**
 * Stereo audio data linked list item
 * 
 * @author Andre Michelle
 */
class Signal 
{
	public var l: Float; // LEFT CHANNEL
	public var r: Float; // RIGHT CHANNEL
	
	public var next: Signal; // NEXT POINTER
	
	public function new()
	{
		l = 0.0;
		r = 0.0;
	}
}
