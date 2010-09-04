/**
 * ...
 * @author de
 */

package driver.js.renderer;

import js.Dom;
import renderer.CRenderContext;
import renderer.CRscShader;

import kernel.CSystem;
import kernel.CTypes;
import kernel.Glb;

import renderer.CRscTexture;

import rsc.CRsc;
import rsc.CRscImage;

import CGL;

class CRscTextureJS extends CRscTexture
{
	var m_GlTexture : WebGLTexture;
	var m_Uploaded : Bool ;
	
	public function new() 
	{
		super();
		m_GlTexture = null;
	}
	
	public function FinishGlTexture() : Void
	{
		var l_Gl = Glb.g_SystemJS.GetGL();
		
		m_GlTexture = l_Gl.CreateTexture();
		l_Gl.BindTexture	(CGL.TEXTURE_2D, m_GlTexture);
		l_Gl.PixelStorei	(CGL.UNPACK_FLIP_Y_WEBGL, CGL.TRUE );
		l_Gl.TexImage2D		(CGL.TEXTURE_2D, 0, CGL.RGBA, CGL.RGBA, CGL.UNSIGNED_BYTE, cast( m_RscImage, CRscImageJS).GetDriverImage() );
		l_Gl.TexParameteri	(CGL.TEXTURE_2D, CGL.TEXTURE_MAG_FILTER, CGL.LINEAR);
		l_Gl.TexParameteri	(CGL.TEXTURE_2D, CGL.TEXTURE_MIN_FILTER, CGL.LINEAR_MIPMAP_LINEAR);
		l_Gl.BindTexture	(CGL.TEXTURE_2D, null);
		
		m_State = STREAMED;
		
		m_Uploaded = true;
	}
	
	public function IsUploaded() : Bool
	{
		return m_Uploaded;
	}
	
	public override function Activate( ?_Stage : Int ) : Result
	{
		super.Activate(_Stage);
		
		if (	m_GlTexture != null
			&&	m_RscImage.m_State == E_STATE.STREAMED)
		{
			FinishGlTexture();
		}
		
		if( IsUploaded() )
		{
			var l_Gl : CGL = Glb.g_SystemJS.GetGL();
			
			l_Gl.ActiveTexture(CGL.TEXTURE0 + _Stage );
			l_Gl.BindTexture(CGL.TEXTURE_2D, m_GlTexture);
			
			var l_Ctxt : CRenderContext = Glb.GetRenderer().m_RenderContext;
			
			var l_Shdr : CRscShader = l_Ctxt.m_CurrentShader;
			
			if (l_Shdr != null) 
			{
				l_Shdr.SetUniform1i( Glb.GetRendererJS().m_GLPipeline.GetTexCooName(_Stage), _Stage == null ? 0 : _Stage );
			}
		}
		
		if( IsUploaded() && IsStreamed())
		{
			return SUCCESS;
		}
		
		return FAILURE;
	}
	
	public override function OnDeletion()
	{
			if (m_GlTexture != null)
			{
				var l_Gl :CGL = Glb.g_SystemJS.GetGL();
			
				l_Gl.DeleteTexture(m_GlTexture);
				m_GlTexture = null;
			}
	}
}