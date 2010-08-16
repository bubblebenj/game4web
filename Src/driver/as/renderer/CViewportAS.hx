/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import kernel.CTypes;
import kernel.Glb;
import renderer.CViewport;

class CViewportAS extends CViewport
{
	
	public override function Activate() : Result
	{
		/* I dont know if there's a way to change viewport size on the
		 * fly with the flash API */
		//Glb.g_SystemJS.GetGL().Viewport( 	m_x * Glb.g_System.m_Display.m_Width,
									//m_y * Glb.g_System.m_Display.m_Height,
									//m_w * Glb.g_System.m_Display.m_Width,
									//m_h * Glb.g_System.m_Display.m_Height);
		return SUCCESS;
	}
}
