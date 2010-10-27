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
		var x = _Pos.x - m_Coordinate.x;
		var y = _Pos.y - m_Coordinate.y;
		
		m_Matrix.translate( x, y );
		
		super.SetPosition( _Pos );
	}
	
	public function GetMatrix() : Matrix
	{
		return m_Matrix.clone();
	}
	
	override public function SetScale( _Value : Float ) : Void
	{
		m_Matrix.scale( _Value, _Value );
		super.SetScale( _Value );
	}
}