/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.DisplayObject;
import kernel.CTypes;
import kernel.Glb;

import math.CV2D;
import renderer.C2DQuad;

class C2DQuadAS extends C2DQuad
{
	public var  m_DisplayObject	: DisplayObject;	// container
	
	public function new() 
	{
		super();
		m_Visible	= true;
	}

	public override function Activate() : Result
	{
		super.Activate();
		Glb.GetRendererAS().AddToScene( this );
		if ( m_DisplayObject != null )
		{
			Glb.GetRendererAS().AddToSceneAS( m_DisplayObject );
		}
		return SUCCESS;
	}
	
	public override function Shut() : Result
	{
		super.Shut();
		Glb.GetRendererAS().RemoveFromScene( this );
		if ( m_DisplayObject != null )
		{
			Glb.GetRendererAS().RemoveFromSceneAS( m_DisplayObject );
		}
		return SUCCESS;
	}
	
	public override function SetVisible( _Vis : Bool ) : Void
	{
		if ( _Vis != m_Visible )
		{
			super.SetVisible( _Vis );
			m_DisplayObject.visible = _Vis;
		}
	}
	
	public override function SetAlpha( _Value : Float ) : Void
	{
		super.SetAlpha( _Value );
		if ( m_DisplayObject != null )
		{
			m_DisplayObject.alpha = _Value;
			trace ( "alpha " + m_DisplayObject.alpha );
		}
	}
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		if ( m_DisplayObject != null )
		{	
			m_DisplayObject.width	= _Size.x;
			m_DisplayObject.height	= _Size.y;
		}
	}
	
	public override function SetCenterPosition( _Pos : CV2D ) : Void
	{
		super.SetCenterPosition( _Pos );
		if ( m_DisplayObject != null )
		{
			m_DisplayObject.x = GetTL().x;
			m_DisplayObject.y = GetTL().y;
		}
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		super.SetTLPosition( _Pos );
		if ( m_DisplayObject != null )
		{
			m_DisplayObject.x = _Pos.x;
			m_DisplayObject.y = _Pos.y;
		}
	}
	
	public override function SetRelativeCenterPosition( _RefPos : CV2D, _Pos : CV2D ) : Void
	{
		super.SetRelativeCenterPosition( _RefPos, _Pos );
		if ( m_DisplayObject != null )
		{
			m_DisplayObject.x = GetTL().x;
			m_DisplayObject.y = GetTL().y;
		}
	}
	
	public override function SetRelativeTLPosition( _RefPos : CV2D, _Pos : CV2D ) : Void
	{
		super.SetRelativeTLPosition( _RefPos, _Pos );
		if ( m_DisplayObject != null )
		{
			m_DisplayObject.x = GetTL().x;
			m_DisplayObject.y = GetTL().y;
		}
	}
	
	public function IsLoaded()	: Bool
	{
		return  ( m_DisplayObject != null ) ? true : false;
	}
}