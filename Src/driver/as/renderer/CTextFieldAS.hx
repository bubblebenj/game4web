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
		
		return l_Res;
	}
	
	private function CreateTextField() : Void
	{
		var l_Text = m_RscText.GetTextData();
		if ( l_Text != null )
		{
			m_DisplayObject			= new TextField();
			cast( m_DisplayObject, TextField ).text	= l_Text;
			#if DebugInfo
				cast( m_DisplayObject, TextField ).border	= true;
			#end
			cast( m_DisplayObject, TextField ).selectable	= false;
		}
	}
	
	public override function Update() : Result
	{
		if ( 	m_RscText != null
		&& 		m_RscText.m_State == E_STATE.STREAMED )
		{
			if( m_DisplayObject == null )
			{
				CreateTextField();
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
	
	private var m_RscText		: CRscTextAS; 		// content - CRscTextAS !
}