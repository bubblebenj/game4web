/**
 * ...
 * @author de
 */

package math;

class RandomEx 
{
	/**
	 * Return a random integer in the [_Min, Max[ range
	 * Get a random integer in the range between _Min and _Max, _Max excluded
	 * /*\ Why not using Std.random( _Max - _Min ) + _Min ?
	 * 
	 * @param	_Min the minimum value the dice can return
	 * @param	_Max the maximum value +1 the dice can return
	 * @return	a value between _Min included and _Max excluded
	 */
	public static function DiceI( _Min : Int , _Max : Int ) : Int
	{
		/* e.g
		 * DiceI(1, 3)	= Std.Int( [0, 0.99999] * 2 ) + 1
		 * 				= Std.Int( [0, 1.99998] ) + 1
		 * 				= [0, 1] + 1
		 * 				= [1, 2]
		 */
		return Std.int( Math.random() * (_Max -_Min) ) + _Min;
	}
	
	/**
	 * Return a random integer in the [_Min, Max] range
	 * Get a random Int in the range between _Min and _Max
	 * @param	_Min the minimum value the dice can return
	 * @param	_Max the maximum value the dice can return
	 * @return	an Int between _Min and _Max included
	 */
	public static inline function DiceIClassic( _Min : Int , _Max : Int ) : Int
	{
		return DiceI( _Min, _Max + 1 );
	}
	
	/**
	 * Return a random float in the [_Min, Max[ range
	 * Get a random Float in a range between _Min and _Max, _Max excluded
	 * @param	_Min the lower limit of the range, included
	 * @param	_Max the upper limit of the range, exluded
	 * @return	an Int between _Min included and _Max excluded
	 */
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