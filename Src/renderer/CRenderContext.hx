/**
 * ...
 * @author de
 */

 
package renderer;

import kernel.CDebug;
import kernel.CTypes;
import kernel.Glb;

import renderer.CMaterial;
import renderer.CPrimitive;
import renderer.CRenderStates;
import renderer.CRscShader;

class CRenderContext 
{
	public var m_CurrentMaterial(default,SetActiveMaterial) : CMaterial;
	public var m_CurrentShader (default, SetActiveShader): CRscShader;
	public var m_CurrentPrimitive (default, SetActivePrimitive): CPrimitive;
	public var m_CurrentRenderState (default, SetActiveRenderStates ): CRenderStates;
	
	private var m_FlushFlags : Int;
	
	public static inline var RC_SHADER_STAGE : Int = 0;
	public static inline var RC_MATERIAL_STAGE : Int = 1;
	public static inline var RC_PRIMITIVE_STAGE : Int = 2;
	public static inline var RC_RENDER_STATES_STAGE : Int = 3;
	
	public function new() 
	{
		m_CurrentMaterial = null;
		m_CurrentShader = null;
		m_CurrentPrimitive = null;
		m_CurrentRenderState = null;
		m_FlushFlags = 0xFFFF;
	}
	
	public function Reset()
	{
		SetActiveMaterial( null );
		SetActiveShader( null );
		SetActivePrimitive( null );
		m_FlushFlags = 0xFFFF;
		
		ResetDevice();
	}
	
	public function ResetDevice()
	{
		
	}
	
	public function SetActiveRenderStates( _Rs : CRenderStates ) : CRenderStates
	{
		if( _Rs != m_CurrentRenderState)
		{
			if(m_CurrentRenderState!= null)
			{
				m_CurrentRenderState.Release(); 
			}
			
			m_CurrentRenderState = _Rs;
			m_FlushFlags = m_FlushFlags | RC_RENDER_STATES_STAGE;
			
			if (m_CurrentRenderState != null)
			{
				m_CurrentRenderState.AddRef();
			}
		}
		
		return m_CurrentRenderState;
	}
	
	public function SetActivePrimitive( _Prim :  CPrimitive ) : CPrimitive
	{
		if( _Prim != m_CurrentPrimitive )
		{
			if(m_CurrentPrimitive!= null)
			{
				m_CurrentPrimitive.Release(); 
			}
			
			m_CurrentPrimitive =_Prim;
			m_FlushFlags = m_FlushFlags | RC_PRIMITIVE_STAGE;
			
			if (m_CurrentPrimitive != null)
			{
				m_CurrentPrimitive.AddRef();
			}
		}
		
		return m_CurrentPrimitive;
	}
	
	public function SetActiveShader( _sh : CRscShader ) : CRscShader
	{
		if( _sh != m_CurrentShader)
		{
			if(m_CurrentShader!= null)
			{
				m_CurrentShader.Release(); 
			}
			
			m_CurrentShader = _sh;
			m_FlushFlags = RC_SHADER_STAGE;//completely flushed because of prim and mat linkage
			if (m_CurrentShader != null)
			{
				m_CurrentShader.AddRef();
			}
		}
		
		return m_CurrentShader;
	}
	
	public function SetActiveMaterial( _Mat : CMaterial ) : CMaterial
	{
		if( _Mat != m_CurrentMaterial)
		{
			if (m_CurrentMaterial != null)
			{
				m_CurrentMaterial.Release();
			}
			
			m_CurrentMaterial = _Mat;
			m_FlushFlags = m_FlushFlags | 1 << RC_MATERIAL_STAGE;
			
			if (m_CurrentMaterial != null)
			{
				m_CurrentMaterial.AddRef();
			}
		}
		
		return m_CurrentMaterial;
	}
	
	public function Activate()
	{
		if( m_FlushFlags & (1 << RC_SHADER_STAGE) != 0 )
		{
			CDebug.ASSERT(m_CurrentShader != null);
			var  l_ShdrActivation : Result = m_CurrentShader.Activate();
			if(l_ShdrActivation==FAILURE)
			{
				CDebug.CONSOLEMSG("CGLQuad:unable to activate shdr");
				return FAILURE;
			}
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:ShaderActivation:"+ l_Err);
			}
		}
		
		if ( 	((m_FlushFlags & (1 << RC_SHADER_STAGE)  != 0)
		|| 		(m_FlushFlags & (1 << RC_MATERIAL_STAGE) != 0))
		
		&&		(m_CurrentMaterial != null))
		{
			var l_MatActivation : Result = m_CurrentMaterial.Activate();
			if(l_MatActivation==FAILURE)
			{
				CDebug.CONSOLEMSG("CGLQuad:unable to activate mat");
				return FAILURE;
			}
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:MatActivation:"+ l_Err);
			}
		}
		
		if ( 	(m_FlushFlags & (1 << RC_SHADER_STAGE) != 0)
		|| 		(m_FlushFlags & (1 << RC_PRIMITIVE_STAGE) != 0))
		{
			CDebug.ASSERT(m_CurrentPrimitive != null);
			var  l_PrgmLink : Result = m_CurrentShader.LinkPrimitive( m_CurrentPrimitive );
			if(l_PrgmLink==FAILURE)
			{
				CDebug.CONSOLEMSG("CGLQuad:unable to link prim");
				return FAILURE;
			}
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:LinkPrimActivation:"+ l_Err);
			}
		}
		
		if ( m_FlushFlags & (1 << RC_RENDER_STATES_STAGE ) != 0 )
		{
			CDebug.ASSERT(m_CurrentRenderState != null);
			var  l_RsActivate : Result = m_CurrentRenderState.Activate();
			if(l_RsActivate==FAILURE)
			{
				CDebug.CONSOLEMSG("CGLQuad:unable to activate rs");
				return FAILURE;
			}
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:RsActivation:"+ l_Err);
			}
		}
		m_FlushFlags = 0;
		
		return SUCCESS;
	}
}