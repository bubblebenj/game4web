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
	
	/* _V2D can be any structure or class instance with x and y field
	 * assuming angle to ( 0, 0 )*/
	public static inline function V2DToRad( _V2D : { x : Float, y : Float } ) : Float
	{
		if ( _V2D.x == 0 )
		{
			if ( _V2D.y < 0 )
			{
				return Constants.PI * 1.5;
			}
			else
			{
				if ( _V2D.y > 0 )
				{
					return Constants.PI * 0.5;
				}
				else
				{
					trace( "\t \t No angle can be define with a couple of null values" );
					return Math.NaN;
				}
			}
		}
		else
		{
			return Math.atan( _V2D.y / _V2D.x );
		}
	}
}