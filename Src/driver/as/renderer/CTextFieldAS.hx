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
			var l_Size : CV2D	= CV2D.NewCopy( GetSize() );
			
			// initializing Scale value
			SetSize( new CV2D(	m_DisplayObject.width	/ Glb.GetSystem().m_Display.m_Height,
								m_DisplayObject.height	/ Glb.GetSystem().m_Display.m_Height) );
			m_Scale.Set( 1, 1 );
			
			if ( CV2D.AreNotEqual( l_Size, CV2D.ZERO ) )
			{
				// Update size if a size was already set
				var l_x : Float = 0;
				var l_y : Float = 0;
				l_x	= ( l_Size.x == 0 ) ? l_Size.y * m_DisplayObject.width / m_DisplayObject.height : l_Size.x;
				l_y	= ( l_Size.y == 0 ) ? l_Size.x * m_DisplayObject.height / m_DisplayObject.width : l_Size.y;
				SetSize( new CV2D( l_x, l_y ) );
			}
			
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