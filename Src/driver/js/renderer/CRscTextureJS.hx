/**
 * ...
 * @author de
 */

package driver.js.renderer;

import js.Dom;

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
	}
	
	public override function Activate() : Result
	{
		super.Activate();
		
		if (	m_GlTexture != null
			&&	m_RscImage.m_State == E_STATE.STREAMED)
		{
			FinishGlTexture();
		}
		
		return m_State == E_STATE.STREAMED ? SUCCESS : FAILURE;
	}
	
}