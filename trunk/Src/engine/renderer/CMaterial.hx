/**
 * ...
 * @author de
 */

package renderer;

import CTypes;
import CDebug;
import kernel.Glb;

import rsc.CRsc;
import rsc.CRscMan;


enum MAT_BLEND_MODE
{
	MBM_ADD;
	MBM_SUB;
	MBM_BLEND;
	MBM_OPAQUE;
}

enum MAT_DRAW_SIDE
{
	MDS_DOUBLE_SIDED;
	MDS_FRONT;
	MDS_BACK;
	MDS_NO_DRAW;
}

class CMaterial extends CRsc
{
	public static var 	RSC_ID = CRscMan.RSC_COUNT++;
	public override function GetType() : Int
	{
		return RSC_ID;
	}
	
	public static inline var VERBOSE : Bool = false;
	public function new() 
	{
		super();
		
		m_Mode = MBM_OPAQUE;
		m_Alpha = 1;
		m_Textures = new Array<CRscTexture>();
		m_FillMode = MDS_FRONT;
	}
	
	public function Activate()  : Result
	{
		for( l_Texes in m_Textures )
		{
			if ( l_Texes.Activate() == FAILURE)
			{
				if(VERBOSE)
				{
					CDebug.CONSOLEMSG("V:Unable to activate texture");
				}
				return FAILURE;
			}
		}
		
		return SUCCESS;
	}
	
	public function SetBlendMode( _Mode )  : Void
	{
		m_Mode = _Mode;	
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
	var m_Textures : Array<CRscTexture>;
	var m_FillMode : MAT_DRAW_SIDE;
	
}