/**
 * ...
 * @author de
 */

package renderer;

import kernel.CTypes;

import rsc.CRsc;
import rsc.CRscMan;


enum MAT_BLEND_MODE
{
	MBM_ADD;
	MBM_SUB;
	MBM_BLEND;
	MBM_OPAQUE;
}

class CMaterial extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public function new() 
	{
		super();
		
		m_Mode = MBM_OPAQUE;
		m_Alpha = 1;
		m_Textures = new Array<CRscTexture>();
	}
	
	public function Activate()  : Result
	{
		if ( m_Shader.Activate() == FAILURE )
		{
			return FAILURE;
		}
		
		//if( m_Textures[0] != null )
		
		for( l_Texes in m_Textures )
		{
			if ( l_Texes.Activate() == FAILURE)
			{
				return FAILURE;
			}
		}
		
		return SUCCESS;
	}
	
	public function SetBlendMode( _Mode )  : Void
	{
		m_Mode = _Mode;	
	}
	
	public function SetShader( _Sh : CRscShader ) : Void
	{
		if ( m_Shader != null )
		{
			m_Shader.Release();
			m_Shader = null;
		}
		
		if( _Sh != null )
		{
			_Sh.AddRef();
		}
		
		m_Shader = _Sh;
	}
	
	public function HasTexture() : Bool
	{
		return m_Textures.length > 0;
	}
	
	public function GetTextureCount() : Int
	{
		return m_Textures.length;
	}
	
	public function GetTexture( _Index:  Int)
	{
		return m_Textures[_Index];
	}
	
	public function AttachTexture( _Index : Int , _Tex : CRscTexture ) : Void
	{
		if ( _Tex != null)
		{
			_Tex.AddRef();
		}
		
		if ( m_Textures[_Index] != null )
		{
			m_Textures[_Index].Release();
			m_Textures[_Index] = null;
		}
		
		m_Textures[_Index] = _Tex;
	}
	
	var m_Alpha : Float;
	var m_Mode : MAT_BLEND_MODE;
	var m_Shader : CRscShader;
	var m_Textures : Array<CRscTexture>;
}