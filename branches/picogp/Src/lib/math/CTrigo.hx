/**
 * ...
 * @author Benjamin Dubois
 */

package math;

class CTrigo
{	
	public static inline function RadToDeg( _Rad : Float ) : Float
	{
		return _Rad * Constants.RAD_TO_DEG;
	}
	
	public static inline function DegToRad( _Deg : Float ) : Float
	{
		return _Deg * Constants.DEG_TO_RAD;
	}
	
	public static inline function V2DToRad( _V2D : CV2D ) : Float
	{
		return Math.atan2( _V2D.y, _V2D.x );
	}
}