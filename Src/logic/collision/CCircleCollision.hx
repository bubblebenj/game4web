
/**
 * ...
 * @author bd
 */

package logic.collision;

import rsc.CRscSpline;
import math.CV2D;
import math.CV3D;
import math.Registers;

class CCircleCollision 
{
	public static  inline function Point( _CirclePos : CV2D, _Radius : Float, _Point : CV2D ) : Bool
	{
		var l_Dist2	: Float	= CV2D.GetDistance2( _CirclePos, _Point );
		var l_Rad2	: Float	= _Radius * _Radius;
		if ( l_Dist2 < l_Rad2 )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public static function Spline( _CirclePos : CV2D, _Radius : Float, _Spline : CRscSpline, _SplineScaleFactor : Float ) : Bool
	{
		var l_TrackDist		: Float	= _Spline.GetDistanceFromPosition( new CV3D( _CirclePos.x * _SplineScaleFactor, 0, _CirclePos.y * _SplineScaleFactor ) );
		var l_V3DTrackPos	: CV3D	= new CV3D( 0, 0, 0 ); 
		_Spline.GetPositionFromDistance( l_TrackDist, l_V3DTrackPos );
		
		var l_TrackPos		: CV2D	= Registers.V2_8;
		l_TrackPos.Set( l_V3DTrackPos.x, l_V3DTrackPos.z );
		
		var l_CirclePos		: CV2D	= Registers.V2_9;
		l_CirclePos.Set( _CirclePos.x * _SplineScaleFactor, _CirclePos.y * _SplineScaleFactor );
		
		return CCircleCollision.Point( l_CirclePos, _Radius, l_TrackPos );
	}
	
}