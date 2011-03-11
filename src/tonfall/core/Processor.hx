package tonfall.core;

import flash.Vector;

/**
 * Processor is a member in the engine's processing chain.
 * 
 * A Processor can generate audio or sequence events.
 * 
 * @author Andre Michelle
 */
class Processor 
{
	public var events: Vector<TimeEvent>;
	
	public var engine: Engine;
	
	public function new() 
	{
		events = new Vector<TimeEvent>();
		engine = Engine.getInstance();
	}
	
	public function addTimeEvent( event: TimeEvent ): Void
	{
		if( -1 < events.indexOf( event ) )
		{
			throw 'Element already exists.';
		}

		events.push( event );
		events.sort( sortOnPosition );
	}

	public function process( info: BlockInfo ): Void
	{
		throw 'Method "process" is marked abstract.';
	}
	
	private function sortOnPosition( a: TimeEvent, b: TimeEvent ): Int
	{
		if( a.barPosition > b.barPosition )
			return 1;
		if( a.barPosition < b.barPosition )
			return -1;

		return 0;
	}
}
