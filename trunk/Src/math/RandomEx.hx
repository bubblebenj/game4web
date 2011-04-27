/**
 * ...
 * @author de
 */

package math;

class RandomEx 
{
	public static function DiceI( _Min : Int , _Max : Int ) : Int
	{
		return Std.int( Math.random() * (_Max -_Min) ) + _Min;
	}
	
	public static function DiceF( _Min : Float , _Max : Float ) : Float
	{
		return Math.random() * (_Max -_Min) + _Min;
	}

	public static function RandBox( 	_Out : CV2D,
							_P0X:Float, _P0Y : Float,
							_P1X:Float, _P1Y : Float) : CV2D 
	{
		_Out.x = DiceF(_P0X, _P1X);
		_Out.y = DiceF(_P0Y, _P1Y);
		return _Out;
	}
}