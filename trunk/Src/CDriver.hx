/**
 * ...
 * @author de
 */

package ;

#if flash
	typedef CDriver2DImage = driver.as.renderer.C2DImageAS;
	typedef CDriverTextField = driver.as.renderer.CTextFieldAS;
#elseif js
	typedef CDriver2DImage = driver.js.renderer.C2DImageJS;
	//typedef CDriverTextField = driver.js.renderer.CTextFieldJS;
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


