/**
 * ...
 * @author de
 */

package ;

#if flash
import driver.js.renderer.C2DImageAS;
typedef CPlatform2DImage = C2DImageAS;
#elseif js
import driver.js.renderer.C2DImageJS;
typedef CPlatform2DImage = C2DImageJS;
#end

class Platform 
{
	//var l_Img  : C2DImage = new CPlatform2DImage();
	
}



