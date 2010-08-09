/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.kernel.CSystemJS;

import kernel.Glb;
import kernel.CTypes;
import kernel.CDisplay;
import kernel.CSystem;

import renderer.CViewport;


class CViewportJS extends CViewport
{
	public override function Activate() : Result
	{
		Glb.g_SystemJS.GetGL().Viewport( 	m_x * Glb.g_System.m_Display.m_Width,
											m_y * Glb.g_System.m_Display.m_Height,
											m_w * Glb.g_System.m_Display.m_Width,
											m_h * Glb.g_System.m_Display.m_Height);
		return SUCCESS;
	}

}