/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Transform;
import flash.Lib;
import kernel.CTypes;
import kernel.Glb;
import math.Constants;
import math.CTrigo;
import renderer.camera.C2DCamera;

import math.CV2D;
import renderer.C2DQuad;

class C2DQuadAS extends C2DQuad
{
	public	var m_DisplayObject	: DisplayObject;	// container
	private var	m_Matrix		: Matrix;
	
	public function new() 
	{
		super();
		m_Matrix	= new Matrix();
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
			if( m_DisplayObject != null )
			{
				m_DisplayObject.visible = _Vis;
			}
		}
	}
	
	private static var s_Matrix	= new Matrix();
	override public function Draw( _Vp : Int ) : Result 
	{
		super.Draw( _Vp );
		
		if ( m_DisplayObject != null )
		{
			// Object matrix
				m_Matrix.identity();
				
				// Set size
				m_Matrix.scale( GetScale().x ,
								GetScale().y );
				
				// place pivot at origine
				m_Matrix.tx	-= ( GetPosition().x - GetTL().x ) * Glb.GetSystem().m_Display.m_Height;
				m_Matrix.ty	-= ( GetPosition().y - GetTL().y ) * Glb.GetSystem().m_Display.m_Height;
				
				// Set rotation
				m_Matrix.rotate( m_Rotation );
				
				// place object at the good place
				m_Matrix.tx	+= GetPosition().x * Glb.GetSystem().m_Display.m_Height;
				m_Matrix.ty	+= GetPosition().y * Glb.GetSystem().m_Display.m_Height;
			
			s_Matrix	= m_Matrix.clone();
			// Add camera transformation
			if ( m_Camera != null )
			{
				//trace( m_Camera.m_Coordinate.ToString() + " " );
				s_Matrix.concat( cast( m_Camera, C2DCameraAS ).GetMatrix() );
			}
			
			m_DisplayObject.transform.matrix = s_Matrix;
		}
		
		return SUCCESS;
	}
	
	public override function SetAlpha( _Value : Float ) : Void
	{
		super.SetAlpha( _Value );
		if ( m_DisplayObject != null )
		{
			m_DisplayObject.alpha = _Value;
		}
	}
	
	public function IsLoaded()	: Bool
	{
		return  ( m_DisplayObject != null ) ? true : false;
	}
	
	public function GetNonTransformedPoint( _WorldV2D : CV2D, _PointOut : CV2D ) : Void
	{
		var l_flashV2D : Point	= new Point(	_WorldV2D.x * Glb.GetSystem().m_Display.m_Height,
												_WorldV2D.y * Glb.GetSystem().m_Display.m_Height );
		s_Matrix	= m_Matrix.clone();
		s_Matrix.invert();
		l_flashV2D				= s_Matrix.transformPoint( l_flashV2D );
		
		_PointOut.Set(	l_flashV2D.x / Glb.GetSystem().m_Display.m_Height,
						l_flashV2D.y / Glb.GetSystem().m_Display.m_Height );
	}
	
	// debug functions
	public override function DebugInfo( ?_Prefix : String ) : Void
	{
		super.DebugInfo( _Prefix );
		if ( m_DisplayObject != null )
		{
			trace( _Prefix + " " + this +", "+ m_DisplayObject +", \t Pos: [" + m_DisplayObject.x +", "+ m_DisplayObject.y +"], Sz: [" + m_DisplayObject.width + " " + m_DisplayObject.height +"]");
		}
		else
		{
			trace( _Prefix + " " + this + "m_DisplayObject not initialize" );
		}
	}
}