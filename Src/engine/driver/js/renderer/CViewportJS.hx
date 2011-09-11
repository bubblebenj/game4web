/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.kernel.CSystemJS;

import kernel.Glb;
import CTypes;
import CDebug;
import kernel.CDisplay;
import kernel.CSystem;

import renderer.CViewport;


class CViewportJS extends CViewport
{
	public function Trace()
	{
		//CDebug.CONSOLEMSG("Vp : x:" + m_x + " y:" + m_y + " w:" + m_w + " h:" + m_h);
		//CDebug.CONSOLEMSG("Dspl : w:" + Glb.g_System.m_Display.m_Width + " h: " + Glb.g_System.m_Display.m_Height);
	}
	public override function Activate() : Result
	{
		Trace();
		
		Glb.g_SystemJS.GetGL().Viewport( 	m_x * Glb.g_System.m_Display.m_Width,
											m_y * Glb.g_System.m_Display.m_Height,
											m_w * Glb.g_System.m_Display.m_Width,
											m_h * Glb.g_System.m_Display.m_Height);
		return SUCCESS;
	}

}