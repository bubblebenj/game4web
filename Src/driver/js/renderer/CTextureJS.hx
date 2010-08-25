/**
 * ...
 * @author de
 */

package driver.js.renderer;

import js.Dom;

import kernel.CSystem;
import kernel.CTypes;
import kernel.Glb;

import renderer.CTexture;

import rsc.CRsc;
import rsc.CRscImage;

import CGL;

class CTextureJS extends CTexture
{
	var m_GlTexture : WebGLTexture;
	
	public function new() 
	{
		super();
		m_GlTexture = null;
	}
	
	public function Initialize() : Result
	{
		// 1 - Creation of the loader
		m_State			= STREAMING;
		m_Img = g_System.GetResourceManager().Load( CRscImageJS.RSC_ID, GetPath() );
		
		return SUCCESS;
	}
	
	public function FinishGlTexture()
	{
		var l_Gl = Glb.g_SystemJS.GetGL();
		
		l_Gl.BindTexture	(CGL.TEXTURE_2D, m_GlTexture);
		l_Gl.PixelStorei	(CGL.UNPACK_FLIP_Y_WEBGL, true);
		l_Gl.TexImage2D		(CGL.TEXTURE_2D, 0, CGL.RGBA, CGL.RGBA, CGL.UNSIGNED_BYTE, cast(m_RscImage,CRscImageJS).GetDriverImage() );
		l_Gl.TexParameteri	(CGL.TEXTURE_2D, CGL.TEXTURE_MAG_FILTER, CGL.LINEAR);
		l_Gl.TexParameteri	(CGL.TEXTURE_2D, CGL.TEXTURE_MIN_FILTER, CGL.LINEAR_MIPMAP_LINEAR);
		l_Gl.BindTexture	(CGL.TEXTURE_2D, null);
	}
	
	public override function SetPath( _Path )
	{
		super.SetPath(_Path);
		Initialize();
	}
	
	public override function Activate() : Result
	{
		if (	m_GlTexture != null
			&&	m_RscImage.GetState() == E_STATE.STREAMED)
		{
			FinishGlTexture();
		}
		return SUCCESS;
	}
	
}