/**
 * ...
 * @author Benjamin Dubois
 */

package driver.as.renderer;
import flash.geom.Matrix;
import math.CV2D;
import renderer.camera.C2DCamera;

class C2DCameraAS extends C2DCamera
{
	public var m_Matrix	: Matrix;
	
	public function new() 
	{
		super();
		m_Matrix	= new Matrix();
		m_Matrix.identity;
	}
	
	override public function SetPosition( _Pos : CV2D ) : Void
	{
		CV2D.Sub( _Pos, _Pos, m_Coordinate );
		m_Matrix.translate( _Pos.x, _Pos.y );
	}
	
	public function GetMatrix() : Matrix
	{
		return m_Matrix.clone();
	}
}