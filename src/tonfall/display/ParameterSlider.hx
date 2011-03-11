package tonfall.display;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import tonfall.core.Parameter;

class ParameterSlider extends Sprite
{
	private static var TEXT_FORMAT : TextFormat = new TextFormat( 'Verdana', 9, 0, true );
	
	private var textField : TextField;
	private var thumb: ParameterSliderThumb;
	
	private var _parameter : Parameter;
	
	private var _dragging: Bool;
	private var _dragOffset : Float;

	public function new( parameter: Parameter )
	{
		super();
		
		_parameter = parameter;
		
		init();
	}

	private function init() : Void
	{
		_dragOffset = 0.0;
		
		graphics.beginFill( 0xFFFFFF );
		graphics.drawRoundRect( 0.0, 0.0, 288.0, 24.0, 4.0, 4.0 );
		graphics.endFill();
		graphics.beginFill( 0x333333 );
		graphics.drawRect( 4.0, 4.0, 192.0, 16.0 );
		graphics.endFill();
		
		textField = new TextField();
		textField.defaultTextFormat = TEXT_FORMAT;
		textField.selectable = false;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.x = 204;
		textField.y = 6.0;
		
		thumb = new ParameterSliderThumb();
		thumb.y = 4.0;

		addChild( textField );
		addChild( thumb );
		
		addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
		
		updateView();
	}

	private function handleMouseDown( event : MouseEvent ) : Void
	{
		_dragging = true;
		
		_dragOffset = event.target == thumb ? thumb.mouseX - 4.0 : 0.0;
		
		update( mouseX );
		
		stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
		stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
	}
	
	private function handleMouseMove( event : MouseEvent ) : Void
	{
		if( _dragging )
		{
			update( mouseX );
		}
	}
	
	private function handleMouseUp( event : MouseEvent ) : Void
	{
		if( _dragging )
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			
			_dragging = false;
		}
	}
	
	private function update( x: Float ): Void
	{
		var value: Float = ( ( x - _dragOffset ) - 16.0 ) / 176.0;

		if( value < 0.0 )
			value = 0.0;
		else
		if( value > 1.0 )
			value = 1.0;
		
		_parameter.value = value;
	
		updateView();	
	}
	
	private function updateView(): Void
	{
		var value: Float = _parameter.value;
		
		thumb.x = 4.0 + value * 176.0;

		textField.text = _parameter.name + ' ' + Math.round( value * 100.0 ) + '%';
	}
}
