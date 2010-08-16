/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import driver.as.renderer.C2DQuadAS;
import driver.as.rsc.CRscImageAS;

import flash.display.Bitmap;
import flash.events.Event;
import flash.display.Loader;
import flash.net.URLRequest;

import kernel.CTypes;
import kernel.Glb;
import math.CV2D;
import renderer.C2DImage;

class C2DImageAS extends C2DImage
{
	private var m_FlashImage : CRscImageAS;
	
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
	
	public override function SetPosition( _Pos : CV2D ) : Void
	{
		m_2DQuad.SetPosition( _Pos );
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