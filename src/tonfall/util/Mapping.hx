package tonfall.util;

/**
 * @author Andre Michelle
 */
class Mapping 
{
	
	public inline static function mapLinear( normalized:Float, min: Float, max: Float ) : Float
	{
		return min + normalized * ( max - min );
	}

	public inline static function mapExp( normalized:Float, min: Float, max: Float ) : Float
	{
		return min * Math.exp( normalized * Math.log( max / min ) );
	}
}
