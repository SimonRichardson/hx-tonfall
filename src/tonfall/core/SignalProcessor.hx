package tonfall.core;

class SignalProcessor extends Processor
{
	public function new() 
	{
		super();
	}

	override public function process( info: BlockInfo ) : Void
	{
		var event: TimeEvent;
		
		var localIndex:Int = 0;

		var remaining: Int = info.numSignals;

		var eventOffset: Int;
		
		while( events.length > 0 ) // IF INPUT EVENTS EXISTS
		{
			event = events.shift();
						
			eventOffset = engine.deltaBlockIndexAt( event.barPosition ) - localIndex;
			
			if( 0 < eventOffset )
			{
				// ADVANCE IN BUFFER
				processSignals( eventOffset );

				remaining -= eventOffset;
				localIndex += eventOffset;
			}
			
			// SEND EVENT ON THE EXACT POSITION
			processTimeEvent( event );
			
			event.dispose();
		}

		if( remaining > 0 )
		{
			// PROCESS REST
			processSignals( remaining );
		}
	}
	
	public function processTimeEvent( event: TimeEvent ): Void
	{
		throw 'Method "processTimeEvent" is marked abstract.';
	}
	
	public function processSignals( numSignals: Int ): Void
	{
		throw 'Method "processSignals" is marked abstract.';
	}
}
