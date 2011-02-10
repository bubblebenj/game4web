/**
 * ...
 * @author bd
 */

package logic.collision;

import CDriver;

import kernel.Glb;

import math.CRect2D;
import math.CV2D;


class CBimapCollision 
{
	/* If no _ARGB color is define, the alpha channel will be considered */
	public static function Pixel( _Bitmap : C2DImage, _Point : CV2D,  ?_ARGB : Int ) : Bool
	{
		if ( _ARGB != null )
		{	
			//trace( "0x" + Utils.IntToStr( _Bitmap.GetARGB( _Point ), 16 ) );
			return ( _Bitmap.GetRGB( _Point ) == _ARGB ) ? true : false;
		}
		else
		{
			//trace( "0x" + Utils.IntToStr( _Bitmap.GetARGB( _Point ), 16 ) + " >>> " + _Bitmap.GetARGB( _Point ));
			return ( ( _Bitmap.GetARGB( _Point ) - _Bitmap.GetRGB( _Point ) ) == 0 ) ? true : false;
		}
	}
	
	/* /!\ DO NOT USE TOOOOOOOOOOOOOO SLOW /!\ */
	/* If no _ARGB color is define, the alpha channel will be considered */
	public static function Bitmap( _BitmapA : C2DImage, _BitmapB : C2DImage, ?_ARGB : Int ) : Bool
	{
		// determine common area
		// Should be compute another way --> doesn't take rotation into account --> the real image is larger and wider
			var l_Left		: Float	= Math.max( _BitmapA.GetTL().x, _BitmapB.GetTL().x );
			var l_Top		: Float	= Math.max( _BitmapA.GetTL().y, _BitmapB.GetTL().y );
			var l_Right		: Float	= Math.min( _BitmapA.GetTL().x + _BitmapA.GetSize().x , _BitmapB.GetTL().x + _BitmapB.GetSize().x  );
			var l_Bottom	: Float	= Math.min( _BitmapA.GetTL().y + _BitmapA.GetSize().y , _BitmapB.GetTL().y + _BitmapB.GetSize().y  );
		
		// compare each pixel from both Bitmap
		var l_PixelDist	: Float	= 10 / Glb.GetSystem().m_Display.m_Height; // should be 1 but take too much time
		var l_Point		: CV2D	= new CV2D( 0, 0 );
		var i_x			: Float;
		
		var i_y			: Float = l_Top;
		while ( i_y <= l_Bottom )
		{
			i_x	= l_Left;
			while ( i_x <= l_Right )
			{
				l_Point.Set( i_x, i_y );
				if ( CBimapCollision.Pixel( _BitmapA, l_Point ) && CBimapCollision.Pixel( _BitmapB, l_Point ) )
				{
					return true;
				}
				i_x += l_PixelDist;
			}
			i_y	+= l_PixelDist;
		}
		return false;
	}
}