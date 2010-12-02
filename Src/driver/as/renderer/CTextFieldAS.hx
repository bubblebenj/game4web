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
		m_Visible		= false;
		m_Text			= "";
	}
	
	private function CreateTextField() : Void
	{
		m_DisplayObject			= new TextField();
		cast( m_DisplayObject, TextField ).text	= m_Text;
		#if DebugInfo
			cast( m_DisplayObject, TextField ).border	= true;
		#end
		cast( m_DisplayObject, TextField ).selectable	= false;
	}
	
	public function SetText( _Text : String ) : Void
	{
		m_Text	= _Text;
		if ( m_DisplayObject != null )
		{
			cast( m_DisplayObject, TextField ).text	= m_Text;
		}
	}
	
	public override function Update() : Result
	{
		if( m_DisplayObject == null )
		{
			CreateTextField();
			// Update size
			var l_x : Float = 0;
			var l_y : Float = 0;
			if ( CV2D.AreEqual( GetSize(), CV2D.ZERO ) )
			{
				l_x	=	m_DisplayObject.width	/ Glb.GetSystem().m_Display.m_Height;
				l_y	=	m_DisplayObject.height	/ Glb.GetSystem().m_Display.m_Height;
			}
			else
			{
				l_x	= ( GetSize().x == 0 ) ? GetSize().y * m_DisplayObject.width / m_DisplayObject.height : GetSize().x;
				l_y	= ( GetSize().y == 0 ) ? GetSize().x * m_DisplayObject.height / m_DisplayObject.width : GetSize().y;
			}
			SetSize( new CV2D( l_x, l_y ) );
			//
			
			SetPosition( GetPosition() );
			
			SetVisible( m_Visible );
			if ( m_Activated )
			{
				if ( m_DisplayObject.parent == null )
				{
					Glb.GetRendererAS().AddToSceneAS( m_DisplayObject );
				}
			}
		}
		return SUCCESS;
	}
	
	private var m_Text		: String;
}