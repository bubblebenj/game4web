/**
 * ...
 * @author Benjamin Dubois
 */

package logic.collision;
import math.CV2D;
import math.Utils;
import renderer.C2DQuad;
import kernel.Glb;
import renderer.I2DImage;

class CColPoint extends CV2D
{
	public function new( x : Int, y : Int ) 
	{
		super( x, y );
	}
	
	public static function CollidesPoint( _M : CV2D, _O : CV2D ) : Bool
	{
		return CV2D.AreEqual( _M, _O );
	}
	
	public static function CollidesRectangle( _Point : CV2D, _Rect : C2DQuad ) : Bool
	{
		return ( 	_Point.x > _Rect.GetCenter().x
				&& 	_Point.x < _Rect.GetCenter().x + _Rect.GetSize().x * 0.5
				&& 	_Point.y > _Rect.GetCenter().y
				&&	_Point.y < _Rect.GetCenter().y + _Rect.GetSize().y * 0.5) ? true : false;
	}
	
	/* If no transparent color is define, the alpha channel will be considered */
	public static function CollidesBitmap( _Point : CV2D, _Bitmap : I2DImage, ?_TransparentRGBColor : Int = 0) : Bool
	{
		if ( _TransparentRGBColor != 0 )
		{	
			return ( _Bitmap.GetRGB( _Point ) == _TransparentRGBColor ) ? true : false;
		}
		else
		{
			return ( _Bitmap.GetARGB( _Point ) == 0 ) ? true : false;
		}
	}
}