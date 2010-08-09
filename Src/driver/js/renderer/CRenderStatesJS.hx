/**
 * ...
 * @author de
 */

package driver.js.renderer;

import CGL;

import driver.js.kernel.CSystemJS;

import kernel.Glb;
import kernel.CTypes;
import renderer.CRenderStates;

class CRenderStatesJS extends CRenderStates
{
	public function new() 
	{
		super();
	}
	
	public override function Activate() : Result
	{
		var l_GL : CGL = Glb.g_SystemJS.GetGL();
		
		switch( m_ZEq )
		{
			case Z_GREATER:
			l_GL.DepthFunc(CGL.GREATER);
			
			case Z_GREATER_EQ:
			l_GL.DepthFunc(CGL.GEQUAL);
		}
		
		if( m_ZRead )
		{
			l_GL.Enable(CGL.DEPTH_TEST);
		}
		else
		{
			l_GL.Disable(CGL.DEPTH_TEST);
		}
		
		l_GL.DepthMask(m_ZWrite ? true : false);
		
		return SUCCESS;
	}
}