package tonfall.util;

class FloatUtil 
{
	
	public static inline function toFixed(number:Float, precision:Int = 5):Float
	{
    	//default returns (10000 * number) / 10000
    	//should correct very small floating point errors
    	var correction:Float = Math.pow(10, precision);
    	return Math.round(correction * number) / correction;
	}
}
