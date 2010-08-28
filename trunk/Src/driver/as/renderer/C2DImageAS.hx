/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.Bitmap;
import driver.as.rsc.CRscImageAS;


import math.CV2D;

import kernel.CTypes;
import kernel.CDebug;
import kernel.Glb;

import renderer.C2DImage;

import rsc.CRscMan;
import rsc.CRsc;
import rsc.CRscImage;

class C2DImageAS extends C2DImage
{
	public function new()
	{
		super();
		
		m_Bmp		= null;
		m_RscImage	= null;
	}
	
	public override function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		var l_Res = SetRsc( cast( l_RscMan.Load( CRscImage.RSC_ID , _Path ), CRscImageAS ) );
		
		return l_Res;
	}
	
	public override function SetRsc( _Rsc : CRscImage )	: Result
	{
		super.SetRsc(_Rsc);
		m_RscImage = cast ( _Rsc, CRscImageAS );
		var l_Res = (m_RscImage != null) ? SUCCESS : FAILURE;
		
		Glb.GetRendererAS().AddToScene( this );
		return l_Res;
	}
	
	public override function Update() : Result
	{
		if ( 	m_RscImage != null
		&& 		m_RscImage.m_State == E_STATE.STREAMED )
		{
			//CDebug.CONSOLEMSG("Stream finished");
			if( m_Bmp == null )
			{
				m_Bmp = m_RscImage.CreateBitmap(); 
				SetVisible(true);
				CDebug.CONSOLEMSG("Activating" + m_Bmp);
			}
		}
		return SUCCESS;
	}
	
	public override function Activate() : Result
	{
		return SUCCESS;
	}	
	
	public function Shut() : Result
	{
		Glb.GetRendererAS().RemoveFromScene( this );
		Glb.GetRendererAS().RemoveFromSceneAS( m_Bmp );
		return SUCCESS;
	}
	
	public override function SetVisible( _Vis : Bool ) : Void
	{
		super.SetVisible( _Vis );
		
		m_Bmp.visible = _Vis;
		Glb.GetRendererAS().AddToSceneAS( m_Bmp );
	}
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		if ( m_Bmp != null )
		{	
			m_Bmp.width		= _Size.x;
			m_Bmp.height	= _Size.y;
		}
	}
	
	public override function SetCenterPosition( _Pos : CV2D ) : Void
	{
		super.SetCenterPosition( _Pos );
		if (m_Bmp != null)
		{
			m_Bmp.x	= GetTL().x;
			m_Bmp.y	= GetTL().y;
		}
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		super.SetTLPosition( _Pos );
		if (m_Bmp != null)
		{
			m_Bmp.x = _Pos.x;
			m_Bmp.y = _Pos.y;
		}
	}
	
	private var m_Bmp		: Bitmap;		// container
	private var m_RscImage	: CRscImageAS;	// content
}