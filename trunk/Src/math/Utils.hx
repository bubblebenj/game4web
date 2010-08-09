/**
 * ...
 * @author de
 */

package math;

class Utils 
{
	public static function RoundNearest( _F0 : Float ) : Int
	{
		if(_F0<0)
		{
			return Std.int(_F0 - 0.5);
		}
		else
		{
			return Std.int(_F0 + 0.5);
		}
	}
	
	public static function RoundNearestF( _F0 : Float ) : Float
	{
		if(_F0<0)
		{
			return Std.int(_F0 - 0.5);
		}
		else
		{
			return Std.int(_F0 + 0.5);
		}
	}
	
}