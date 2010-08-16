/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.DisplayObject;
import math.CV2D;

import renderer.C2DQuad;
import kernel.CTypes;
import kernel.Glb;


class C2DQuadAS extends C2DQuad
{
	private	var	m_DisplayObject		: DisplayObject;
	
	public function new()
	{
		super();
	}
	
	public override function SetVisible( _Vis : Bool ) : Void 
	{
		super.SetVisible( _Vis );
		
		if( m_Visible )
		{
			Glb.GetRendererAS().AddToSceneAS( m_DisplayObject );
		}
		else
		{
			Glb.GetRendererAS().RemoveFromSceneAS( m_DisplayObject );
		}
	}
	
	public function SetDisplayObject( _Obj ) : Void
	{
		m_DisplayObject = _Obj;
	}
	
	public function GetDisplayObject() : DisplayObject
	{
		return m_DisplayObject;
	}
	
	public override function Draw( _Vp : Int ) : Result
	{
		return SUCCESS;
	}
	
	public override function MoveTo( _Pos : CV2D ) : Void
	{
		super.MoveTo( _Pos );
		m_DisplayObject.x	= m_Rect.m_TL.x;
		m_DisplayObject.y	= m_Rect.m_TL.y;
	}
	
	// We suppose that the 2DQuad is already centered
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		//resize
		if ( m_DisplayObject == null )
		{
			trace(" /!\\ m_DisplayObject not created yet. Skipping its resizing ");
		}
		else
		{
			m_DisplayObject.width	= m_Rect.m_BR.x - m_Rect.m_TL.x;
			m_DisplayObject.height	= m_Rect.m_BR.y - m_Rect.m_TL.y;
		// move to keep the center right
			m_DisplayObject.x	= m_Rect.m_TL.x;
			m_DisplayObject.y	= m_Rect.m_TL.y;
		}
	}
}