/**
 * ...
 * @author de
 */

package driver.js.renderer;

import kernel.CSystem;
import kernel.CRsc;
import js.Dom;

class CRscImageJS extends CRscImage
{
	var m_Img : Image;
	
	public function new() 
	{
		super();
		m_Img = null;
	}
	
	public override function SetPath( _Path : String )
	{
		
	}
	
}