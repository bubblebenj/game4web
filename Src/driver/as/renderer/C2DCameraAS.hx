/**
 * ...
 * @author bd
 */

package driver.as.renderer;

import flash.geom.Matrix;
import flash.geom.Point;

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
	
	public override function GetProjectionPoint( _V2D : CV2D ) : CV2D
	{
		var l_flashV2D : Point	= new Point(	-_V2D.x * Glb.GetSystem().m_Display.m_Height,
												-_V2D.y * Glb.GetSystem().m_Display.m_Height);
		var l_Matrix 			= m_Matrix;
		l_Matrix.invert();
		l_flashV2D				= m_Matrix.transformPoint( l_flashV2D );
		var l_V2D		: CV2D	= new CV2D( -l_flashV2D.x / Glb.GetSystem().m_Display.m_Height, -l_flashV2D.y / Glb.GetSystem().m_Display.m_Height );
		return l_V2D;
	}
}