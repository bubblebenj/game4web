/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.Bitmap;
import driver.as.rsc.CRscImageAS;
import math.CV4D;
import math.Registers;


import math.CV2D;

import kernel.CTypes;
import kernel.CDebug;
import kernel.Glb;

import renderer.I2DImage;

import rsc.CRscMan;
import rsc.CRsc;
import rsc.CRscImage;

class C2DImageAS extends C2DQuadAS, implements I2DImage 
{
	public function new()
	{
		super();
		m_DisplayObject	= null;
		m_RscImage		= null;
		m_Visible		= false;
		m_UV = new CV4D(0,0,1,1);
	}

	private var m_UV : CV4D;
	
	public function SetUV( _u : CV2D , _v : CV2D ) : Void
	{
		m_UV.CopyV2D(_u, _v );
	}
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		var l_Res = SetRsc( cast( l_RscMan.Load( CRscImage.RSC_ID , _Path ), CRscImageAS ) );
		
		return l_Res;
	}
	
	public function SetRsc( _Rsc : CRscImage )	: Result
	{
		m_RscImage = cast ( _Rsc, CRscImageAS );
		var l_Res = (m_RscImage != null) ? SUCCESS : FAILURE;
		
		return l_Res;
	}
	
	public override function Update() : Result
	{
		if ( 	m_RscImage != null
		&& 		m_RscImage.m_State == E_STATE.STREAMED )
		{
			if( m_DisplayObject == null )
			{
				m_DisplayObject = m_RscImage.CreateBitmap();
				if ( CV2D.AreEqual( GetSize(), CV2D.ZERO ) )
				{
					Registers.V2_8.Set( m_DisplayObject.width, m_DisplayObject.height );
					SetSize( Registers.V2_8 );
				}
				else
				{
					SetSize( GetSize() );
				}
				SetCenterPosition( GetCenter() );
				SetVisible( m_Visible );
				if ( m_Activated )
				{
					Glb.GetRendererAS().AddToSceneAS( m_DisplayObject );	
				}
			}
			else
			{
				SetVisible( m_Visible );
			}
		}
		return SUCCESS;
	}
	
	private var m_RscImage		: CRscImageAS;	// content
}