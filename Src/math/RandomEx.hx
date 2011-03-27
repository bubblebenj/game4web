/**
 * ...
 * @author de
 */

package math;

class RandomEx 
{
	public static function DiceF( _Min :Float , _Max:Float ) : Float
	{
		return Math.random() * (_Max -_Min) + _Min;
	}
	
}