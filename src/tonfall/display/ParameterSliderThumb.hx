package tonfall.display;

import flash.display.Sprite;

class ParameterSliderThumb extends Sprite
{
	public function new()
	{
		super();
		
		graphics.beginFill( 0xCCCCCC );
		graphics.drawRect( 0.0, 0.0, 16.0, 16.0 );
		graphics.endFill();
		
		buttonMode = true;
		useHandCursor = true;
		cacheAsBitmap = true;
	}
}
