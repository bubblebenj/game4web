/**
 * ...
 * @author bd
 */

package driver.as.renderer;

import flash.geom.Matrix;
import flash.geom.Point;
import CDebug;

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
		m_Matrix.tx	= -m_Coordinate.x * Glb.GetSystem().m_Display.m_Height + 0.5 * Glb.GetSystem().m_Display.m_Width * ( 1 / m_Scale );
		m_Matrix.ty	= -m_Coordinate.y * Glb.GetSystem().m_Display.m_Height + 0.5 * Glb.GetSystem().m_Display.m_Height * ( 1 / m_Scale );
		m_Matrix.scale( m_Scale, m_Scale );
	}
	
	public function GetMatrix() : Matrix
	{
		return m_Matrix;
	}
	
	/**
	 * // Doesn't actually world value should be divided by the world scale factor
	 * 
	 * Return the screen/viewport coordinates (cartesian homogenenized : height = 1)
	 * @param	_WorldPos is the position of the object in the world
	 * @param	_PointOut is the position of the object in the viewport
	 */
	public override function GetProjectionPoint( _WorldPos : CV2D, _PointOut : CV2D ) : Void
	{
		CDebug.CONSOLEMSG( "GetProjectionPoint( " + _WorldPos +", " + _PointOut +")" );
		_PointOut.Set(	( _WorldPos.x - m_Coordinate.x + Glb.GetSystem().m_Display.GetAspectRatio() * 0.5 ),
						( _WorldPos.y - m_Coordinate.y + 0.5 ) );
		//_PointOut.Set(	( _WorldPos.x / worldScaleValue - m_Coordinate.x + Glb.GetSystem().m_Display.GetAspectRatio() * 0.5 ),
						//( _WorldPos.y / worldScaleValue - m_Coordinate.y + 0.5 ) );
	}
	
	public override function GetWorldPosition( _ViewportPos : CV2D, _PointOut : CV2D ) : Void
	{
		CDebug.CONSOLEMSG( "GetWorldPosition( " + _ViewportPos +", " + _PointOut +")" );
		_PointOut.Set(	( _ViewportPos.x + m_Coordinate.x - Glb.GetSystem().m_Display.GetAspectRatio() * 0.5 ),
						( _ViewportPos.y + m_Coordinate.y - 0.5 ) );
	}
}