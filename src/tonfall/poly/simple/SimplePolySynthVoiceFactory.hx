package tonfall.poly.simple;

import tonfall.core.TimeEventNote;
import tonfall.poly.IPolySynthVoice;
import tonfall.poly.IPolySynthVoiceFactory;

class SimplePolySynthVoiceFactory implements IPolySynthVoiceFactory
{
	public static var INSTANCE: SimplePolySynthVoiceFactory = new SimplePolySynthVoiceFactory();
	
	public function new()
	{
		
	}
	
	public function create( event: TimeEventNote ) : IPolySynthVoice
	{
		return new SimplePolySynthVoice();
	}
}
