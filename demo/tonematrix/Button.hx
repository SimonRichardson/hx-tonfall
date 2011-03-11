package tonematrix;

import flash.display.Sprite;

class Button extends Sprite
{
	
	private var _u : Int;
	private var _v : Int;
	
	private var _selected: Bool;
	
	public var u(getU, never) : Int;
	public var v(getV, never) : Int;
	public var selected(getSelected, setSelected) : Bool;

	public function new( u : Int, v : Int )
	{
		super();
		
		_u = u;
		_v = v;
		
		update();
	}

	public function getU() : Int
	{
		return _u;
	}

	public function getV() : Int
	{
		return _v;
	}

	public function getSelected() : Bool
	{
		return _selected;
	}

	public function setSelected( selected : Bool ) : Bool
	{
		_selected = selected;
		
		update();
		
		return _selected;
	}
	
	private function update(): Void
	{
		graphics.clear();
		graphics.beginFill( _selected ? 0xEDEDED : 0x333333 );
		graphics.drawRoundRect( 2.0, 2.0, 30.0, 30.0, 6, 6 );
		graphics.endFill();
	}
}