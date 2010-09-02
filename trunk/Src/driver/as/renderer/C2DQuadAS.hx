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
	}

	public override function Activate() : Result
	{
		m_Visible	= true;  // /!\ Not SetVisible() --> m_2DObjectAS could not be loaded
		return SUCCESS;
	}
	
	public override function Shut() : Result
	{
		Glb.GetRendererAS().RemoveFromScene( this );
		Glb.GetRendererAS().RemoveFromSceneAS( m_DisplayObject );
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
		if ( m_DisplayObject != null )
		{
			if ( _Pos.x != GetTL().x || _Pos.y != GetTL().y )
			{
				super.SetCenterPosition( _Pos );
				m_DisplayObject.x = GetTL().x;
				m_DisplayObject.y = GetTL().y;
			}
		}
		else
		{
			super.SetTLPosition( _Pos );
		}
	}
	
	public override function SetTLPosition( _Pos : CV2D ) : Void
	{
		if ( m_DisplayObject != null )
		{
			if ( _Pos.x != GetTL().x || _Pos.y != GetTL().y )
			{
				super.SetTLPosition( _Pos );
				m_DisplayObject.x = _Pos.x;
				m_DisplayObject.y = _Pos.y;
			}
		}
		else
		{
			super.SetTLPosition( _Pos );
		}
	}
	
	public function IsLoaded()	: Bool
	{
		return  ( m_DisplayObject != null ) ? true : false;
	}
}