/**
 * ...
 * @author bd
 */

package driver.as.renderer;

import flash.geom.Matrix;
import flash.geom.Point;
import kernel.CDebug;

import math.CV2D;

import kernel.Glb;
import renderer.camera.C2DCamera;

class C2DCameraAS extends C2DCamera
{
	private	var m_Matrix	: Matrix;
	
	public function new() 
	{
		super();
		m_Matrix	= new Matrix();
		m_Matrix.identity();
	}
	
	public	override function SetPosition( _Pos : CV2D ) : Void
	{
		super.SetPosition( _Pos );
		UpdateMatrix();
	}
	
	public	override function SetScale( _Value : Float ) : Void
	{
		super.SetScale( _Value );
		UpdateMatrix();
	}
	
	private function UpdateMatrix() : Void
	{
		m_Matrix.identity();
		m_Matrix.tx	= -m_Coordinate.x * Glb.GetSystem().m_Display.m_Height + 0.5 * Glb.GetSystem().m_Display.m_Width;
		m_Matrix.ty	= -m_Coordinate.y * Glb.GetSystem().m_Display.m_Height + 0.5 * Glb.GetSystem().m_Display.m_Height;
		m_Matrix.scale( m_Scale, m_Scale );
	}
	
	public function GetMatrix() : Matrix
	{
		return m_Matrix;
	}
	
	private static var s_FlashPoint	: Point	= new Point();
	public override function GetProjectionPoint( _WorldPos : CV2D, _PointOut : CV2D ) : Void
	{
		s_FlashPoint.x	=	-_WorldPos.x * Glb.GetSystem().m_Display.m_Height;
		s_FlashPoint.y	=	-_WorldPos.y * Glb.GetSystem().m_Display.m_Height;
		var l_Matrix 	= m_Matrix;
		l_Matrix.invert();
		s_FlashPoint	= m_Matrix.transformPoint( s_FlashPoint );
		_PointOut.Set( -s_FlashPoint.x / Glb.GetSystem().m_Display.m_Height, -s_FlashPoint.y / Glb.GetSystem().m_Display.m_Height );
	}
	
	public override function GetWorldPosition( _ViewportPos : CV2D, _PointOut : CV2D ) : Void
	{
		
		CDebug.ASSERT( true );
		//s_FlashPoint.x	=	-_ViewportPos.x * Glb.GetSystem().m_Display.m_Height;
		//s_FlashPoint.y	=	-_ViewportPos.y * Glb.GetSystem().m_Display.m_Height;
		//var l_Matrix 	= m_Matrix;
		//s_FlashPoint	= m_Matrix.transformPoint( s_FlashPoint );
		//_PointOut.Set( -s_FlashPoint.x / Glb.GetSystem().m_Display.m_Height, -s_FlashPoint.y / Glb.GetSystem().m_Display.m_Height );
	}
}