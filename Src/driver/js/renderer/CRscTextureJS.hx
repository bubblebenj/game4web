/**
 * ...
 * @author de
 */

package driver.js.renderer;

import driver.js.rsc.CRscShaderProgram;
import js.Dom;
import renderer.CRenderContext;
import renderer.CRscShader;

import kernel.CSystem;
import kernel.CTypes;
import kernel.Glb;
import kernel.CDebug;

import renderer.CRscTexture;

import rsc.CRsc;
import rsc.CRscImage;

import CGL;

class CRscTextureJS extends CRscTexture
{
	var m_GlTexture : WebGLTexture;
	var m_InDevice : Bool;
	
	public function new() 
	{
		super();
		m_GlTexture = null;
		m_InDevice = false;
	}
	
	public function FinishGlTexture() : Void
	{
		var l_Gl = Glb.g_SystemJS.GetGL();
		
		m_GlTexture = l_Gl.CreateTexture();
		l_Gl.BindTexture	(CGL.TEXTURE_2D, m_GlTexture);
		//l_Gl.PixelStorei	(CGL.UNPACK_FLIP_Y_WEBGL, CGL.TRUE );
		l_Gl.TexImage2D		(CGL.TEXTURE_2D, 0, CGL.RGBA, CGL.RGBA, CGL.UNSIGNED_BYTE, cast( m_RscImage, CRscImageJS).GetDriverImage() );
		l_Gl.TexParameteri	(CGL.TEXTURE_2D, CGL.TEXTURE_MAG_FILTER, CGL.LINEAR);
		l_Gl.TexParameteri	(CGL.TEXTURE_2D, CGL.TEXTURE_MIN_FILTER, CGL.LINEAR);
		l_Gl.BindTexture	(CGL.TEXTURE_2D, null);
		
		var l_Err = Glb.g_SystemJS.GetGL().GetError();
		if ( l_Err  != 0)
		{
			CDebug.CONSOLEMSG("GlError:PostCreateTexture:" + l_Err);
		}
		
		m_State = STREAMED;
		m_InDevice = true;
		CDebug.CONSOLEMSG("Created GL tex : "+ m_GlTexture);
	}
	
	public function IsInDevice() : Bool
	{
		return m_InDevice;
	}
	
	public override function Activate( ?_Stage : Int ) : Result
	{
		super.Activate(_Stage);
		
		if (	m_GlTexture == null
			&&	m_RscImage.m_State == E_STATE.STREAMED)
		{
			FinishGlTexture();
		}
		
		if( IsInDevice() )
		{
			var l_Gl : CGL = Glb.g_SystemJS.GetGL();
			var l_Stage = 0;
			if (_Stage != null)
			{
				l_Stage = _Stage;
			}
			l_Gl.ActiveTexture(CGL.TEXTURE0 + l_Stage );
			
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:PostActiveTexture:"+l_Stage+":" + l_Err);
			}
			l_Gl.BindTexture(CGL.TEXTURE_2D, m_GlTexture);
			var l_Err = Glb.g_SystemJS.GetGL().GetError();
			if ( l_Err  != 0)
			{
				CDebug.CONSOLEMSG("GlError:PostBindTexture:" + l_Err);
			}
			
			var l_Ctxt : CRenderContext = Glb.GetRenderer().m_RenderContext;
			
			var l_Shdr : CRscShader = l_Ctxt.m_CurrentShader;
			
			if (l_Shdr != null) 
			{
				var l_Shdr : CRscShaderProgram = cast l_Shdr; 
				var l_Res = l_Shdr.SetUniform1i( Glb.GetRendererJS().m_GLPipeline.GetTexSamplerName(_Stage), _Stage == null ? 0 : _Stage );
				
				//might return success if uniform wan't fetched but failure would induce shade rnot handling the call
				if ( l_Res != SUCCESS )
				{
					CDebug.CONSOLEMSG("G4W:Error:ShaderCall:SetUniform1i:" + l_Err);
				}
			}
		}
		
		if( IsInDevice() && IsStreamed())
		{
			return SUCCESS;
		}
		
		CDebug.CONSOLEMSG("Failed to activate : Tex Status : IsInDevice: " + IsInDevice() + " Streamed " + IsStreamed() + " Image Steamed : " +m_RscImage.IsStreamed());
		
		return FAILURE;
	}
	
	public override function OnDeletion()
	{
		if (m_GlTexture != null)
		{
			var l_Gl :CGL = Glb.g_SystemJS.GetGL();
		
			l_Gl.DeleteTexture(m_GlTexture);
			m_GlTexture = null;
			m_InDevice = false;
		}
	}
}