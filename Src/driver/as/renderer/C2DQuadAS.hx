/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;

import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Transform;
import kernel.CTypes;
import kernel.Glb;
import math.Constants;
import math.CTrigo;

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
	
	override public function Draw( _Vp : Int ) : Result 
	{
		super.Draw( _Vp );
		
		if( m_DisplayObject != null )
		{
			SetVisible( m_Visible );
			m_DisplayObject.x		= GetTL().x - Glb.GetRenderer().GetCamera( 0 ).GetPosition().x;
			m_DisplayObject.y		= GetTL().y - Glb.GetRenderer().GetCamera( 0 ).GetPosition().y;
			m_DisplayObject.width	= GetSize().x * Glb.GetRenderer().m_Vps[_Vp].GetVpRatio();
			m_DisplayObject.height	= GetSize().y * Glb.GetRenderer().m_Vps[_Vp].GetVpRatio();
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
	
	public override function SetSize( _Size : CV2D ) : Void
	{
		super.SetSize( _Size );
		if ( m_DisplayObject != null )
		{	

		}
	}
	
	private function Rotate( _Rad : Float ) : Void
	{
		if ( ( _Rad % ( 2 * Constants.PI ) ) != 0 )
		{
			//var l_RotationMatrix	= new Matrix();
			//l_RotationMatrix.rotate( _Rad );
			
			var l_Matrix : Matrix	= m_DisplayObject.transform.matrix;
			
			//l_Matrix.concat(l_RotationMatrix);
			
			l_Matrix.tx	-= GetCenter().x;
			l_Matrix.ty	-= GetCenter().y;
			trace( "Rotate("+ CTrigo.RadToDeg(_Rad) );
			l_Matrix.rotate( _Rad );
			l_Matrix.tx	+= GetCenter().x;
			l_Matrix.ty	+= GetCenter().y;
			
			m_DisplayObject.transform.matrix = l_Matrix;
		}
	}
	
	public override function SetRotation( _Rad : Float ) : Void
	{
		
		trace( "SetRotation(" +_Rad );
		
		Rotate( _Rad - GetRotation() );
		super.SetRotation( _Rad );
		//m_RotationMatrix	= m_DisplayObject.transform.matrix;
		//m_RotationMatrix.tx	-= GetCenter().x;
		//m_RotationMatrix.ty	-= GetCenter().y;
		//m_RotationMatrix.rotate( Constants.PI *0.5 );// CTrigo.RadToDeg( _Rad );
		//m_RotationMatrix.tx	+= GetCenter().x;
		//m_RotationMatrix.ty	+= GetCenter().y;
	}
	
	public function IsLoaded()	: Bool
	{
		return  ( m_DisplayObject != null ) ? true : false;
	}
}