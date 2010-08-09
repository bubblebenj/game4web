/**
 * ...
 * @author de
 */

package Game.Src.driver.js.math;

class CMathJS 
{
	
	public static function Build44( _Mat : CMatrix44 ) : WebGLFloatArray
	{
		return new WebGLFloatArray( _Mat.ToArray() );
	}
	
}