package tonfall.dsp;

import tonfall.core.Signal;

class BiQuadFilter 
{
	public var a0: Float;
	public var a1: Float;
	public var a2: Float;
	public var a3: Float;
	public var a4: Float;

	public var x1l: Float;
	public var x2l: Float;
	public var y1l: Float;
	public var y2l: Float;
	public var x1r: Float;
	public var x2r: Float;
	public var y1r: Float;
	public var y2r: Float;

	public function new()
	{
		x1l = x2l = y1l = y2l = x1r = x2r = y1r = y2r = 0.0;
	}

	public function lowPass( fc: Float, fs: Float = 44100.0, bandwidth: Float = 1.0 ): Void
	{
		var omega: Float = 2.0 * Math.PI * fc / fs;
		var sn: Float = Math.sin( omega );
		var cs: Float = Math.cos( omega );

		var alpha: Float = sn / ( 2.0 * bandwidth );
		var b0: Float = ( 1.0 - cs ) / 2.0;
		var b1: Float = 1.0 - cs;
		var b2: Float = ( 1.0 - cs ) / 2.0;
		var a0: Float = 1.0 + alpha;
		var a1: Float = -2.0 * cs;
		var a2: Float = 1.0 - alpha;

		this.a0 = b0 / a0;
		this.a1 = b1 / a0;
		this.a2 = b2 / a0;
		this.a3 = a1 / a0;
		this.a4 = a2 / a0;
	}

	public function highPass( fc: Float, fs: Float = 44100.0, bandwidth: Float = 1.0 ): Void
	{
		var omega: Float = 2.0 * Math.PI * fc / fs;
		var sn: Float = Math.sin( omega );
		var cs: Float = Math.cos( omega );

		var alpha: Float = sn / ( 2.0 * bandwidth );
		var b0: Float = ( 1.0 + cs ) / 2.0;
		var b1: Float = -( 1.0 + cs );
		var b2: Float = ( 1.0 + cs ) / 2.0;
		var a0: Float = 1.0 + alpha;
		var a1: Float = -2.0 * cs;
		var a2: Float = 1.0 - alpha;

		this.a0 = b0 / a0;
		this.a1 = b1 / a0;
		this.a2 = b2 / a0;
		this.a3 = a1 / a0;
		this.a4 = a2 / a0;
	}

	public function peakBand( dbGain: Float, fc: Float, fs: Float = 44100.0, bandwidth: Float = 1.0 ): Void
	{
		var A: Float = Math.pow( 10.0, dbGain / 40.0 );
		var omega: Float = 2.0 * Math.PI * fc / fs;
		var sn: Float = Math.sin( omega );
		var cs: Float = Math.cos( omega );

		var alpha: Float = sn * sinh( Math.LN2 / 2.0 * bandwidth * omega / sn);
		var b0: Float = 1.0 + ( alpha * A );
		var b1: Float = -2.0 * cs;
		var b2: Float = 1.0 - ( alpha * A );
		var a0: Float = 1.0 + ( alpha / A );
		var a1: Float = -2.0 * cs;
		var a2: Float = 1.0 - ( alpha / A );

		this.a0 = b0 / a0;
		this.a1 = b1 / a0;
		this.a2 = b2 / a0;
		this.a3 = a1 / a0;
		this.a4 = a2 / a0;
	}

	public function lowShelf( dbGain: Float, fc: Float, fs: Float = 44100.0, shelfRate: Float = 1.414213562373095 ): Void
	{
		var A: Float = Math.pow( 10.0, dbGain / 40.0 );
		var omega: Float = 2.0 * Math.PI * fc / fs;
		var sn: Float = Math.sin( omega );
		var cs: Float = Math.cos( omega );

		var alpha: Float = sn / 2.0 * Math.sqrt( ( A + 1.0 / A ) * ( 1.0 / shelfRate - 1.0 ) + 2.0 );
		var beta: Float = 2.0 * Math.sqrt( A ) * alpha;

		var b0: Float = A * ( ( A + 1.0 ) - ( A - 1.0 ) * cs + beta );
		var b1: Float = 2.0 * A * ( ( A - 1.0 ) - ( A + 1.0 ) * cs );
		var b2: Float = A * ( ( A + 1.0 ) - ( A - 1.0 ) * cs - beta );
		var a0: Float = ( A + 1.0 ) + ( A - 1.0 ) * cs + beta;
		var a1: Float = -2.0 * ( ( A - 1.0 ) + ( A + 1.0 ) * cs );
		var a2: Float = ( A + 1.0 ) + ( A - 1.0 ) * cs - beta;

		this.a0 = b0 / a0;
		this.a1 = b1 / a0;
		this.a2 = b2 / a0;
		this.a3 = a1 / a0;
		this.a4 = a2 / a0;
	}

	public function highShelf( dbGain: Float, fc: Float, fs: Float = 44100.0, shelfRate: Float = 1.414213562373095 ): Void
	{
		var A: Float = Math.pow( 10.0, dbGain / 40.0 );
		var omega: Float = 2.0 * Math.PI * fc / fs;
		var sn: Float = Math.sin( omega );
		var cs: Float = Math.cos( omega );

		var alpha: Float = sn / 2.0 * Math.sqrt( ( A + 1.0 / A ) * ( 1.0 / shelfRate - 1.0 ) + 2.0 );
		var beta: Float = 2.0 * Math.sqrt( A ) * alpha;
		var b0: Float = A * ( ( A + 1.0 ) + ( A - 1.0 ) * cs + beta );
		var b1: Float = -2.0 * A * ( ( A - 1.0 ) + ( A + 1.0 ) * cs );
		var b2: Float = A * ( ( A + 1.0 ) + ( A - 1.0 ) * cs - beta );
		var a0: Float = ( A + 1.0 ) - ( A - 1.0 ) * cs + beta;
		var a1: Float = 2.0 * ( ( A - 1.0 ) - ( A + 1.0 ) * cs );
		var a2: Float = ( A + 1.0 ) - ( A - 1.0 ) * cs - beta;

		this.a0 = b0 / a0;
		this.a1 = b1 / a0;
		this.a2 = b2 / a0;
		this.a3 = a1 / a0;
		this.a4 = a2 / a0;
	}

	public function processSignal( signal: Signal ): Void
	{
		var li: Float = signal.l;
		var ri: Float = signal.r;

		var lf: Float = a0 * li + a1 * x1l + a2 * x2l - a3 * y1l - a4 * y2l;
		var rf: Float = a0 * ri + a1 * x1r + a2 * x2r - a3 * y1r - a4 * y2r;

		x2l = x1l;
		x1l = li;
		y2l = y1l;
		y1l = signal.l = lf;

		x2r = x1r;
		x1r = ri;
		y2r = y1r;
		y1r = signal.r = rf;
	}

	public function processSignals( signal: Signal, numSignals: Int ): Void
	{
		var li: Float;
		var ri: Float;

		var lf: Float;
		var rf: Float;

		++numSignals;

		while( --numSignals >= 0 )
		{
			li = signal.l;
			ri = signal.r;

			lf = a0 * li + a1 * x1l + a2 * x2l - a3 * y1l - a4 * y2l;
			rf = a0 * ri + a1 * x1r + a2 * x2r - a3 * y1r - a4 * y2r;

			x2l = x1l;
			x1l = li;
			y2l = y1l;
			y1l = signal.l = lf;

			x2r = x1r;
			x1r = ri;
			y2r = y1r;
			y1r = signal.r = rf;

			signal = signal.next;
		}
	}
	
}
