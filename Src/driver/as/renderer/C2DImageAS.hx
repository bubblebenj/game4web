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
		
		m_Bmp		=  null;
		m_RscImage	= null;
	}
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_RscImage = cast( l_RscMan.Load( CRscImage.RSC_ID , _Path ), CRscImageAS );
		var l_Res = (m_RscImage != null) ? SUCCESS : FAILURE;
		
		Glb.GetRendererAS().AddToScene( this );
		return l_Res;
	}
	
	public override function Activate() : Result
	{
		return SUCCESS;
	}
	
	public override function Update() : Result
	{
		
		if ( 	m_RscImage != null
		&& 		m_RscImage.GetState() == E_STATE.STREAMED )
		{
			//CDebug.CONSOLEMSG("Stream finished");
			if( m_Bmp == null )
			{
				m_Bmp = m_RscImage.CreateBitmap(); 
				
				SetVisible(true);
				//CDebug.CONSOLEMSG("Activating" + m_Bmp);
			}
		}
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
	
	public override function SetPosition( _Pos : CV2D ) : Void
	{
		super.SetPosition( _Pos );
		
		if (m_Bmp != null)
		{
			m_Bmp.x = m_Rect.m_TL.x;
			m_Bmp.y = m_Rect.m_TL.y;
		}
	}
	
	public function IsReady() : Bool 
	{
		return m_Bmp != null;
	}
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		
		//resize
		if ( m_Bmp != null )
		{	
			m_Bmp.width = _Size.x;
			m_Bmp.height = _Size.y;
			
			m_Bmp.x = m_Rect.m_TL.x;
			m_Bmp.y = m_Rect.m_TL.y;
		}
	}
	
	private var m_Bmp		: Bitmap;		// container
	private var m_RscImage	: CRscImageAS;	// content
}