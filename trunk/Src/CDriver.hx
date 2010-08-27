/**
 * ...
 * @author de
 */

package ;

#if flash
typedef CDriver2DImage = driver.js.renderer.C2DImageAS;
#elseif js
typedef CDriver2DImage = driver.js.renderer.C2DImageJS;
#end

/*
import renderer.C2DImage;
class CPlatform
{
	public static function Newer( _t )
	{
		switch( _t )
		{
		 case Type.typeof(C2DImage):
			#if flash
			return cast new driver.js.renderer.C2DImageAS();

			#elseif js
			return cast new driver.js.renderer.C2DImageJS();
			#end
		}
	}
}
*/


