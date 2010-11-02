/**
 * ...
 * @author de
 */

package ;


#if flash
	typedef C2DImage		= driver.as.renderer.C2DImageAS;
	typedef CTextField		= driver.as.renderer.CTextFieldAS;
	typedef C2DContainer	= driver.as.renderer.C2DContainerAS;
#elseif js
	typedef C2DImage	= driver.js.renderer.C2DImageJS;
	//typedef CTextField = driver.js.renderer.CTextFieldJS;
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


