package tonfall.core;

class TimeEvent 
{
	public var barPosition: Float; // in bars
	
	public function new()
	{
	}
	
	public function dispose() : Void 
	{
		throw 'Method "dispose" is marked abstract.';
	}
}
