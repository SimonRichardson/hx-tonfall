package tonfall.poly;

import tonfall.core.TimeEventNote;
	
/**
 * Creates an IPolySynthVoice
 * @author Andre Michelle
 */
interface IPolySynthVoiceFactory 
{
	function create( event: TimeEventNote ): IPolySynthVoice;
}
