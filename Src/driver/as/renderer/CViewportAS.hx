/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.MovieClip;
import kernel.CTypes;
import kernel.Glb;
import renderer.CViewport;

class CViewportAS extends CViewport
{
	
	public override function Activate() : Result
	{
		//Glb.g_SystemAS.Viewport( 	m_x * Glb.g_System.m_Display.m_Width,
											//m_y * Glb.g_System.m_Display.m_Height,
											//m_w * Glb.g_System.m_Display.m_Width,
											//m_h * Glb.g_System.m_Display.m_Height);
		return SUCCESS;
	}
}
