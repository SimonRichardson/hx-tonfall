package tonfall.core;

import tonfall.util.FloatUtil;

class BlockInfo 
{
	private var _numSignals: Int;

	// Following values in musical time (bars)
	private var _barFrom : Float;
	private var _barTo : Float;
	
	public var numSignals(getNumSignals, never) : Int;
	public var barFrom(getBarFrom, never) : Float;
	public var barTo(getBarTo, never) : Float;
	
	public function new()
	{
		
	}
	
	public function reset( numSignals: Int, from: Float, to: Float ) : Void
	{
		_numSignals = numSignals;
		_barFrom = from;
		_barTo = to;
	}

	public function getNumSignals() : Int
	{
		return _numSignals;
	}

	public function getBarFrom() : Float
	{
		return _barFrom;
	}

	public function getBarTo() : Float
	{
		return _barTo;
	}
	
	public function toString() : String
	{
		return '[BlockInfo' + 
			   ' numSignals: ' + _numSignals + 
			   ', barFrom: ' + FloatUtil.toFixed(_barFrom, 3) + 
			   ', barTo: ' + FloatUtil.toFixed(_barTo, 3) + 
			   ']';
	}
}
