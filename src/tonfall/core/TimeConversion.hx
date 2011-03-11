package tonfall.core;

/**
 * TimeConversion provides conversion between absolute and musical time.
 * 
 * One bar is based on 4/4 time signature.
 * 
 * @author Andre Michelle
 */
class TimeConversion 
{
	
	public static inline function barsToMillis( bars:Float, bpm: Float ):Float
	{
		return ( bars * 240.0 / bpm ) * 1000.0;
	}
	
	public static inline function barsToNumSamples( bars:Float, bpm: Float ):Float
	{
		return ( bars * 240.0 / bpm ) * SamplingRate.RATE;
	}
	
	public static inline function millisToBars( millis:Float, bpm: Float ):Float
	{
		return ( millis * bpm / 240.0 ) / 1000.0;
	}
	
	public static inline function numSamplesToBars( numSamples: Float, bpm: Float ):Float
	{
		return ( numSamples * bpm / 240.0 ) / SamplingRate.RATE;
	}
}
