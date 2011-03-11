package tonfall.core;

class NoteToFrequency 
{
	
	/**
	 * Standard note <> frequency mapping
	 * 
	 * @author Andre Michelle
	 */
	public static inline function convert( note: Float = 60.0 ) : Float
	{
		return 440.0 * Math.pow( 2.0, ( note + 3.0 ) / 12.0 - 6.0 );
	}
}
