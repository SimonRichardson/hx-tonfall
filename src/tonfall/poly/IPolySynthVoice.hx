package tonfall.poly;

import tonfall.core.Signal;
import tonfall.core.TimeEvent;

/**
 * IPolySynthVoice does the actual audio generation of a PolySynth.
 * 
 * @author Andre Michelle
 */
interface IPolySynthVoice
{
	function start( event: TimeEvent ): Void;
	
	function stop(): Void;
	
	function processAdd( current: Signal, numSignals: Int ):Bool;
	
	function dispose(): Void;
}
