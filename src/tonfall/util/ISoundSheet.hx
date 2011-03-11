package tonfall.util;

/**
 * Defines a sheet of an instrument where keys are stored in a single audio file
 * 
 * [Check /load/piano.mp3 for instance]
 * 
 * @author Andre Michelle
 */
interface ISoundSheet 
{
	function getKeyIndexByNote( note: Int ) : Int;
		
	function getFrequencyByKeyIndex( keyIndex: Int ) : Number;
		
	function getStartPositionFromKeyIndex( keyIndex: Int ) : Number;
		
	function getEndPositionFromKeyIndex( keyIndex: Int ) : Number;
	
	function getDecoder() : IAudioDecoder;
}
