/**
 * ...
 * @author de
 */

package driver.js.renderer;



import kernel.CTypes;
import kernel.Glb;

import rsc.CRsc;

import renderer.CMaterial;

import CGL;

class CMaterialJS extends CMaterial
{

	public function new() 
	{
		super();
	}
	
	public override function Activate() : Result 
	{
		var l_GL : CGL = Glb.g_SystemJS.GetGL();
		
		switch( m_Mode )
		{
			case MBM_OPAQUE:
			l_GL.Disable(CGL.BLEND);
			
			case MBM_ADD:
			l_GL.BlendEquation(CGL.FUNC_ADD);
			
			l_GL.Enable(CGL.BLEND);
			l_GL.BlendFunc(CGL.SRC_ALPHA, CGL.ONE);
			l_GL.Enable(CGL.BLEND);
			
			
			case MBM_SUB:
			l_GL.BlendEquation(CGL.FUNC_SUBTRACT);
			l_GL.Enable(CGL.BLEND);
			l_GL.BlendFunc(CGL.SRC_ALPHA, CGL.ONE);
			l_GL.Enable(CGL.BLEND);
	
			
			case MBM_BLEND:
			l_GL.BlendEquation(CGL.FUNC_ADD);
			l_GL.Enable(CGL.BLEND);
			l_GL.BlendFunc(CGL.SRC_ALPHA, CGL.ONE_MINUS_SRC_ALPHA);
			l_GL.Enable(CGL.BLEND);
		}
		
		return super.Activate();
	}
}