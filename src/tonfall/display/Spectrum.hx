package tonfall.display;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.media.SoundMixer;
import flash.utils.ByteArray;

import tonfall.core.Driver;

class Spectrum extends Sprite
{
	private static inline var WIDTH: Int = 352;
	private static inline var HEIGHT: Int = 304;
	
	private static inline var BACKGROUND: Int = 0x333333;
	
	private var driver: Driver;
		
	private var bitmapWaveform: Bitmap;
	private var bitmapSpectrum: Bitmap;
	private var bitmapPeaksLeft: Bitmap;
	private var bitmapPeaksRight: Bitmap;
		
	private var outputArray: ByteArray;
	private var rectLine: Rectangle;
	private var rectPeak: Rectangle;
	
	public function new()
	{
		super();
		
		driver = Driver.getInstance();
		
		bitmapWaveform = new Bitmap( new BitmapData( 0x100, 0x80, false, 0x333333 ), PixelSnapping.ALWAYS );
		bitmapSpectrum = new Bitmap( new BitmapData( 0x100, 0x80, false, 0x333333 ), PixelSnapping.ALWAYS );
		bitmapPeaksLeft = new Bitmap( new BitmapData( 16, 272, false, 0x333333 ), PixelSnapping.ALWAYS );
		bitmapPeaksRight = new Bitmap( new BitmapData( 16, 272, false, 0x333333 ), PixelSnapping.ALWAYS );
		
		outputArray = new ByteArray();
		rectLine = new Rectangle( 0.0, 0.0, 1.0, 0.0 );
		rectPeak = new Rectangle( 0.0, 0.0, 16.0, 0.0 );
		
		graphics.beginFill( 0x222222 );
		graphics.drawRoundRect( 0.0, 0.0, WIDTH, HEIGHT, 8.0, 8.0 );
		graphics.endFill();
		
		bitmapWaveform.x = 16.0;
		bitmapWaveform.y = 16.0;
		addChild( bitmapWaveform );
		
		bitmapSpectrum.x = 16.0;
		bitmapSpectrum.y = 160.0;
		addChild( bitmapSpectrum );
		
		bitmapPeaksLeft.x = 288.0;
		bitmapPeaksLeft.y = 16.0;
		addChild( bitmapPeaksLeft );
		
		bitmapPeaksRight.x = 320.0;
		bitmapPeaksRight.y = 16.0;
		addChild( bitmapPeaksRight );
		
		addEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
		addEventListener( Event.REMOVED_FROM_STAGE, handleRemovedFromStage );
	}
		
	public function getWidth(): Float
	{
		return WIDTH;
	}
	
	public function getHeight(): Float
	{
		return HEIGHT;
	}
	
	private function handleEnterFrame( event: Event ): Void
	{
		paintWaveform();
		paintSpectrum();

		paintPeak( bitmapPeaksLeft.bitmapData, driver.leftPeak );
		paintPeak( bitmapPeaksRight.bitmapData, driver.rightPeak );
	}

	private function paintWaveform() : Void
	{
		var bitmapData: BitmapData = bitmapWaveform.bitmapData;
		
		bitmapData.lock();
		bitmapData.fillRect( bitmapData.rect, BACKGROUND );
		
		SoundMixer.computeSpectrum( outputArray, false );
		
		var l: Float;
		var r: Float;
		
		for(x in 0...0x100)
		{
			outputArray.position = x << 2;
			l = outputArray.readFloat();
			
			outputArray.position = ( x | 0x100 ) << 2;
			r = outputArray.readFloat();
			
			bitmapData.setPixel( x, Math.floor(0x40 + l * 0x40), 0xAAAAAA );
			bitmapData.setPixel( x, Math.floor(0x40 + r * 0x40), 0xCCCCCC );
		}

		bitmapData.unlock();
	}
	
	private function paintSpectrum() : Void
	{
		var bitmapData: BitmapData = bitmapSpectrum.bitmapData;
		
		bitmapData.lock();
		bitmapData.fillRect( bitmapData.rect, BACKGROUND );
		
		SoundMixer.computeSpectrum( outputArray, true, 1 );
		
		var l: Float;
		var r: Float;
		
		var h: Int;

		for(x in 0...0x100)
		{
			outputArray.position = x << 2;
			l = outputArray.readFloat();

			outputArray.position = ( x | 0x100 ) << 2;
			r = outputArray.readFloat();
			
			h = Math.floor(( l > r ? l : r ) * 0x80);

			rectLine.x = x;
			rectLine.y = 0x80 - h;
			rectLine.height = h;

			bitmapData.fillRect( rectLine, 0xAAAAAA );
		}
		
		bitmapData.unlock();
	}
		
	private function paintPeak( bitmapData: BitmapData, peak: Float ) : Void
	{
		bitmapData.lock();
		
		var yy:Int = Math.floor(( 1.0 - peak ) * 272.0);
		
		rectPeak.y = 0.0;
		rectPeak.height = yy;
		bitmapData.fillRect( rectPeak, BACKGROUND );
		
		rectPeak.y = yy;
		rectPeak.height = 272.0 - yy;
		bitmapData.fillRect( rectPeak, 0xAAAAAA );
		
		bitmapData.unlock();
	}
	
	private function handleAddedToStage( event: Event ): Void
	{
		addEventListener( Event.ENTER_FRAME, handleEnterFrame );
	}

	private function handleRemovedFromStage( event: Event ): Void
	{
		removeEventListener( Event.ENTER_FRAME, handleEnterFrame );
	}
	
	public function dispose(): Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
		removeEventListener( Event.REMOVED_FROM_STAGE, handleRemovedFromStage );
	}
}
