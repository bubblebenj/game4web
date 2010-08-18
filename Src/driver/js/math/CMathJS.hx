/**
 * ...
 * @author de
 */

package Game.Src.driver.js.math;

class CMathJS 
{
	
	public static function Build44( _Mat : CMatrix44 ) : Float32Array
	{
		return new Float32Array( _Mat.ToArray() );
	}
	
}