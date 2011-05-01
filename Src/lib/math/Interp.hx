/**
 * ...
 * @author de
 */

package math;

class Interp 
{
	//return _v0 + ( _ratio) * (_v1 - _v0);
	public static function Lerp( _ratio : Float, _v0 : Float, _v1 : Float) : Float
	{
		return _v0 + ( _ratio) * (_v1 - _v0);
	}
	
	public static function SInterp(_ratio : Float, _v0 : Float, _v1 : Float)
	{
		var ft =_ratio * 3.1415927;
		var f = (1 - Math.cos(ft)) * 0.5;
		return  Lerp( f, _v0, _v1);
	}
	
}