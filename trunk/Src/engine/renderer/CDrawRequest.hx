/**
 * ...
 * @author de
 */

package driver.js.renderer;
import renderer.CDrawObject;
import renderer.CRenderStates;

class CDrawRequest 
{
	public function new() 
	{
		m_Mat = null;
		m_Prim = null;
		m_RenderState = null;
	}
	
	var m_Mat : CMaterial;
	var m_Prim : CPrimitive;
	var m_RenderState : CRenderStates;
	var m_DrawObject : CDrawObject;
	
}