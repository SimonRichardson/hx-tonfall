package tonematrix;

import tonfall.core.BlockInfo;
import tonfall.core.Processor;
import tonfall.core.TimeEventNote;

import flash.Vector;

class TonematrixSequencer extends Processor
{

	public static var ToneMatrixNotes : Array<Int> = [96,93,91,89,86,84,81,79,77,74,72,69,67,65,62,60];
	
	public var pattern: Vector<Vector<Bool>>;
	
	public var receiver: Processor;
	
	public function new()
	{
		super();
				
		pattern = new Vector<Vector<Bool>>(16,true); 
	
		for(i in 0...16)
		{
			pattern[i] = new Vector<Bool>(16,true);
		}
	}
	
	override public function process( info : BlockInfo ) : Void
	{
		var index: Int = Math.floor( info.barFrom * 16.0);
		var position: Float = index / 16.0;
		
		while( position < info.barTo )
		{
			if( position >= info.barFrom )
			{
				for(i in 0...16)
				{
					if(pattern[index%16][i])
					{
						var event: TimeEventNote = new TimeEventNote();

						event.barPosition = position;
						event.note = ToneMatrixNotes[i];
						event.barDuration = 1.0/16.0;
						
						receiver.addTimeEvent(event);
					}
				}
			}

			position += 1.0/16.0;
			++index;
		}
	}

}