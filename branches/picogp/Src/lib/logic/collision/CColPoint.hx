/**
 * ...
 * @author Benjamin Dubois
 */

package logic.collision;

import math.CV2D;
import math.Utils;
import renderer.C2DQuad;
import renderer.I2DImage;

class CPointCollision
{
	public static function CollidesPoint( _M : CV2D, _O : CV2D ) : Bool
	{
		return CV2D.AreEqual( _M, _O );
	}
	
	public static function CollidesRectangle( _Point : CV2D, _Rect : C2DQuad ) : Bool
	{
		return ( 	_Point.x > _Rect.GetTL().x
				&& 	_Point.x < _Rect.GetTL().x + _Rect.GetSize().x
				&& 	_Point.y > _Rect.GetTL().y
				&&	_Point.y < _Rect.GetTL().y + _Rect.GetSize().y ) ? true : false;
	}
}