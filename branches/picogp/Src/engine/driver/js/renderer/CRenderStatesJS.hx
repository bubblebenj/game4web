/**
 * ...
 * @author de
 */

package driver.js.renderer;

import CGL;

import driver.js.kernel.CSystemJS;

import kernel.Glb;
import CTypes;
import renderer.CRenderStates;

class CRenderStatesJS extends CRenderStates
{
	public function new() 
	{
		super();
		
		m_ZEq = Z_LESSER_EQ;
		m_ZRead = true;
		m_ZWrite = false;
	}
	
	public override function Activate() : Result
	{
		var l_GL : CGL = Glb.g_SystemJS.GetGL();
		
		if( m_ZRead )
		{
			l_GL.Enable(CGL.DEPTH_TEST);
		}
		else
		{
			l_GL.Disable(CGL.DEPTH_TEST);
		}
		
		switch( m_ZEq )
		{
			case Z_LESSER:
			l_GL.DepthFunc( CGL.LESS);
			
			case Z_LESSER_EQ:
			l_GL.DepthFunc( CGL.LEQUAL  );
			
			case Z_GREATER:
			l_GL.DepthFunc( CGL.GREATER);
			
			case Z_GREATER_EQ:
			l_GL.DepthFunc( CGL.GEQUAL);
		}
		
		l_GL.DepthMask(m_ZWrite ?CGL.TRUE : CGL.FALSE);
	
		return SUCCESS;
	}
}