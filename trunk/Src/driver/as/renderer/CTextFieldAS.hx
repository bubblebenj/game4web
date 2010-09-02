/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import driver.as.rsc.CRscTextAS;
import flash.text.TextField;
import math.Registers;

import kernel.CTypes;
import kernel.Glb;

import math.CV2D;
import renderer.ITextField;

import rsc.CRsc;
import rsc.CRscMan;
import rsc.CRscText;

class CTextFieldAS extends C2DQuadAS, implements ITextField 
{
	public function new()
	{
		super();
		m_DisplayObject	= null;
		m_RscText		= null;
		m_Visible		= false;
	}
	
	public function Load( _Path )	: Result
	{
		var l_RscMan : CRscMan = Glb.g_System.GetRscMan();
		
		var l_Res = SetRsc( cast( l_RscMan.Load( CRscText.RSC_ID , _Path ), CRscTextAS ) );
		
		return l_Res;
	}
	
	public function SetRsc( _Rsc : CRscText )	: Result
	{
		m_RscText = cast ( _Rsc, CRscTextAS );
		var l_Res = ( m_RscText != null) ? SUCCESS : FAILURE;
		
		Glb.GetRendererAS().AddToScene( this );
		return l_Res;
	}
	
	public override function Update() : Result
	{
		if ( 	m_RscText != null
		&& 		m_RscText.m_State == E_STATE.STREAMED )
		{
			if(  m_DisplayObject == null )
			{
				m_DisplayObject = m_RscText.CreateText();
				if ( GetSize().x == 0 && GetSize().y == 0 )
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
				Glb.GetRendererAS().AddToSceneAS( cast ( m_DisplayObject, TextField ) );	
			}
			else
			{
				SetVisible( m_Visible );
			}
		}
		return SUCCESS;
	}
	
	private var m_RscText		: CRscTextAS; 		// content - CRscTextAS !
}