package tonfall.core;

class Parameter 
{
	private var _name : String;
	private var _value : Float;
	
	public var name(getName, never) : String;
	public var value(getValue, setValue) : Float;

	public function new( name : String, value : Float = 0.0 )
	{
		_name = name;
		_value = value;
	}

	public function getName() : String
	{
		return _name;
	}

	public function getValue() : Float
	{
		return _value;
	}

	public function setValue( value : Float ) : Float
	{
		_value = value;
		return _value;
	}
}
