/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import driver.as.rsc.CRscImageAS;

import kernel.CTypes;
import kernel.CDebug;
import kernel.Glb;

import math.CV2D;
import renderer.C2DImage;
import rsc.CRscMan;
import rsc.CRscImage;

class C2DImageAS extends C2DImage
{
	private var m_RscImage : CRscImageAS;
	
	public function new()
	{
		super();
		//m_RscImage	= null;
	}
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		m_RscImage = cast( l_RscMan.Load( CRscImage.RSC_ID , _Path ), CRscImageAS );
		if( m_RscImage  != null)
		{
			//CDebug.CONSOLEMSG("create m_RscImage");
			m_RscImage.Initialize();
		}
		else 
		{
			//CDebug.CONSOLEMSG("unable tp create m_RscImage");
		}
		var l_Res = (m_RscImage != null) ? SUCCESS : FAILURE;
		
		return l_Res;
	}
	
	public override function SetVisible( _Vis : Bool ) : Void
	{
		super.SetVisible( _Vis );
		
		if( m_Visible )
		{
			Glb.GetRendererAS().AddToSceneAS( m_RscImage.m_FlashImage );
		}
		else
		{
			Glb.GetRendererAS().RemoveFromSceneAS( m_RscImage.m_FlashImage );
		}
	}
	
	/* Suposed to be centered... a parameter would be great
	 * to choose between centered or TL position */
	public override function SetPosition( _Pos : CV2D ) : Void
	{
		super.SetPosition( _Pos );
		m_RscImage.SetPosition( m_Rect.m_TL );
	}
	
	// We suppose that the 2DQuad is already centered
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		//resize
		if ( m_RscImage == null )
		{
			//trace(" /!\\ m_RscImage not created yet. Skipping its resizing ");
		}
		else
		{
			m_RscImage.SetSize( _Size );
			m_RscImage.SetPosition( m_Rect.m_TL );
		}
	}
	
	public function GetRscImage() : CRscImage
	{
		return m_RscImage;
	}
}