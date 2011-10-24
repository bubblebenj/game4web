
/**
 * ...
 * @author bd
 */

package logic.collision;

import math.CRect2D;
import math.CV2D;

class CRectangleCollision
{

	public static  inline function Point( _TL : CV2D, _Size : CV2D, _Point : CV2D ) : Bool
	{
		if( _Point == null )
		{
			return false;
		}
		else
		{	
			var l_TL : CV2D	= _TL;
			var l_BR : CV2D	= CV2D.OperatorPlus( _TL, _Size );
			
			return	_Point.x >= l_TL.x
			&&		_Point.y >= l_TL.y
			&&		_Point.x <= l_BR.x
			&&		_Point.y <= l_BR.y;
		}
	}
	
}