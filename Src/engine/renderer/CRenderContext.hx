/**
 * ...
 * @author de
 */

 
package renderer;

import CDebug;
import CTypes;
import kernel.Glb;

import renderer.CMaterial;
import renderer.CPrimitive;
import renderer.CRenderStates;
import renderer.CRscShader;

import renderer.CRenderer;

class CRenderContext 
{
	public var m_CurrentViewport	: Int;
	
	public var m_CurrentMaterial	(default, set_m_CurrentMaterial) 	: CMaterial;
	public var m_CurrentShader 		(default, set_m_CurrentShader)		: CRscShader;
	public var m_CurrentPrimitive 	(default, set_m_CurrentPrimitive)	: CPrimitive;
	public var m_CurrentRenderState (default, set_m_CurrentRenderState ): CRenderStates;
	
	private var m_FlushFlags : Int;
	
	public static var RC_SHADER_STAGE			(default, never) : Int	= 0;
	public static var RC_MATERIAL_STAGE			(default, never) : Int	= 1;
	public static var RC_PRIMITIVE_STAGE 		(default, never) : Int	= 2;
	public static var RC_RENDER_STATES_STAGE	(default, never) : Int	= 3;
	public static var VERBOSE					(default, never) : Bool	= false;	
	
	public function new() 
	{
		m_CurrentViewport		= CRenderer.VP_FULLSCREEN;
		ResetProps();
	}
	
	public function Reset()
	{
		ResetProps();
		ResetDevice();
	}
	
	private inline function ResetProps() : Void
	{
		m_CurrentMaterial		= null;
		m_CurrentShader			= null;
		m_CurrentPrimitive		= null;
		m_CurrentRenderState	= null;
		m_FlushFlags			= 0xFFFF;
	}
	
	public function ResetDevice()
	{
		
	}
	
	public function set_m_CurrentRenderState( _Rs : CRenderStates ) : CRenderStates
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
	
	public function set_m_CurrentPrimitive( _Prim :  CPrimitive ) : CPrimitive
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
	
	public function set_m_CurrentShader( _sh : CRscShader ) : CRscShader
	{
		if( _sh != m_CurrentShader)
		{
			if(m_CurrentShader!= null)
			{
				m_CurrentShader.Release(); 
			}
			
			m_CurrentShader = _sh;
			m_FlushFlags = RC_SHADER_STAGE; //completely flushed because of prim and mat linkage
			if (m_CurrentShader != null)
			{
				m_CurrentShader.AddRef();
			}
		}
		
		return m_CurrentShader;
	}
	
	public function set_m_CurrentMaterial( _Mat : CMaterial ) : CMaterial
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
				if(VERBOSE) CDebug.CONSOLEMSG("CGLQuad:unable to activate shdr");
				return FAILURE;
			}
		}
		
		if ( 	((m_FlushFlags & (1 << RC_SHADER_STAGE)  != 0)
		|| 		(m_FlushFlags & (1 << RC_MATERIAL_STAGE) != 0))
		
		&&		(m_CurrentMaterial != null))
		{
			var l_MatActivation : Result = m_CurrentMaterial.Activate();
			if(l_MatActivation==FAILURE)
			{
				if(VERBOSE) CDebug.CONSOLEMSG("CGLQuad:unable to activate material");
				return FAILURE;
			}
		}
		
		if ( 	(m_FlushFlags & (1 << RC_SHADER_STAGE) != 0)
		|| 		(m_FlushFlags & (1 << RC_PRIMITIVE_STAGE) != 0))
		{
			CDebug.ASSERT(m_CurrentPrimitive != null);
			var  l_PrgmLink : Result = m_CurrentShader.LinkPrimitive( m_CurrentPrimitive );
			if(l_PrgmLink==FAILURE)
			{
				if(VERBOSE)  CDebug.CONSOLEMSG("CGLQuad:unable to link prim");
				return FAILURE;
			}
		}
		
		if ( m_FlushFlags & (1 << RC_RENDER_STATES_STAGE ) != 0 )
		{
			CDebug.ASSERT(m_CurrentRenderState != null);
			var  l_RsActivate : Result = m_CurrentRenderState.Activate();
			if(l_RsActivate==FAILURE)
			{
				if(VERBOSE) CDebug.CONSOLEMSG("CGLQuad:unable to activate rs");
				return FAILURE;
			}
		}
		
		m_FlushFlags = 0;
		
		return SUCCESS;
	}
}