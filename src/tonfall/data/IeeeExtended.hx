package tonfall.data;

/*
 * C O N V E R T   T O   I E E E   E X T E N D E D
 */
/* Copyright (C) 1988-1991 Apple Computer, Inc.
 * All rights reserved.
 *
 * Machine-independent I/O routines for IEEE floating-point numbers.
 *
 * NaN's and infinities are converted to HUGE_VAL or HUGE, which
 * happens to be infinity on IEEE machines.  Unfortunately, it is
 * impossible to preserve NaN's in a machine-independent way.
 * Infinities are, however, preserved on IEEE machines.
 *
 * These routines have been tested on the following machines:
 *    Apple Macintosh, MPW 3.1 C compiler
 *    Apple Macintosh, THINK C compiler
 *    Silicon Graphics IRIS, MIPS compiler
 *    Cray X/MP and Y/MP
 *    Digital Equipment VAX
 *
 *
 * Implemented by Malcolm Slaney and Ken Turkowski.
 *
 * Malcolm Slaney contributions during 1988-1990 include big- and little-
 * endian file I/O, conversion to and from Motorola's extended 80-bit
 * floating-point format, and conversions to and from IEEE single-
 * precision floating-point format.
 *
 * In 1991, Ken Turkowski implemented the conversions to and from
 * IEEE double-precision format, added more precision to the extended
 * conversions, and accommodated conversions involving +/- infinity,
 * NaN's, and denormalized numbers.
 */
class IeeeExtended 
{
	
	/**
	 * Converted to Actionscript from
	 * http://code.google.com/p/audacity/source/browse/audacity-src/branches/Audacity_UmixIt/audacity-src/lib-src/libnyquist/snd/ieeecvt.c?spec=svn10483&r=10483
	 * 
	 * @author Andre Michelle
	 */
	public static inline function forward( num: Number, bytes: ByteArray ) : Void
	{
		var sign: Int;
		var expon: Int;
		var fMant: Number;
		var fsMant: Number;
		var hiMant: UInt;
		var loMant: UInt;

		if (num < 0)
		{
			sign = 0x8000;
			num *= -1;
		}
		else
		{
			sign = 0;
		}

		if (num == 0.0)
		{
			expon = 0;
			hiMant = 0;
			loMant = 0;
		}
		else
		{
			expon = Math.log( num ) / Math.LN2;
			
			fMant = num / Math.pow( 2.0, expon );
			
			while( fMant >= 1.0 )
			{
				fMant *= 0.5;
				++expon;
			}
			
			if ( ( expon > 16384 ) || !( fMant < 1.0 ) )
			{
				/* infinity */
				expon = sign | 0x7FFF;
				hiMant = 0;
				loMant = 0;
			}
			else
			{
				/* Finite */
				expon += 16382;

				if ( expon < 0 )
				{
					/* denormalized */
					fMant = ldexp( fMant, expon );
					expon = 0;
				}
				expon |= sign;
				fMant = ldexp( fMant, 32 );
				fsMant = Math.floor( fMant );
				hiMant = floatToUnsigned( fsMant );
				fMant = ldexp( fMant - fsMant, 32 );
				fsMant = Math.floor( fMant );
				loMant = floatToUnsigned( fsMant );
			}
		}
		
		bytes.writeByte( expon >> 8 );
		bytes.writeByte( expon );
		bytes.writeByte( hiMant >> 24 );
		bytes.writeByte( hiMant >> 16 );
		bytes.writeByte( hiMant >> 8 );
		bytes.writeByte( hiMant );
		bytes.writeByte( loMant >> 24 );
		bytes.writeByte( loMant >> 16 );
		bytes.writeByte( loMant >> 8 );
		bytes.writeByte( loMant );
	}
	
	public static inline function inverse( bytes: ByteArray ) : Number
	{
		var byte0: Int = bytes.readUnsignedByte();
		var byte1: Int = bytes.readUnsignedByte();
		var byte2: Int = bytes.readUnsignedByte();
		var byte3: Int = bytes.readUnsignedByte();
		var byte4: Int = bytes.readUnsignedByte();
		var byte5: Int = bytes.readUnsignedByte();
		var byte6: Int = bytes.readUnsignedByte();
		var byte7: Int = bytes.readUnsignedByte();
		var byte8: Int = bytes.readUnsignedByte();
		var byte9: Int = bytes.readUnsignedByte();

		var expon: Int = ( ( byte0 & 0x7F ) << 8 ) | ( byte1 & 0xFF );
		var hiMant: UInt = ( ( byte2 & 0xFF ) << 24 ) | ( ( byte3 & 0xFF ) << 16) | ( ( byte4 & 0xFF ) << 8) | ( ( byte5 & 0xFF ) );
		var loMant: UInt = ( ( byte6 & 0xFF ) << 24 ) | ( ( byte7 & 0xFF ) << 16) | ( ( byte8 & 0xFF ) << 8) | ( ( byte9 & 0xFF ) );

		var f: Number;

		if ( expon == 0 && hiMant == 0 && loMant == 0 )
		{
			return 0.0;
		}
		else
		{
			if (expon == 0x7FFF)
			{
				// Vaughan, 2010-06-15: Linkage problem with VS2008:   HUGE_VAL;
				return Number.NaN;
			}
			else
			{
				expon -= 16383;

				f  = ldexp( hiMant, expon -= 31 );
				f += ldexp( loMant, expon -= 32 );
			}
		}

		if ( byte0 & 0x80 )
			return -f;
		else
			return f;
	}
	
	private static inline function floatToUnsigned( x: Number ): UInt
	{
		return ( ( UInt( x - 2147483648.0 ) ) + 2147483647 ) + 1;
	}

	private static inline function ldexp( x: Number, exp: Int ): Number
	{
		return x * Math.pow( 2.0, exp );
	}
}
