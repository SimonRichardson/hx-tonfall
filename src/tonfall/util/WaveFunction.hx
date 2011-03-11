package tonfall.util;

/**
 * Creates basic waveforms
 * 
 * @author Andre Michelle
 */
class WaveFunction 
{
	/**
	 * @param phase a value between zero and one
	 * @return bipolar /\ waveform
	 */
	public static inline function biTriangle( phase : Float ) : Float
	{
		if( 0.5 > phase ) return phase * 4.0 - 1.0;
		
		return 3.0 - phase * 4.0;
	}

	/**
	 * @param phase a value between zero and one
	 * @return bipolar ~ sinus
	 */
	public static inline function biSinus( phase : Float ) : Float
	{
		return Math.sin( phase * 2.0 * Math.PI );
	}

	/**
	 * @param phase a value between zero and one
	 * @return bipolar / sawtooth
	 */
	public static inline function biSawtooth( phase : Float ) : Float
	{
		return phase * 2.0 - 1.0;
	}

	/**
	 * @param phase a value between zero and one
	 * @return bipolar [ square
	 */
	public static inline function biSquare( phase : Float, width : Float = 0.5 ) : Float
	{
		return phase < width ? 1.0 : -1.0;
	}
	
	/**
	 * @param phase a value between zero and one
	 * @return normalized /\ waveform
	 */
	public static inline function normTriangle( phase : Float ) : Float
	{
		if( 0.5 > phase ) return phase * 2.0;

		return 2.0 - phase * 2.0;
	}

	/**
	 * @param phase a value between zero and one
	 * @return normalized ~ sinus
	 */
	public static inline function normSinus( phase : Float ) : Float
	{
		return Math.sin( phase * 2.0 * Math.PI ) * 0.5 + 0.5;
	}

	/**
	 * @param phase a value between zero and one
	 * @return normalized / sawtooth
	 */
	public static inline function normSawtooth( phase : Float ) : Float
	{
		return phase;
	}

	/**
	 * @param phase a value between zero and one
	 * @return normalized [ square
	 */
	public static inline function normSquare( phase : Float, width : Float = 0.5 ) : Float
	{
		return phase < width ? 1.0 : 0.0;
	}
}
